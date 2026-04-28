import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/pahlawan_provider.dart';
import '../../core/theme/theme_notifier.dart';

class PahlawanScreen extends StatefulWidget {
  @override
  State<PahlawanScreen> createState() => _PahlawanScreenState();
}

class _PahlawanScreenState extends State<PahlawanScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Perbaikan 1: Tunggu frame pertama selesai di-build sebelum memanggil provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PahlawanProvider>().fetchPahlawans();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<PahlawanProvider>().fetchPahlawans();
      }
    });
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date).toLocal();
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void showGenerateDialog() {
    final themeController = TextEditingController();
    final totalController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<PahlawanProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("✨ Generate Pahlawan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: themeController,
                    decoration: InputDecoration(
                      labelText: "Tema Pahlawan (Misal: Pahlawan Indonesia)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isGenerating ? null : () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () async {
                    await provider.generate(
                      themeController.text,
                      int.parse(totalController.text),
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: provider.isGenerating
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 10),
                      Text("Generating..."),
                    ],
                  )
                      : Text("Generate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PahlawanProvider>();
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Info Pahlawan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.dark_mode), onPressed: theme.toggleTheme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showGenerateDialog,
        icon: Icon(Icons.auto_awesome),
        label: Text("Generate"),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 120),
              itemCount: provider.pahlawans.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.pahlawans.length) {
                  final item = provider.pahlawans[index];
                  final number = index + 1;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF047857)]),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: Offset(0, 6))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("#$number", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8), // Beri sedikit jarak

                            // Perbaikan 2: Gunakan Expanded agar tidak overflow
                            Expanded(
                              child: Text(
                                formatDate(item.createdAt),
                                style: TextStyle(color: Colors.white60, fontSize: 11),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis, // Potong dengan "..." jika kepanjangan
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          item.text,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else {
                  return provider.isLoading
                      ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [CircularProgressIndicator(), SizedBox(height: 8), Text("Loading...")],
                    ),
                  )
                      : SizedBox();
                }
              },
            ),
          ),
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
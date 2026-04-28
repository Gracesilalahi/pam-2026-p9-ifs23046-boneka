import 'package:flutter/material.dart';
import '../data/models/pahlawan_model.dart';
import '../data/services/pahlawan_service.dart';

class PahlawanProvider extends ChangeNotifier {
  List<Pahlawan> pahlawans = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;

  Future<void> fetchPahlawans() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final result = await PahlawanService.getPahlawans(page);
    List data = result["data"];

    if (data.isEmpty) {
      hasMore = false;
    } else {
      pahlawans.addAll(
        data.map((e) => Pahlawan.fromJson(e)).toList(),
      );
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> generate(String theme, int total) async {
    isGenerating = true;
    notifyListeners();

    try {
      await PahlawanService.generatePahlawans(theme, total);

      pahlawans.clear();
      page = 1;
      hasMore = true;

      await fetchPahlawans();
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}
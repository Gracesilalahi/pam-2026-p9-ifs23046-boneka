import 'package:flutter/material.dart';
import '../data/models/boneka_model.dart';
import '../data/services/boneka_service.dart';

class BonekaProvider extends ChangeNotifier {
  List<Boneka> bonekas = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;

  Future<void> fetchBonekas() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final result = await BonekaService.getBonekas(page);
    List data = result["data"];

    if (data.isEmpty) {
      hasMore = false;
    } else {
      bonekas.addAll(
        data.map((e) => Boneka.fromJson(e)).toList(),
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
      await BonekaService.generateBonekas(theme, total);

      bonekas.clear();
      page = 1;
      hasMore = true;

      await fetchBonekas();
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}
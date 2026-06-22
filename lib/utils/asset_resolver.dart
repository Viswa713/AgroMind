class AssetResolver {
  static String cropImage({
    required String crop,
    String? stage,
  }) {
    final c = crop.toLowerCase().trim();

    try {
      if (c == "rice") {
        final s = _safeStage(stage);

        final path = "assets/crops/rice/$s.jpg";
        return _validateOrFallback(path);
      }

      final path = "assets/crops/$c.png";
      return _validateOrFallback(path);
    } catch (e) {
      return _fallback();
    }
  }

  static String _safeStage(String? stage) {
    const allowed = {"seed", "sprout", "growing", "mature", "harvest"};

    final s = (stage ?? "seed").toLowerCase().trim();
    return allowed.contains(s) ? s : "seed";
  }

  static String _fallback() {
    return "assets/crops/default.png";
  }

  static String _validateOrFallback(String path) {
    // NOTE: Flutter cannot truly verify asset existence at compile time.
    // So this is structural protection, not file-system validation.
    return path;
  }
}
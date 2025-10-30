class LocalizedText {
  const LocalizedText._();

  static Map<String, String> normalize(Map<String, String> source) {
    if (source.isEmpty) {
      return const <String, String>{};
    }

    final normalized = <String, String>{};
    source.forEach((key, value) {
      final trimmedKey = key.trim();
      if (trimmedKey.isEmpty) {
        return;
      }

      normalized[trimmedKey.toLowerCase()] = value;
    });

    return Map.unmodifiable(normalized);
  }

  static Map<String, String> parse(dynamic raw) {
    if (raw is Map) {
      final result = <String, String>{};
      raw.forEach((key, value) {
        if (key == null) {
          return;
        }

        final keyString = key.toString();
        if (keyString.trim().isEmpty || value == null) {
          return;
        }

        result[keyString] = value.toString();
      });

      return normalize(result);
    }

    return const <String, String>{};
  }

  static Map<String, String>? parseOptional(dynamic raw) {
    if (raw == null) {
      return null;
    }

    final parsed = parse(raw);
    return parsed.isEmpty ? null : parsed;
  }

  static String resolve(
    Map<String, String> translations,
    String locale, {
    String fallbackLocale = 'en',
  }) {
    if (translations.isEmpty) {
      return '';
    }

    final normalizedLocale = locale.toLowerCase();
    final direct = translations[normalizedLocale];
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final baseLocale = _baseLocale(normalizedLocale);
    if (baseLocale != normalizedLocale) {
      final baseMatch = translations[baseLocale];
      if (baseMatch != null && baseMatch.isNotEmpty) {
        return baseMatch;
      }
    }

    final fallback = translations[fallbackLocale];
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    return '';
  }

  static String _baseLocale(String locale) {
    final match = RegExp('[-_]').firstMatch(locale);
    if (match == null) {
      return locale;
    }

    return locale.substring(0, match.start);
  }
}

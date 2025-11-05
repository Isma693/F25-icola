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

  /// Resolve the best available translation for [locale].
  ///
  /// Resolution order:
  /// 1. exact locale (lowercased)
  /// 2. base locale (e.g. 'en-US' -> 'en')
  /// 3. [fallbackLocale]
  /// 4. first non-empty translation available
  /// 5. empty string if nothing found
  static String resolveBest(
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

    // Return first available non-empty translation (useful when data exists
    // only in languages other than requested/fallback).
    for (final value in translations.values) {
      if (value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  /// Same as [resolveBest] but also returns the locale key that was used.
  /// Returns a Map with keys 'text' and 'locale' (locale may be empty if none found).
  static Map<String, String> resolveWithLocale(
    Map<String, String> translations,
    String locale, {
    String fallbackLocale = 'en',
  }) {
    if (translations.isEmpty) {
      return const <String, String>{'text': '', 'locale': ''};
    }

    final normalizedLocale = locale.toLowerCase();
    final direct = translations[normalizedLocale];
    if (direct != null && direct.isNotEmpty) {
      return {'text': direct, 'locale': normalizedLocale};
    }

    final baseLocale = _baseLocale(normalizedLocale);
    if (baseLocale != normalizedLocale) {
      final baseMatch = translations[baseLocale];
      if (baseMatch != null && baseMatch.isNotEmpty) {
        return {'text': baseMatch, 'locale': baseLocale};
      }
    }

    final fallback = translations[fallbackLocale];
    if (fallback != null && fallback.isNotEmpty) {
      return {'text': fallback, 'locale': fallbackLocale};
    }

    // Return first available non-empty translation and its key.
    for (final entry in translations.entries) {
      if (entry.value.isNotEmpty) {
        return {'text': entry.value, 'locale': entry.key};
      }
    }

    return const <String, String>{'text': '', 'locale': ''};
  }
}

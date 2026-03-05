import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Simple file-based cache for inbox emails.
/// Stores emails as JSON and considers them valid for up to 10 days.
class EmailCacheService {
  static final EmailCacheService _instance = EmailCacheService._internal();
  factory EmailCacheService() => _instance;
  EmailCacheService._internal();

  static const _fileName = 'inbox_email_cache.json';
  static const _maxAgeDays = 10;

  /// In-memory cache so we don't read from disk every tab switch.
  List<Map<String, String>>? _memoryCache;
  DateTime? _memoryCacheTime;

  Future<File> get _cacheFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Returns cached emails if the cache exists and is fresh (< 10 min old).
  /// Returns null if no cache or cache is stale.
  Future<List<Map<String, String>>?> getCachedEmails() async {
    // Return memory cache if available (instant, no disk I/O)
    if (_memoryCache != null && _memoryCacheTime != null) {
      final age = DateTime.now().difference(_memoryCacheTime!);
      if (age.inMinutes < 10) {
        return _memoryCache;
      }
    }

    try {
      final file = await _cacheFile;
      if (!await file.exists()) return null;

      final jsonStr = await file.readAsString();
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      final cachedAt = DateTime.parse(data['cachedAt'] as String);
      final age = DateTime.now().difference(cachedAt);

      // Cache is stale if older than 10 minutes (for freshness)
      if (age.inMinutes > 10) return null;

      final emails = (data['emails'] as List)
          .map((e) => Map<String, String>.from(e as Map))
          .toList();

      // Filter out emails older than 10 days
      final cutoff = DateTime.now().subtract(const Duration(days: _maxAgeDays));
      final filtered = emails.where((email) {
        final dateStr = email['rawDate'];
        if (dateStr == null) return true; // Keep if no date info
        try {
          final date = DateTime.parse(dateStr);
          return date.isAfter(cutoff);
        } catch (_) {
          return true;
        }
      }).toList();

      _memoryCache = filtered;
      _memoryCacheTime = cachedAt;

      return filtered;
    } catch (e) {
      print('Error reading email cache: $e');
      return null;
    }
  }

  /// Saves emails to disk and memory cache.
  Future<void> cacheEmails(List<Map<String, String>> emails) async {
    try {
      final now = DateTime.now();
      final data = {
        'cachedAt': now.toIso8601String(),
        'emails': emails,
      };

      final file = await _cacheFile;
      await file.writeAsString(json.encode(data));

      _memoryCache = emails;
      _memoryCacheTime = now;
    } catch (e) {
      print('Error writing email cache: $e');
    }
  }

  /// Clears the cache (e.g. on sign-out).
  Future<void> clearCache() async {
    _memoryCache = null;
    _memoryCacheTime = null;
    try {
      final file = await _cacheFile;
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}

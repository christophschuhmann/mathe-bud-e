import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends ChangeNotifier {
  Progress(this.storage);
  final SharedPreferencesAsync storage;
  int answered = 0, correct = 0, xp = 0, highestLevel = 1;
  int upAfter = 8, downAfter = 5;
  String name = 'Mathe-Fan';
  final Map<String, List<int>> topicStats = {};
  final Map<String, int> days = {};
  final List<Map<String, dynamic>> runs = [];
  bool saveFailed = false;
  Future<void> _pending = Future.value();

  static Future<Progress> load() async {
    final p = Progress(SharedPreferencesAsync());
    try {
      final raw = await p.storage.getString('progress_v1');
      if (raw == null) return p;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      p.answered = j['answered'] as int? ?? 0;
      p.correct = j['correct'] as int? ?? 0;
      p.xp = j['xp'] as int? ?? 0;
      p.highestLevel = j['highestLevel'] as int? ?? 1;
      p.upAfter = j['upAfter'] as int? ?? 8;
      p.downAfter = j['downAfter'] as int? ?? 5;
      p.name = j['name'] as String? ?? 'Mathe-Fan';
      for (final e in (j['topics'] as Map? ?? {}).entries) {
        p.topicStats[e.key as String] = (e.value as List).cast<int>();
      }
      for (final e in (j['days'] as Map? ?? {}).entries) {
        p.days[e.key as String] = e.value as int;
      }
      for (final run in j['runs'] as List? ?? []) {
        p.runs.add(Map<String, dynamic>.from(run as Map));
      }
      if (j['scoringVersion'] != 2) {
        p.xp = p.correct;
        for (final run in p.runs) {
          if (run['correct'] is int) run['score'] = run['correct'];
        }
        await p.save();
      }
    } catch (_) {
      p.saveFailed = true;
    }
    return p;
  }

  String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  int get todayCount => days[dayKey(DateTime.now())] ?? 0;
  int get dayStreak {
    var date = DateTime.now();
    if (!days.containsKey(dayKey(date))) {
      date = date.subtract(const Duration(days: 1));
    }
    var result = 0;
    while (days.containsKey(dayKey(date))) {
      result++;
      date = date.subtract(const Duration(days: 1));
    }
    return result;
  }

  void recordAnswer({
    required bool isCorrect,
    required int level,
    required String topic,
  }) {
    answered++;
    if (isCorrect) correct++;
    if (isCorrect) xp++;
    if (level > highestLevel) highestLevel = level;
    final t = topicStats.putIfAbsent(topic, () => [0, 0]);
    t[0]++;
    if (isCorrect) t[1]++;
    final key = dayKey(DateTime.now());
    days[key] = (days[key] ?? 0) + 1;
    notifyListeners();
    save();
  }

  void addRun(Map<String, dynamic> run) {
    runs.insert(0, run);
    if (runs.length > 100) runs.removeLast();
    notifyListeners();
    save();
  }

  Future<void> save() {
    final raw = jsonEncode({
      'scoringVersion': 2,
      'answered': answered,
      'correct': correct,
      'xp': xp,
      'highestLevel': highestLevel,
      'upAfter': upAfter,
      'downAfter': downAfter,
      'name': name,
      'topics': topicStats,
      'days': days,
      'runs': runs,
    });
    _pending = _pending.then((_) async {
      try {
        await storage.setString('progress_v1', raw);
        saveFailed = false;
      } catch (_) {
        saveFailed = true;
      }
      notifyListeners();
    });
    return _pending;
  }
}

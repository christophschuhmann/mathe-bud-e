import 'package:flutter_test/flutter_test.dart';
import 'package:mathe_bud_e/domain/progress.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(
    () => SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty(),
  );
  test('Answers, preferences and run history survive reloading', () async {
    final p = await Progress.load();
    p.name = 'Alex';
    p.upAfter = 10;
    p.downAfter = 5;
    for (var i = 0; i < 20; i++) {
      p.recordAnswer(
        isCorrect: i < 15,
        points: i < 15 ? 30 : 0,
        level: 3,
        topic: 'addition',
      );
    }
    p.addRun({'mode': 'test', 'grade': '1+', 'correct': 15, 'answered': 20});
    await p.save();
    final reloaded = await Progress.load();
    expect(reloaded.answered, 20);
    expect(reloaded.correct, 15);
    expect(reloaded.xp, 450);
    expect(reloaded.highestLevel, 3);
    expect(reloaded.name, 'Alex');
    expect(reloaded.upAfter, 10);
    expect(reloaded.topicStats['addition'], [20, 15]);
    expect(reloaded.todayCount, 20);
    expect(reloaded.dayStreak, 1);
    expect(reloaded.runs.single['grade'], '1+');
    expect(reloaded.saveFailed, isFalse);
  });
  test('Local run history retains the latest 100 entries', () async {
    final p = await Progress.load();
    for (var i = 0; i < 130; i++) {
      p.addRun({'id': i});
    }
    await p.save();
    final r = await Progress.load();
    expect(r.runs.length, 100);
    expect(r.runs.first['id'], 129);
    expect(r.runs.last['id'], 30);
  });
}

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:mathe_bud_e/main.dart';
import 'package:mathe_bud_e/main.dart' as entry show main;
import 'package:mathe_bud_e/domain/progress.dart';
import 'package:mathe_bud_e/domain/reference_test.dart';

class MemoryProgress extends Progress {
  MemoryProgress() : super(SharedPreferencesAsync());
  @override
  Future<void> save() async {}
}

const captureKey = ValueKey('capture');
Future<void> startApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final font = FontLoader('DMSans')
    ..addFont(rootBundle.load('assets/fonts/DMSans.ttf'));
  await font.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
  await tester.pumpWidget(
    RepaintBoundary(
      key: captureKey,
      child: BudApp(progress: MemoryProgress()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> screenshot(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(captureKey),
    );
    final image = await boundary.toImage(pixelRatio: 1.5);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('artifacts/screenshots/$name.png');
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}

Future<MemoryProgress> openRun(WidgetTester tester, RunConfig config) async {
  final progress = MemoryProgress();
  final context = tester.element(find.byType(HomeScreen));
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => RunScreen(config: config, progress: progress),
    ),
  );
  await tester.pumpAndSettle();
  return progress;
}

// Solve the visible arithmetic independently of the app's answer checker.
String visibleAnswer(WidgetTester tester) {
  final pattern = RegExp(r'^(\d+) ([+−×÷]) (\d+)$');
  final equation = tester
      .widgetList<Text>(
        find.descendant(
          of: find.byType(RunScreen),
          matching: find.byType(Text),
        ),
      )
      .map((t) => t.data ?? '')
      .firstWhere(pattern.hasMatch);
  final match = pattern.firstMatch(equation)!;
  final a = int.parse(match[1]!), b = int.parse(match[3]!);
  return switch (match[2]) {
    '+' => '${a + b}',
    '−' => '${a - b}',
    '×' => '${a * b}',
    '÷' => '${a ~/ b}',
    _ => throw StateError('Unexpected arithmetic'),
  };
}

Future<void> enterAnswer(WidgetTester tester, String answer) async {
  for (final ch in answer.split('')) {
    await tester.sendKeyEvent(LogicalKeyboardKey.digit0, character: ch);
  }
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Windows entry point starts when phone orientation API is unavailable',
    (tester) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemChrome.setPreferredOrientations') {
              throw MissingPluginException('Phone API unavailable on Windows');
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      await entry.main();
      await tester.pumpAndSettle();
      debugDefaultTargetPlatformOverride = null;
      expect(find.text('Mathe Bud-E'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  testWidgets('Home, levels and progress fit phone and narrow windows', (
    tester,
  ) async {
    await startApp(tester);
    expect(find.text('Mathe Bud-E'), findsOneWidget);
    expect(find.text('Training'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await screenshot(tester, '01-start');
    await tester.tap(find.text('Fortschritt'));
    await tester.pumpAndSettle();
    await screenshot(tester, '05-fortschritt');
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Entdecken'));
    await tester.pumpAndSettle();
    await screenshot(tester, '06-levels');
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Original test accepts touchscreen, advances and applies original grade',
    (tester) async {
      await startApp(tester);
      await openRun(
        tester,
        const RunConfig(
          mode: RunMode.test,
          level: 3,
          original: true,
          count: 120,
        ),
      );
      await screenshot(tester, '02-test');
      await tester.tap(find.widgetWithText(OutlinedButton, '9'));
      await tester.pump();
      await tester.tap(find.widgetWithText(OutlinedButton, '9'));
      await tester.pump();
      await tester.tap(find.text('Antwort abgeben'));
      await tester.pumpAndSettle();
      expect(find.text('Antwort gespeichert.'), findsOneWidget);
      expect(find.textContaining('Die Lösung:'), findsNothing);
      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();
      expect(find.text('27 + 260'), findsOneWidget);
      await tester.tap(find.byTooltip('Run beenden'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beenden'));
      await tester.pumpAndSettle();
      expect(find.text('1 von 120 Aufgaben richtig'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(
        find.text('119 unbeantwortete Aufgaben zählen als falsch.'),
        findsOneWidget,
      );
      await screenshot(tester, '04-ergebnis');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Training shows optional explanation after wrong answer', (
    tester,
  ) async {
    await startApp(tester, size: const Size(360, 740));
    await openRun(tester, const RunConfig(mode: RunMode.training));
    await enterAnswer(tester, '999999');
    await tester.pumpAndSettle();
    expect(find.text('Noch nicht ganz. Wir üben das!'), findsOneWidget);
    await tester.tap(find.text('Zeig mir, wie das geht'));
    await tester.pumpAndSettle();
    expect(find.text('Bud-E erklärt’s'), findsOneWidget);
    await screenshot(tester, '03-rechentipp');
    expect(tester.takeException(), isNull);
  });

  testWidgets('All 120 answers can be entered and completed with full score', (
    tester,
  ) async {
    await startApp(tester, size: const Size(520, 860));
    await openRun(
      tester,
      const RunConfig(mode: RunMode.test, level: 3, original: true, count: 120),
    );
    for (final p in referenceTest()) {
      for (final ch in p.solution.split('')) {
        await tester.sendKeyEvent(LogicalKeyboardKey.digit0, character: ch);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
    }
    expect(find.text('120 von 120 Aufgaben richtig'), findsOneWidget);
    expect(find.text('1+'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timed run expires even while a hint sheet is open', (
    tester,
  ) async {
    await startApp(tester);
    var time = DateTime(2026, 10, 5, 12);
    final context = tester.element(find.byType(HomeScreen));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RunScreen(
          config: const RunConfig(mode: RunMode.speed, minutes: 5),
          progress: MemoryProgress(),
          now: () => time,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipp holen'));
    await tester.pumpAndSettle();
    expect(find.text('Bud-E erklärt’s'), findsOneWidget);
    time = time.add(const Duration(minutes: 5));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Run geschafft!'), findsOneWidget);
    expect(find.text('5-Minuten-Speedrun · vollständig'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final mode in RunMode.values) {
    testWidgets(
      '${mode.name}: correct answers give one point; skip advances without points',
      (tester) async {
        await startApp(tester, size: const Size(320, 640));
        final progress = await openRun(
          tester,
          RunConfig(
            mode: mode,
            level: 3,
            original: mode == RunMode.test,
            count: 120,
            minutes: mode == RunMode.speed ? 5 : 0,
          ),
        );
        for (var i = 0; i < 2; i++) {
          await enterAnswer(tester, visibleAnswer(tester));
          expect(progress.xp, i + 1);
          await tester.tap(find.text('Weiter'));
          await tester.pumpAndSettle();
        }
        if (mode != RunMode.test) {
          final answer = visibleAnswer(tester);
          // Both actions are reachable on a small phone without scrolling.
          await tester.tap(find.text('Tipp holen'));
          await tester.pumpAndSettle();
          expect(find.text('Bud-E erklärt’s'), findsOneWidget);
          await tester.ensureVisible(find.text('Alles klar, weiter!'));
          await tester.tap(find.text('Alles klar, weiter!'));
          await tester.pumpAndSettle();
          await enterAnswer(tester, answer);
          expect(progress.xp, 3);
          expect(find.text('Richtig mit Hilfe. Gut geübt!'), findsOneWidget);
          await tester.tap(find.text('Weiter'));
          await tester.pumpAndSettle();
        } else {
          expect(find.text('Tipp holen'), findsNothing);
        }
        final correct = mode == RunMode.test ? 2 : 3;
        await tester.tap(find.text('Überspringen'));
        await tester.pumpAndSettle();
        expect(progress.answered, correct + 1);
        expect(progress.correct, correct);
        expect(progress.xp, correct);
        expect(find.text('Antwort gespeichert.'), findsNothing);
        expect(
          find.text(
            mode == RunMode.test ? 'Antwort abgeben' : 'Antwort prüfen',
          ),
          findsOneWidget,
        );
        await enterAnswer(tester, '999999');
        expect(progress.xp, correct);
        expect(progress.answered, correct + 2);
        await tester.ensureVisible(find.byTooltip('Run beenden'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Run beenden'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Beenden'));
        await tester.pumpAndSettle();
        expect(progress.runs.single['score'], correct);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Skipping the last test task finishes with zero points', (
    tester,
  ) async {
    await startApp(tester);
    final progress = await openRun(
      tester,
      const RunConfig(mode: RunMode.test, count: 1),
    );
    await tester.tap(find.text('Überspringen'));
    await tester.pumpAndSettle();
    expect(find.text('0 von 1 Aufgaben richtig'), findsOneWidget);
    expect(progress.xp, 0);
    expect(progress.runs.single['score'], 0);
    expect(progress.runs.single['completed'], true);
    expect(find.textContaining('übersprungen'), findsOneWidget);
  });

  testWidgets('An unfinished speedrun does not count as a record', (
    tester,
  ) async {
    await startApp(tester);
    await openRun(tester, const RunConfig(mode: RunMode.speed, minutes: 5));
    await tester.tap(find.byTooltip('Run beenden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beenden'));
    await tester.pumpAndSettle();
    expect(find.textContaining('kein Rekord'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

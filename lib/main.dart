import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'domain/math_engine.dart';
import 'domain/progress.dart';
import 'domain/reference_test.dart';

const ink = Color(0xFF192D34);
const muted = Color(0xFF687773);
const cream = Color(0xFFF7F7F0);
const lime = Color(0xFFD4F77D);
const teal = Color(0xFF166556);
const line = Color(0xFFE2E7DC);
const coral = Color(0xFFFFD4BC);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  runApp(BudApp(progress: await Progress.load()));
}

class BudApp extends StatelessWidget {
  const BudApp({super.key, required this.progress});
  final Progress progress;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mathe Bud-E',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'DMSans',
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: teal,
        primary: teal,
        surface: cream,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'DMSans',
        bodyColor: ink,
        displayColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      dividerColor: line,
    ),
    home: HomeScreen(progress: progress),
  );
}

class PortraitFrame extends StatelessWidget {
  const PortraitFrame({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFE7ECE5),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: child,
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 20,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: color == Colors.white ? line : Colors.transparent,
      ),
    ),
    child: child,
  );
}

class Label extends StatelessWidget {
  const Label(this.text, {super.key, this.color = muted});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      letterSpacing: 1.7,
      color: color,
      fontWeight: FontWeight.w800,
    ),
  );
}

class Bud extends StatelessWidget {
  const Bud({super.key, this.size = 100});
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Bud-E, dein freundlicher Mathe-Roboter',
    child: SizedBox(
      width: size,
      height: size * 1.12,
      child: CustomPaint(painter: _BudPainter()),
    ),
  );
}

class _BudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 112);
    final p = Paint()..color = teal;
    canvas.drawOval(
      const Rect.fromLTWH(16, 97, 71, 9),
      Paint()..color = ink.withValues(alpha: .10),
    );
    canvas.drawLine(
      const Offset(51, 15),
      const Offset(51, 26),
      Paint()
        ..color = ink
        ..strokeWidth = 4,
    );
    canvas.drawCircle(const Offset(51, 12), 6, Paint()..color = coral);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6, 39, 9, 25),
        const Radius.circular(5),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(86, 39, 9, 25),
        const Radius.circular(5),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 25, 72, 56),
        const Radius.circular(20),
      ),
      Paint()..color = lime,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 35, 56, 34),
        const Radius.circular(13),
      ),
      p,
    );
    canvas.drawCircle(const Offset(37, 47), 4, Paint()..color = lime);
    canvas.drawCircle(const Offset(63, 47), 4, Paint()..color = lime);
    canvas.drawArc(
      const Rect.fromLTWH(39, 48, 22, 14),
      0,
      pi,
      false,
      Paint()
        ..color = lime
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(29, 78, 42, 18),
        const Radius.circular(8),
      ),
      p,
    );
    canvas.drawCircle(const Offset(50, 86), 3, Paint()..color = lime);
    canvas.drawLine(
      const Offset(34, 95),
      const Offset(29, 101),
      Paint()
        ..color = ink
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      const Offset(66, 95),
      const Offset(71, 101),
      Paint()
        ..color = ink
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BudPainter oldDelegate) => false;
}

enum RunMode {
  training('Training', Icons.spa_outlined),
  test('Probe-Test', Icons.assignment_outlined),
  speed('Speedrun', Icons.bolt_rounded);

  const RunMode(this.label, this.icon);
  final String label;
  final IconData icon;
}

class RunConfig {
  const RunConfig({
    required this.mode,
    this.level = 1,
    this.topic = Topic.mixed,
    this.count = 20,
    this.minutes = 0,
    this.original = false,
  });
  final RunMode mode;
  final int level, count, minutes;
  final Topic topic;
  final bool original;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.progress});
  final Progress progress;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  Progress get p => widget.progress;
  Future<void> setup(RunMode mode, {int? level}) async {
    final config = await showModalBottomSheet<RunConfig>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: cream,
      constraints: const BoxConstraints(maxWidth: 520),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => SetupSheet(
        mode: mode,
        initialLevel: level ?? (mode == RunMode.test ? 3 : 1),
      ),
    );
    if (config != null && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RunScreen(config: config, progress: p),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => PortraitFrame(
    child: AnimatedBuilder(
      animation: p,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calculate_outlined,
                      color: lime,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Mathe Bud-E',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.7,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: settings,
                    tooltip: 'Einstellungen',
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (p.saveFailed)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Fortschritt konnte nicht gespeichert oder geladen werden. Bitte prüfe den freien Speicher.',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ...switch (tab) {
                0 => home(),
                1 => progressView(),
                _ => learning(),
              },
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 74,
          backgroundColor: cream,
          indicatorColor: lime,
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Start',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_rounded),
              label: 'Fortschritt',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              label: 'Entdecken',
            ),
          ],
        ),
      ),
    ),
  );

  List<Widget> home() => [
    Label('Hey, ${p.name}'),
    const SizedBox(height: 9),
    const Text(
      'Kleiner Run.\nGroßer Fortschritt.',
      style: TextStyle(
        fontSize: 30,
        height: 1.12,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.4,
      ),
    ),
    const SizedBox(height: 22),
    Panel(
      color: teal,
      padding: 16,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label('Dein Kopf kann mehr.', color: lime),
                const SizedBox(height: 10),
                const Text(
                  'Eine Aufgabe.\nEin Schritt weiter.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${p.todayCount}/20 Aufgaben heute',
                  style: const TextStyle(
                    color: Color(0xFFDDEEE3),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: min(1, p.todayCount / 20),
                    color: lime,
                    backgroundColor: Colors.white24,
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Bud(size: 85),
        ],
      ),
    ),
    const SizedBox(height: 16),
    Row(
      children: [
        Expanded(
          child: miniStat(
            Icons.local_fire_department_outlined,
            '${p.dayStreak}',
            'Tage in Folge',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: miniStat(Icons.star_border_rounded, '${p.xp}', 'Gesamtpunkte'),
        ),
      ],
    ),
    const SizedBox(height: 18),
    const Row(
      children: [
        Expanded(
          child: Text(
            'Wie willst du rechnen?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        Label('Let’s go'),
      ],
    ),
    const SizedBox(height: 14),
    modeCard(
      RunMode.training,
      lime,
      'Dein Tempo. Dein Level.',
      'Ohne Uhr • mit Tipps • wächst mit dir',
      ink,
    ),
    const SizedBox(height: 12),
    modeCard(
      RunMode.test,
      Colors.white,
      'Bereit für den Probe-Test?',
      'Feste Aufgaben • deine Note am Ende',
      ink,
    ),
    const SizedBox(height: 12),
    modeCard(
      RunMode.speed,
      ink,
      'Du gegen die Uhr.',
      '5 oder 10 Minuten • knack deinen Rekord',
      Colors.white,
    ),
    const SizedBox(height: 21),
    const Row(
      children: [
        Icon(Icons.offline_bolt_outlined, size: 16, color: muted),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            '10 Levels. Offline. Ohne Anmeldung.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    ),
  ];

  Widget miniStat(IconData icon, String value, String label) => Panel(
    padding: 14,
    child: Row(
      children: [
        Icon(icon, color: teal, size: 23),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(label, style: const TextStyle(color: muted, fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget modeCard(
    RunMode mode,
    Color color,
    String title,
    String subtitle,
    Color foreground,
  ) => Semantics(
    button: true,
    label: mode.label,
    child: Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: color == Colors.white ? line : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => setup(mode),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(mode.icon, color: foreground, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.label,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: foreground.withValues(alpha: .65),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, color: foreground, size: 20),
            ],
          ),
        ),
      ),
    ),
  );

  List<Widget> progressView() {
    final speedRuns = p.runs
        .where((r) => r['mode'] == RunMode.speed.name && r['completed'] == true)
        .toList();
    final week = List.generate(
      7,
      (i) => DateTime.now().subtract(Duration(days: 6 - i)),
    );
    final maxDay = max(
      1,
      week.map((d) => p.days[p.dayKey(d)] ?? 0).fold<int>(0, max),
    );
    return [
      const Label('Schritt für Schritt'),
      const SizedBox(height: 9),
      const Text(
        'Das ist dein Fortschritt.',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.1,
        ),
      ),
      const SizedBox(height: 20),
      Panel(
        color: lime,
        child: Row(
          children: [
            const Icon(Icons.emoji_events_outlined, size: 44),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${p.xp} Punkte gesammelt',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Höchstes erreichtes Level: ${p.highestLevel}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: miniStat(
              Icons.check_circle_outline,
              '${p.correct}/${p.answered}',
              'richtig beantwortet',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: miniStat(
              Icons.percent_rounded,
              p.answered == 0
                  ? '–'
                  : '${(p.correct * 100 / p.answered).round()} %',
              'Trefferquote',
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deine letzten 7 Tage',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 118,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final d in week)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${p.days[p.dayKey(d)] ?? 0}',
                            style: const TextStyle(fontSize: 11, color: muted),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 24,
                            height: max(
                              5,
                              (p.days[p.dayKey(d)] ?? 0) / maxDay * 74,
                            ),
                            decoration: BoxDecoration(
                              color: d.day == DateTime.now().day ? teal : lime,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            [
                              'Mo',
                              'Di',
                              'Mi',
                              'Do',
                              'Fr',
                              'Sa',
                              'So',
                            ][d.weekday - 1],
                            style: const TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      const Text(
        'Speedrun-Rekorde',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 12),
      for (final minutes in [5, 10])
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            padding: 16,
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$minutes Minuten',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  speedRuns.where((r) => r['minutes'] == minutes).isEmpty
                      ? 'Noch kein Run'
                      : '${speedRuns.where((r) => r['minutes'] == minutes).map((r) => r['score'] as int).reduce(max)} Punkte',
                  style: const TextStyle(
                    color: teal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 12),
      const Text(
        'Deine Themen',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 12),
      if (p.topicStats.isEmpty)
        const Text(
          'Deine ersten Antworten machen den Anfang.',
          style: TextStyle(color: muted),
        ),
      for (final t in Topic.values.where(
        (t) => p.topicStats.containsKey(t.name),
      ))
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            padding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t.label,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      '${p.topicStats[t.name]![1]}/${p.topicStats[t.name]![0]}',
                      style: const TextStyle(color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: p.topicStats[t.name]![1] / p.topicStats[t.name]![0],
                    minHeight: 6,
                    color: teal,
                    backgroundColor: line,
                  ),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 12),
      const Text(
        'Letzte Runs',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 12),
      if (p.runs.isEmpty)
        const Text(
          'Hier findest du später deine Trainings und Tests.',
          style: TextStyle(color: muted),
        ),
      for (final r in p.runs.take(12))
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            padding: 16,
            child: Row(
              children: [
                Icon(
                  RunMode.values.firstWhere((m) => m.name == r['mode']).icon,
                  color: teal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${RunMode.values.firstWhere((m) => m.name == r['mode']).label}${r['completed'] == false ? ' · beendet' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${formatDate(r['date'] as String)} · Level ${r['highest']} · ${r['correct']}/${r['answered']} richtig',
                        style: const TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Text(
                  r['grade'] != null
                      ? 'Note ${r['grade']}'
                      : '${r['score']} P.',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
    ];
  }

  List<Widget> learning() => [
    const Label('Deine Mathe-Welt'),
    const SizedBox(height: 9),
    const Text(
      'Von „kann ich“\nzu „kann ich auch“.',
      style: TextStyle(
        fontSize: 31,
        fontWeight: FontWeight.w900,
        height: 1.15,
        letterSpacing: -1,
      ),
    ),
    const SizedBox(height: 12),
    const Text(
      'Alle Levels sind offen. Tippe auf ein Level, entdecke ein Beispiel und leg los.',
      style: TextStyle(color: muted),
    ),
    const SizedBox(height: 20),
    for (var i = 1; i <= 10; i++)
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: i == 3 ? lime : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: line),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => levelInfo(i),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i <= p.highestLevel ? teal : cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: i <= p.highestLevel ? Colors.white : ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          levelNames[i - 1],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          levelDescriptions[i - 1],
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    const SizedBox(height: 8),
    TextButton.icon(
      onPressed: () => showGradeScheme(context),
      icon: const Icon(Icons.grading_rounded),
      label: const Text('Notenschema vom Übungsblatt'),
    ),
  ];

  void levelInfo(int level) {
    final topic = switch (level) {
      5 => Topic.decimals,
      6 || 7 => Topic.fractions,
      8 => Topic.fractionProduct,
      9 || 10 => Topic.percent,
      _ => Topic.mixed,
    };
    final problem = ProblemGenerator().next(level, topic);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 520),
      backgroundColor: cream,
      builder: (sheetContext) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label('Level $level'),
            const SizedBox(height: 8),
            Text(
              levelNames[level - 1],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              levelDescriptions[level - 1],
              style: const TextStyle(color: muted),
            ),
            const SizedBox(height: 20),
            HintContent(problem: problem),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                setup(RunMode.training, level: level);
              },
              child: const Text('Dieses Level trainieren'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                setup(RunMode.test, level: level);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Probe-Test auf diesem Level'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> settings() async {
    final controller = TextEditingController(text: p.name);
    var up = p.upAfter, down = p.downAfter;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 520),
      backgroundColor: cream,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, update) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dein Bud-E',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                maxLength: 24,
                decoration: const InputDecoration(
                  labelText: 'Dein Spitzname',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Training passt sich dir an',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text('Level hoch nach … richtigen Antworten in Folge'),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: [
                  for (final v in [5, 8, 10])
                    ButtonSegment(value: v, label: Text('$v')),
                ],
                selected: {up},
                onSelectionChanged: (v) => update(() => up = v.first),
              ),
              const SizedBox(height: 16),
              const Text('Level runter nach … Fehlern seit dem Levelwechsel'),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: [
                  for (final v in [5, 10])
                    ButtonSegment(value: v, label: Text('$v')),
                ],
                selected: {down},
                onSelectionChanged: (v) => update(() => down = v.first),
              ),
              const SizedBox(height: 18),
              const Text(
                'Speedruns bleiben vergleichbar: Start auf Level 1, 8 richtige in Folge für den Aufstieg, 5 Fehler für den Abstieg. Antworten mit Tipp geben keine Punkte.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  p.name = controller.text.trim().isEmpty
                      ? 'Mathe-Fan'
                      : controller.text.trim();
                  p.upAfter = up;
                  p.downAfter = down;
                  p.save();
                  Navigator.pop(ctx);
                },
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
    // The bottom-sheet exit animation may still use its text controller.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    controller.dispose();
  }
}

String formatDate(String raw) {
  final d = DateTime.parse(raw).toLocal();
  return '${d.day}.${d.month}.${d.year}';
}

class SetupSheet extends StatefulWidget {
  const SetupSheet({super.key, required this.mode, required this.initialLevel});
  final RunMode mode;
  final int initialLevel;
  @override
  State<SetupSheet> createState() => _SetupSheetState();
}

class _SetupSheetState extends State<SetupSheet> {
  late int level;
  Topic topic = Topic.mixed;
  int count = 20, minutes = 5;
  bool original = false;
  @override
  void initState() {
    super.initState();
    level = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: line,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Label('Mach’s zu deinem Run'),
        const SizedBox(height: 8),
        Text(
          widget.mode.label,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(switch (widget.mode) {
          RunMode.training =>
            'Ohne Zeitdruck. Bud-E passt das Level an dich an und erklärt dir jeden Rechenschritt.',
          RunMode.test =>
            'Eine Aufgabe nach der anderen. Die Lösungen und deine Note siehst du am Ende.',
          RunMode.speed =>
            'Wie weit kommst du? Start auf Level 1, alle Themen. Die Uhr läuft auch bei Rechenhilfen weiter.',
        }, style: const TextStyle(color: muted, height: 1.5)),
        const SizedBox(height: 22),
        if (widget.mode == RunMode.test) ...[
          Panel(
            padding: 12,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Originaltest vom Foto',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                '120 Aufgaben · Level 3 · originale Reihenfolge',
                style: TextStyle(fontSize: 12),
              ),
              value: original,
              onChanged: (v) => setState(() {
                original = v;
                if (v) {
                  level = 3;
                  topic = Topic.mixed;
                  count = 120;
                }
              }),
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (widget.mode != RunMode.speed && !original) ...[
          const Label('Startlevel'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (var i = 1; i <= 10; i++)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: i == level ? teal : Colors.white,
                      foregroundColor: i == level ? Colors.white : ink,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: line),
                      ),
                    ),
                    onPressed: () => setState(() {
                      level = i;
                      if (topic.minimumLevel > level) topic = Topic.mixed;
                    }),
                    child: Text('$i'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            levelNames[level - 1],
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            levelDescriptions[level - 1],
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<Topic>(
            value: topic,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Thema',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final t in ProblemGenerator().topicsFor(level))
                DropdownMenuItem(value: t, child: Text(t.label)),
            ],
            onChanged: (v) => setState(() => topic = v!),
          ),
          const SizedBox(height: 20),
        ],
        if (widget.mode == RunMode.test && !original) ...[
          const Label('Aufgaben'),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: [
              for (final v in [20, 40, 120])
                ButtonSegment(value: v, label: Text('$v')),
            ],
            selected: {count},
            onSelectionChanged: (v) => setState(() => count = v.first),
          ),
          const SizedBox(height: 20),
        ],
        if (widget.mode == RunMode.speed) ...[
          const Label('Deine Zeit'),
          const SizedBox(height: 10),
          SegmentedButton<int>(
            segments: [
              for (final v in [5, 10])
                ButtonSegment(value: v, label: Text('$v Minuten')),
            ],
            selected: {minutes},
            onSelectionChanged: (v) => setState(() => minutes = v.first),
          ),
          const SizedBox(height: 18),
          const Panel(
            color: lime,
            child: Text(
              'Jede richtige Antwort ohne Tipp bringt Level × 10 Punkte. Ab der zweiten richtigen Antwort in Folge gibt’s einen Serienbonus (maximal 20).',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
        if (widget.mode == RunMode.test) ...[
          const Text(
            'Ein Punkt pro richtiger Antwort. Note nach dem Schema vom Foto; kurze Tests werden auf 120 Punkte umgerechnet.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          TextButton(
            onPressed: () => showGradeScheme(context),
            child: const Text('Notengrenzen ansehen'),
          ),
        ],
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: () => Navigator.pop(
            context,
            RunConfig(
              mode: widget.mode,
              level: widget.mode == RunMode.speed ? 1 : level,
              topic: topic,
              count: count,
              minutes: widget.mode == RunMode.speed ? minutes : 0,
              original: original,
            ),
          ),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text('${widget.mode.label} starten'),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

void showGradeScheme(BuildContext context) => showDialog<void>(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Notenschema vom Foto'),
    content: SizedBox(
      width: 320,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mindestpunkte von 120. Bei kürzeren Tests gilt: richtige Antworten ÷ Aufgaben × 120. Es wird vor der Bewertung nicht gerundet.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 16),
            for (final b in gradeBands)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Note ${b.$2}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text('ab ${b.$1} Punkten'),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Verstanden'),
      ),
    ],
  ),
);

class HintContent extends StatelessWidget {
  const HintContent({super.key, required this.problem});
  final Problem problem;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              problem.topic.label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Text(problem.tip, style: const TextStyle(fontSize: 16, height: 1.5)),
      const SizedBox(height: 20),
      Panel(
        color: lime,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Label('So geht diese Aufgabe', color: teal),
            const SizedBox(height: 12),
            Text(
              problem.text,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < problem.steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: teal,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        problem.steps[i],
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      if (problem.visualDenominator != null &&
          problem.visualDenominator! <= 48) ...[
        const SizedBox(height: 20),
        const Text(
          'So sieht der Anteil aus:',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (var i = 0; i < problem.visualDenominator!; i++)
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: i < problem.visualNumerator! ? teal : Colors.white,
                  border: Border.all(color: teal),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${problem.visualNumerator} von ${problem.visualDenominator} gleich großen Teilen sind gefärbt.',
          style: const TextStyle(color: muted, fontSize: 12),
        ),
      ],
      const SizedBox(height: 12),
      const Text(
        'Ein Tipp ist kein Rückschritt. Probier die nächste Aufgabe selbst!',
        style: TextStyle(color: muted, fontSize: 13),
      ),
    ],
  );
}

Future<void> showHint(BuildContext context, Problem p) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 520),
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Bud-E erklärt’s',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  tooltip: 'Schließen',
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HintContent(problem: p),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Alles klar, weiter!'),
            ),
          ],
        ),
      ),
    );

class Attempt {
  const Attempt(
    this.problem,
    this.input,
    this.correct,
    this.assisted,
    this.level,
  );
  final Problem problem;
  final String input;
  final bool correct, assisted;
  final int level;
}

class RunScreen extends StatefulWidget {
  const RunScreen({
    super.key,
    required this.config,
    required this.progress,
    this.now,
  });
  final RunConfig config;
  final Progress progress;
  final DateTime Function()? now;
  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  final generator = ProblemGenerator();
  final focus = FocusNode();
  final scroll = ScrollController();
  final List<Attempt> attempts = [];
  late final AdaptiveLevel adaptive;
  late final List<Problem> test;
  late Problem problem;
  late DateTime started;
  DateTime? deadline;
  Timer? timer;
  String input = '', validation = '', levelMessage = '';
  bool submitted = false, assisted = false, finished = false, hintOpen = false;
  int score = 0, highest = 1, remaining = 0;
  RunConfig get c => widget.config;
  DateTime get now => widget.now?.call() ?? DateTime.now();
  int get correctCount => attempts.where((a) => a.correct).length;
  int get level => adaptive.level;
  @override
  void initState() {
    super.initState();
    started = now;
    highest = c.level;
    adaptive = AdaptiveLevel(
      level: c.level,
      minimum: c.topic.minimumLevel,
      upAfter: c.mode == RunMode.speed ? 8 : widget.progress.upAfter,
      downAfter: c.mode == RunMode.speed ? 5 : widget.progress.downAfter,
    );
    test = c.mode == RunMode.test
        ? (c.original
              ? referenceTest()
              : List.generate(c.count, (_) => generator.next(c.level, c.topic)))
        : [];
    problem = c.mode == RunMode.test
        ? test.first
        : generator.next(level, c.topic);
    if (c.minutes > 0) {
      remaining = c.minutes * 60;
      deadline = started.add(Duration(minutes: c.minutes));
      timer = Timer.periodic(const Duration(milliseconds: 250), (_) => tick());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    focus.dispose();
    scroll.dispose();
    super.dispose();
  }

  void tick() {
    if (finished || !mounted) return;
    final seconds = max(
      0,
      (deadline!.difference(now).inMilliseconds / 1000).ceil(),
    );
    if (seconds != remaining) setState(() => remaining = seconds);
    if (seconds == 0) finish(true);
  }

  void key(String value) {
    if (finished) return;
    if (deadline != null && !now.isBefore(deadline!)) {
      finish(true);
      return;
    }
    if (value == 'enter') {
      submitted ? next() : submit();
      return;
    }
    if (submitted) return;
    setState(() {
      validation = '';
      if (value == 'back') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == 'clear') {
        input = '';
      } else if (input.length < 20) {
        if (value == ',' && !input.contains(',') && !input.contains('/')) {
          input += input.isEmpty || input == '-' ? '0,' : ',';
        } else if (value == '/' &&
            input.isNotEmpty &&
            !input.contains('/') &&
            !input.contains(',')) {
          input += '/';
        } else if (value == '-' && input.isEmpty) {
          input = '-';
        } else if (RegExp(r'^\d$').hasMatch(value)) {
          input += value;
        }
      }
    });
  }

  void submit({bool skip = false}) {
    if (submitted || finished) return;
    if (deadline != null && !now.isBefore(deadline!)) {
      finish(true);
      return;
    }
    final cleaned = input.replaceAll('%', '');
    if (!skip && Rational.parse(cleaned) == null) {
      setState(
        () => validation = 'Gib eine Zahl ein, zum Beispiel 12, 0,5 oder 1/2.',
      );
      return;
    }
    final oldLevel = level;
    final correct = !skip && problem.accepts(input);
    final points = correct && !assisted
        ? oldLevel * 10 + min(20, adaptive.streak * 2).toInt()
        : 0;
    var changed = 0;
    if (c.mode != RunMode.test) {
      if (!correct) {
        changed = adaptive.record(false);
      } else if (!assisted) {
        changed = adaptive.record(true);
      } else {
        adaptive.streak = 0;
      }
    }
    highest = max(highest, level);
    score += points;
    attempts.add(
      Attempt(
        problem,
        skip ? 'übersprungen' : input,
        correct,
        assisted,
        oldLevel,
      ),
    );
    widget.progress.recordAnswer(
      isCorrect: correct,
      points: c.mode == RunMode.test ? (correct ? 10 : 0) : points,
      level: highest,
      topic: problem.topic.name,
    );
    setState(() {
      submitted = true;
      validation = '';
      levelMessage = changed > 0
          ? 'Level $level erreicht! Weiter so.'
          : changed < 0
          ? 'Wir üben auf Level $level weiter. Du schaffst das.'
          : '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void next() {
    if (finished || !submitted) return;
    if (c.mode == RunMode.test && attempts.length >= test.length) {
      finish(true);
      return;
    }
    setState(() {
      problem = c.mode == RunMode.test
          ? test[attempts.length]
          : generator.next(level, c.topic);
      input = '';
      validation = '';
      submitted = false;
      assisted = false;
      levelMessage = '';
    });
    if (scroll.hasClients) scroll.jumpTo(0);
    focus.requestFocus();
  }

  Future<void> hint() async {
    if (hintOpen || finished) return;
    if (!submitted) setState(() => assisted = true);
    hintOpen = true;
    await showHint(context, problem);
    hintOpen = false;
    if (mounted && !finished) focus.requestFocus();
  }

  Future<void> leave() async {
    if (finished) return;
    final stop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          c.mode == RunMode.training
              ? 'Training abschließen?'
              : 'Run jetzt beenden?',
        ),
        content: Text(
          c.mode == RunMode.test
              ? 'Deine bisherigen Antworten werden ausgewertet. Nicht beantwortete Aufgaben zählen als falsch.'
              : 'Deine Punkte bleiben gespeichert.${c.mode == RunMode.speed ? ' Ein vorzeitig beendeter Speedrun zählt nicht als Rekord.' : ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Weiterrechnen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
    if (stop == true && mounted) finish(c.mode == RunMode.training);
  }

  void finish(bool completed) {
    if (finished || !mounted) return;
    finished = true;
    timer?.cancel();
    final total = c.mode == RunMode.test ? test.length : attempts.length;
    final grade = c.mode == RunMode.test ? gradeFor(correctCount, total) : null;
    widget.progress.addRun({
      'mode': c.mode.name,
      'date': now.toIso8601String(),
      'score': score,
      'highest': highest,
      'correct': correctCount,
      'answered': attempts.length,
      'total': total,
      'minutes': c.minutes,
      'completed': completed,
      'grade': grade,
      'level': c.level,
      'topic': c.topic.name,
      'original': c.original,
    });
    // A timer can expire while a help or confirmation sheet is open.
    Navigator.of(context).popUntil((route) => route is MaterialPageRoute);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          config: c,
          attempts: List.of(attempts),
          allProblems: test,
          score: score,
          highest: highest,
          completed: completed,
          elapsed: now.difference(started),
        ),
      ),
    );
  }

  KeyEventResult hardware(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (hintOpen) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      key('enter');
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      key('back');
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.delete) {
      key('clear');
      return KeyEventResult.handled;
    }
    final ch = event.character;
    if (ch != null && RegExp(r'^[0-9,./-]$').hasMatch(ch)) {
      key(ch == '.' ? ',' : ch);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => PortraitFrame(
    child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) leave();
      },
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: FilledButton.icon(
              onPressed: submitted
                  ? next
                  : input.isEmpty
                  ? null
                  : submit,
              icon: Icon(
                submitted ? Icons.arrow_forward_rounded : Icons.check_rounded,
              ),
              label: Text(
                submitted
                    ? c.mode == RunMode.test && attempts.length == test.length
                          ? 'Ergebnis ansehen'
                          : 'Weiter'
                    : c.mode == RunMode.test
                    ? 'Antwort abgeben'
                    : 'Antwort prüfen',
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Focus(
            focusNode: focus,
            autofocus: true,
            onKeyEvent: hardware,
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: leave,
                      tooltip: 'Run beenden',
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(c.mode.label),
                          Text(
                            c.mode == RunMode.test
                                ? 'Level ${c.level}'
                                : 'Level $level',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (c.mode == RunMode.speed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: remaining < 30 ? coral : lime,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    if (c.mode == RunMode.test)
                      Text(
                        '${min(attempts.length + (submitted ? 0 : 1), test.length)} / ${test.length}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    if (c.mode == RunMode.training) const Bud(size: 42),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: c.mode == RunMode.test
                        ? attempts.length / test.length
                        : c.mode == RunMode.speed
                        ? remaining / (c.minutes * 60)
                        : adaptive.streak / adaptive.upAfter,
                    minHeight: 6,
                    color: teal,
                    backgroundColor: line,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.mode == RunMode.test
                            ? 'Feste Schwierigkeit · Lösungen am Ende'
                            : '${adaptive.streak}/${adaptive.upAfter} richtig in Folge · ${adaptive.errors}/${adaptive.downAfter} Fehler',
                        style: const TextStyle(fontSize: 11, color: muted),
                      ),
                    ),
                    if (c.mode != RunMode.test)
                      Text(
                        '$score P.',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: teal,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Panel(
                  color: Colors.white,
                  padding: 18,
                  child: Column(
                    children: [
                      Label(problem.topic.label),
                      const SizedBox(height: 12),
                      Text(
                        problem.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: problem.text.length > 20 ? 25 : 37,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: input.isEmpty ? line : teal,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          input.isEmpty
                              ? 'Deine Antwort'
                              : '$input${problem.suffix}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: input.isEmpty ? 19 : 30,
                            fontWeight: FontWeight.w800,
                            color: input.isEmpty ? muted : ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        problem.requiredDenominator != null
                            ? 'Als Bruch mit Nenner ${problem.requiredDenominator} eingeben'
                            : problem.requireReduced
                            ? 'Als vollständig gekürzten Bruch eingeben'
                            : 'Komma: 0,5   ·   Bruch: 1/2',
                        style: const TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                if (validation.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      validation,
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!submitted) ...[
                  Row(
                    children: [
                      if (c.mode != RunMode.test)
                        Expanded(
                          child: TextButton.icon(
                            onPressed: hint,
                            icon: const Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 18,
                            ),
                            label: Text(
                              assisted
                                  ? 'Tipp geöffnet · 0 Punkte'
                                  : 'Rechentipp',
                            ),
                          ),
                        ),
                      if (c.mode == RunMode.test)
                        const Expanded(
                          child: Text(
                            'Enter = Antwort abgeben',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ),
                      TextButton(
                        onPressed: () => submit(skip: true),
                        child: const Text(
                          'Weiß ich noch nicht',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  keypad(),
                ] else ...[
                  Panel(
                    color: c.mode == RunMode.test || attempts.last.correct
                        ? lime
                        : coral,
                    padding: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              c.mode == RunMode.test
                                  ? Icons.done_rounded
                                  : attempts.last.correct
                                  ? Icons.check_circle_outline
                                  : Icons.favorite_border_rounded,
                              size: 24,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                c.mode == RunMode.test
                                    ? 'Antwort gespeichert.'
                                    : attempts.last.correct
                                    ? assisted
                                          ? 'Richtig mit Hilfe. Gut geübt!'
                                          : 'Richtig! Stark gerechnet.'
                                    : 'Noch nicht ganz. Wir üben das!',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (c.mode != RunMode.test &&
                            !attempts.last.correct) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Die Lösung: ${problem.solution}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: hint,
                            icon: const Icon(Icons.lightbulb_outline),
                            label: const Text('Zeig mir, wie das geht'),
                          ),
                        ],
                        if (levelMessage.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            levelMessage,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Am PC geht’s auch mit Enter.',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget keypad() => Column(
    children: [
      for (final row in [
        ['7', '8', '9'],
        ['4', '5', '6'],
        ['1', '2', '3'],
        [',', '0', 'back'],
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            children: [
              for (var i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: 9),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height < 740 ? 44 : 50,
                    child: OutlinedButton(
                      onPressed: () => key(row[i]),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ink,
                        side: const BorderSide(color: line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: row[i] == 'back'
                          ? const Icon(
                              Icons.backspace_outlined,
                              semanticLabel: 'Letzte Ziffer löschen',
                              size: 21,
                            )
                          : Text(
                              row[i],
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => key('/'),
              child: const Text('/  Bruch'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => key('-'),
              child: const Text('−  Minus'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => key('clear'),
              child: const Text('Löschen'),
            ),
          ),
        ],
      ),
    ],
  );
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.config,
    required this.attempts,
    required this.allProblems,
    required this.score,
    required this.highest,
    required this.completed,
    required this.elapsed,
  });
  final RunConfig config;
  final List<Attempt> attempts;
  final List<Problem> allProblems;
  final int score, highest;
  final bool completed;
  final Duration elapsed;
  @override
  Widget build(BuildContext context) {
    final correct = attempts.where((a) => a.correct).length;
    final total = config.mode == RunMode.test
        ? allProblems.length
        : attempts.length;
    final grade = gradeFor(correct, total);
    final unanswered = config.mode == RunMode.test
        ? allProblems.skip(attempts.length).toList()
        : <Problem>[];
    return PortraitFrame(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Label(config.mode.label),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Zum Start',
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(child: Bud(size: 120)),
              const SizedBox(height: 18),
              Text(
                config.mode == RunMode.test
                    ? 'Dein Test ist ausgewertet.'
                    : completed
                    ? 'Run geschafft!'
                    : 'Run gespeichert.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jede Aufgabe macht deinen Kopf ein Stück fitter.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted),
              ),
              const SizedBox(height: 24),
              Panel(
                color: lime,
                child: Column(
                  children: [
                    Label(
                      config.mode == RunMode.test
                          ? 'Deine Note'
                          : 'Deine Punkte',
                      color: teal,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      config.mode == RunMode.test ? grade : '$score',
                      style: const TextStyle(
                        fontSize: 66,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      config.mode == RunMode.test
                          ? '$correct von $total Aufgaben richtig'
                          : '$correct von ${attempts.length} richtig · Level $highest erreicht',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (config.mode == RunMode.test) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${(correct * 120 / total).toStringAsFixed(1).replaceAll('.', ',')} / 120 Vergleichspunkte',
                        style: const TextStyle(fontSize: 12, color: teal),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                config.mode == RunMode.speed
                    ? '${config.minutes}-Minuten-Speedrun · ${completed ? 'vollständig' : 'vorzeitig beendet, kein Rekord'}'
                    : 'Rechenzeit: ${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, fontSize: 12),
              ),
              if (unanswered.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${unanswered.length} unbeantwortete Aufgaben zählen als falsch.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: muted),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zurück zum Start'),
              ),
              if (config.mode == RunMode.speed) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text:
                            'Mathe Bud-E · ${config.minutes} Minuten · $score Punkte · Level $highest · $correct richtige Antworten · ${completed ? 'vollständig' : 'abgebrochen'} · Regeln: Level 1, 8 richtig/5 Fehler, Tipps ohne Punkte · v1',
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ergebnis zum Vergleichen kopiert.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Score zum Vergleichen kopieren'),
                ),
              ],
              if (config.mode == RunMode.test)
                TextButton(
                  onPressed: () => showGradeScheme(context),
                  child: const Text('So wurde deine Note berechnet'),
                ),
              const SizedBox(height: 24),
              const Text(
                'Nachschauen & verstehen',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tippe auf eine Aufgabe für die Erklärung.',
                style: TextStyle(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 14),
              if (attempts.isEmpty && unanswered.isEmpty)
                const Text(
                  'Beim nächsten Run wartet deine erste Aufgabe auf dich.',
                  style: TextStyle(color: muted),
                ),
              for (final a in attempts)
                reviewTile(context, a.problem, a.input, a.correct, a.assisted),
              for (final p in unanswered)
                reviewTile(context, p, 'nicht beantwortet', false, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewTile(
    BuildContext context,
    Problem p,
    String input,
    bool correct,
    bool assisted,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: line),
      ),
      child: InkWell(
        onTap: () => showHint(context, p),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                correct ? Icons.check_circle_outline : Icons.lightbulb_outline,
                color: correct ? teal : const Color(0xFFB65A2F),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.text,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Deins: $input${assisted ? ' · mit Tipp' : ''}',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                    if (!correct)
                      Text(
                        'Lösung: ${p.solution}',
                        style: const TextStyle(
                          color: teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathe_bud_e/domain/math_engine.dart';
import 'package:mathe_bud_e/domain/reference_test.dart';

void main() {
  test(
    'Level 6 preserves equal denominators; fraction arithmetic is correct',
    () {
      final g = ProblemGenerator(Random(123));
      final pattern = RegExp(r'^(\d+)/(\d+) ([+−]) (\d+)/(\d+)$');
      for (final level in [6, 7]) {
        for (var i = 0; i < 200; i++) {
          final p = g.next(level, Topic.fractions);
          final m = pattern.firstMatch(p.text)!;
          final n1 = int.parse(m[1]!);
          final d1 = int.parse(m[2]!);
          final n2 = int.parse(m[4]!);
          final d2 = int.parse(m[5]!);
          if (level == 6) expect(d1, d2);
          final expected = m[3] == '+' ? n1 / d1 + n2 / d2 : n1 / d1 - n2 / d2;
          expect(p.answer.n / p.answer.d, closeTo(expected, 1e-10));
        }
      }
    },
  );

  test(
    'Generated decimal and fraction products match the visible arithmetic',
    () {
      final g = ProblemGenerator(Random(321));
      double value(String s) {
        final parts = s.replaceAll(',', '.').split('/');
        return double.parse(parts[0]) /
            (parts.length == 2 ? double.parse(parts[1]) : 1);
      }

      for (final topic in [Topic.decimals, Topic.fractionProduct]) {
        for (var i = 0; i < 300; i++) {
          final p = g.next(10, topic);
          final parts = p.text.split(' ');
          final a = value(parts[0]), b = value(parts[2]);
          final expected = switch (parts[1]) {
            '+' => a + b,
            '−' => a - b,
            '×' => a * b,
            _ => a / b,
          };
          expect(
            p.answer.n / p.answer.d,
            closeTo(expected, 1e-9),
            reason: p.text,
          );
        }
      }
    },
  );

  test(
    'German decimals and fractions are exact, invalid input is rejected',
    () {
      expect(Rational.parse('0,125'), Rational(1, 8));
      expect(Rational.parse('-1,25'), Rational(-5, 4));
      expect(Rational.parse(' 2 / 4 '), Rational(1, 2));
      expect(Rational.parse('1/0'), isNull);
      expect(Rational.parse('1/2/3'), isNull);
      expect(Rational.parse('1,'), isNull);
      expect(Rational.parse('NaN'), isNull);
      expect(Rational.parse('1.000,5'), isNull);
      expect(Rational(1, 3) + Rational(1, 6), Rational(1, 2));
      expect(Rational(3, 4) / Rational(2, 3), Rational(9, 8));
    },
  );

  test('Every original question and grade boundary follow the photograph', () {
    final tasks = referenceTest();
    expect(tasks.length, 120);
    expect(tasks.first.answer, Rational(99));
    expect(tasks[13].answer, Rational(208));
    expect(tasks[41].answer, Rational(84));
    expect(tasks[93].answer, Rational(292));
    expect(tasks.last.answer, Rational(24));
    for (var row = 0; row < referenceRows.length; row++) {
      final r = referenceRows[row];
      expect(tasks[row * 4].answer, Rational(r[0] * r[1]));
      expect(tasks[row * 4 + 1].answer, Rational(r[2] + r[3]));
      expect(tasks[row * 4 + 2].answer, Rational(r[4] - r[5]));
      expect(r[6] % r[7], 0);
      expect(tasks[row * 4 + 3].answer, Rational(r[6] ~/ r[7]));
    }
    expect(gradeFor(46, 120), '4+');
    expect(gradeFor(120, 120), '1+');
    for (var i = 0; i < gradeBands.length; i++) {
      final (points, grade) = gradeBands[i];
      expect(gradeFor(points, 120), grade);
      if (points > 0) expect(gradeFor(points - 1, 120), gradeBands[i + 1].$2);
    }
    expect(gradeFor(15, 20), '1+');
    expect(gradeFor(14, 20), '1−');
    expect(gradeFor(0, 20), '6');
    expect(gradeFor(0, 0), '–');
  });

  test(
    'Adaptive training rises, accumulates errors and respects topic floor',
    () {
      final a = AdaptiveLevel(level: 3, upAfter: 8, downAfter: 5);
      for (var i = 0; i < 7; i++) {
        expect(a.record(true), 0);
      }
      expect(a.record(true), 1);
      expect(a.level, 4);
      expect(a.streak, 0);
      for (var i = 0; i < 4; i++) {
        a.record(false);
        a.record(true);
      }
      expect(a.record(false), -1);
      expect(a.level, 3);
      expect(a.errors, 0);
      final floor = AdaptiveLevel(
        level: 6,
        minimum: 6,
        upAfter: 5,
        downAfter: 5,
      );
      for (var i = 0; i < 15; i++) {
        floor.record(false);
      }
      expect(floor.level, 6);
      final ceiling = AdaptiveLevel(level: 10, upAfter: 5);
      for (var i = 0; i < 10; i++) {
        ceiling.record(true);
      }
      expect(ceiling.level, 10);
    },
  );

  test(
    'Thousands of generated tasks have accepted solutions and appropriate topics',
    () {
      final generator = ProblemGenerator(Random(42));
      for (var level = 1; level <= 10; level++) {
        for (final topic in generator.topicsFor(level)) {
          for (var i = 0; i < 100; i++) {
            final p = generator.next(level, topic);
            expect(
              p.accepts(p.solution),
              isTrue,
              reason: 'Level $level: ${p.text}, ${p.solution}',
            );
            expect(p.answer.d, greaterThan(0));
            expect(p.steps, isNotEmpty);
            expect(p.topic.minimumLevel, lessThanOrEqualTo(level));
            if (p.topic == Topic.division) expect(p.answer.d, 1);
            if (level <= 3) expect(p.answer.n, greaterThanOrEqualTo(0));
            if (topic != Topic.mixed) expect(p.topic, topic);
          }
        }
      }
    },
  );

  test('Fraction transformations require the requested form', () {
    final expand = Problem(
      text: 'Erweitere 1/2 auf Nenner 8',
      answer: Rational(1, 2),
      topic: Topic.transform,
      tip: '',
      steps: [],
      requiredDenominator: 8,
    );
    expect(expand.accepts('4/8'), isTrue);
    expect(expand.accepts('1/2'), isFalse);
    expect(expand.solution, '4/8');
    final reduce = Problem(
      text: 'Kürze 4/8',
      answer: Rational(1, 2),
      topic: Topic.transform,
      tip: '',
      steps: [],
      requireReduced: true,
    );
    expect(reduce.accepts('1/2'), isTrue);
    expect(reduce.accepts('4/8'), isFalse);
    expect(reduce.accepts('0,5'), isFalse);
    final frac = Problem(
      text: '1/4 + 1/4',
      answer: Rational(1, 2),
      topic: Topic.fractions,
      tip: '',
      steps: [],
    );
    expect(frac.accepts('0,5'), isTrue);
    expect(frac.accepts('2/4'), isTrue);
  });
}

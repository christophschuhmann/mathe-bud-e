import 'dart:math';

enum Topic {
  mixed('Gemischt', 'Alle Themen dieses Levels'),
  addition('Addition', 'Geschickt zusammenzählen'),
  subtraction('Subtraktion', 'Schrittweise abziehen'),
  multiplication('Multiplikation', 'Malnehmen mit Köpfchen'),
  division('Division', 'Teilen ohne Rätsel'),
  decimals('Kommazahlen', 'Mit Zehnteln und Hundertsteln'),
  fractions('Brüche + und −', 'Gleich große Stücke rechnen'),
  transform('Kürzen & Erweitern', 'Andere Zahlen, gleicher Anteil'),
  fractionProduct('Brüche × und ÷', 'Anteile malnehmen und teilen'),
  percent('Prozentrechnung', 'Anteile von hundert');

  const Topic(this.label, this.description);
  final String label;
  final String description;
  int get minimumLevel => switch (this) {
    Topic.decimals => 5,
    Topic.fractions || Topic.transform => 6,
    Topic.fractionProduct => 8,
    Topic.percent => 9,
    _ => 1,
  };
}

const levelNames = [
  'Warm werden',
  'Sicher rechnen',
  'Klasse 5 · wie auf dem Blatt',
  'Große Zahlen & Klammern',
  'Komma, klar!',
  'Brüche entdecken',
  'Brüche verbinden',
  'Brüche mal & geteilt',
  'Prozent verstehen',
  'Mathe-Mix meistern',
];
const levelDescriptions = [
  'Plus und Minus bis 20, kleines Einmaleins und einfaches Teilen.',
  'Plus und Minus bis 100, Einmaleins und Division ohne Rest.',
  'Vier Grundrechenarten: meist bis 300, wie im Übungstest.',
  'Bis 1.000 rechnen. Klammern und Punkt vor Strich entdecken.',
  'Zehntel und Hundertstel addieren, abziehen, malnehmen und teilen.',
  'Gleichnamige Brüche addieren, subtrahieren, kürzen und erweitern.',
  'Verschiedene Nenner auf eine gemeinsame Stückgröße bringen.',
  'Brüche multiplizieren und durch einen Bruch teilen.',
  'Einfache Prozentsätze, Prozentwerte und Anteile berechnen.',
  'Brüche, Kommazahlen und Prozent kombinieren. Rabatte und Grundwerte.',
];

class Rational {
  factory Rational(int n, [int d = 1]) {
    if (d == 0) throw ArgumentError('Nenner darf nicht null sein');
    final sign = d < 0 ? -1 : 1;
    final g = n.gcd(d);
    return Rational._(n ~/ g * sign, d.abs() ~/ g);
  }
  const Rational._(this.n, this.d);
  final int n;
  final int d;
  Rational operator +(Rational b) => Rational(n * b.d + b.n * d, d * b.d);
  Rational operator -(Rational b) => Rational(n * b.d - b.n * d, d * b.d);
  Rational operator *(Rational b) => Rational(n * b.n, d * b.d);
  Rational operator /(Rational b) => Rational(n * b.d, d * b.n);
  String get fraction => d == 1 ? '$n' : '$n/$d';
  String get decimal {
    if (d == 1) return '$n';
    return (n / d)
        .toStringAsFixed(4)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '')
        .replaceAll('.', ',');
  }

  static Rational? parse(String input) {
    final s = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (s.isEmpty || s.length > 40) return null;
    if (s.contains('/')) {
      final parts = s.split('/');
      if (parts.length != 2) return null;
      final a = int.tryParse(parts[0]);
      final b = int.tryParse(parts[1]);
      return a == null || b == null || b == 0 ? null : Rational(a, b);
    }
    if (!RegExp(r'^[+-]?\d+(\.\d{1,6})?$').hasMatch(s)) return null;
    final parts = s.split('.');
    final denominator = parts.length == 2
        ? pow(10, parts[1].length).toInt()
        : 1;
    final numerator = int.tryParse(s.replaceAll('.', ''));
    return numerator == null ? null : Rational(numerator, denominator);
  }

  @override
  bool operator ==(Object other) =>
      other is Rational && n == other.n && d == other.d;
  @override
  int get hashCode => Object.hash(n, d);
}

class Problem {
  const Problem({
    required this.text,
    required this.answer,
    required this.topic,
    required this.tip,
    required this.steps,
    this.decimalAnswer = false,
    this.suffix = '',
    this.visualNumerator,
    this.visualDenominator,
    this.requiredDenominator,
    this.requireReduced = false,
  });
  final String text;
  final Rational answer;
  final Topic topic;
  final String tip;
  final List<String> steps;
  final bool decimalAnswer;
  final String suffix;
  final int? visualNumerator;
  final int? visualDenominator;
  final int? requiredDenominator;
  final bool requireReduced;
  String get solution {
    if (requiredDenominator != null) {
      return '${answer.n * (requiredDenominator! ~/ answer.d)}/$requiredDenominator';
    }
    return '${decimalAnswer ? answer.decimal : answer.fraction}$suffix';
  }

  bool accepts(String input) {
    final clean = suffix == ' %' ? input.replaceAll('%', '') : input;
    if (Rational.parse(clean) != answer) return false;
    if (requiredDenominator != null || requireReduced) {
      final parts = clean.replaceAll(' ', '').split('/');
      if (parts.length != 2) {
        return answer.d == 1 && requiredDenominator == null;
      }
      final a = int.tryParse(parts[0]);
      final b = int.tryParse(parts[1]);
      if (a == null || b == null || b <= 0) return false;
      if (requiredDenominator != null && b != requiredDenominator) return false;
      if (requireReduced && a.gcd(b) != 1) return false;
    }
    return true;
  }
}

class ProblemGenerator {
  ProblemGenerator([Random? random]) : random = random ?? Random();
  final Random random;
  int between(int lo, int hi) => lo + random.nextInt(hi - lo + 1);
  T pick<T>(List<T> list) => list[random.nextInt(list.length)];
  List<Topic> topicsFor(int level) =>
      Topic.values.where((t) => t.minimumLevel <= level).toList();

  Problem next(int level, [Topic topic = Topic.mixed]) {
    level = level.clamp(1, 10);
    if (topic != Topic.mixed) level = max(level, topic.minimumLevel);
    if (topic == Topic.mixed) {
      final options = topicsFor(level).where((t) => t != Topic.mixed).toList();
      topic = pick(options);
      if (level == 4 && random.nextInt(5) == 0) return _order();
    }
    if (topic == Topic.decimals) return _decimal(level);
    if (topic == Topic.fractions) return _fractions(level);
    if (topic == Topic.transform) return _transform(level);
    if (topic == Topic.fractionProduct) return _fractionProduct(level);
    if (topic == Topic.percent) return _percent(level);
    int a, b;
    switch (topic) {
      case Topic.addition:
        a = between(level == 1 ? 1 : 20, [10, 80, 284, 850][min(level, 4) - 1]);
        b = between(
          1,
          level == 1
              ? 20 - a
              : level == 2
              ? 100 - a
              : level == 3
              ? 29
              : 150,
        );
      case Topic.subtraction:
        a = between(
          level == 1 ? 2 : 30,
          [20, 100, 283, 1000][min(level, 4) - 1],
        );
        b = between(
          level == 3 ? 20 : 1,
          level == 3
              ? 29
              : level == 1
              ? a
              : min(a, level == 2 ? 50 : 350),
        );
      case Topic.multiplication:
        a = between(
          2,
          level == 1
              ? 5
              : level == 2
              ? 10
              : level == 3
              ? 29
              : 50,
        );
        b = between(2, level <= 3 ? 10 : 20);
      default:
        b = between(
          2,
          level == 1
              ? 5
              : level == 2
              ? 10
              : level == 3
              ? 29
              : 40,
        );
        a =
            b *
            between(
              2,
              level == 1
                  ? 5
                  : level == 2
                  ? 10
                  : level == 3
                  ? min(24, 216 ~/ b)
                  : 25,
            );
    }
    return integer(a, b, topic);
  }

  Problem integer(int a, int b, Topic topic) {
    final split = b ~/ 10 * 10;
    final rest = b % 10;
    switch (topic) {
      case Topic.addition:
        return Problem(
          text: '$a + $b',
          answer: Rational(a + b),
          topic: topic,
          tip:
              'Zerlege die zweite Zahl in Zehner und Einer. So sind die Schritte kleiner.',
          steps: [
            '$b = $split + $rest',
            '$a + $split = ${a + split}',
            '${a + split} + $rest = ${a + b}',
          ],
        );
      case Topic.subtraction:
        return Problem(
          text: '$a − $b',
          answer: Rational(a - b),
          topic: topic,
          tip:
              'Zieh erst die Zehner ab, dann die Einer. Bei 29 kannst du auch 30 abziehen und 1 zurückgeben.',
          steps: [
            '$b = $split + $rest',
            '$a − $split = ${a - split}',
            '${a - split} − $rest = ${a - b}',
          ],
        );
      case Topic.multiplication:
        final tens = a ~/ 10 * 10;
        final ones = a % 10;
        return Problem(
          text: '$a × $b',
          answer: Rational(a * b),
          topic: topic,
          tip:
              'Teile eine Zahl in einfache Teile auf. Multipliziere jeden Teil und zähle die Ergebnisse zusammen.',
          steps: a < 10
              ? [
                  '$a × $b heißt: $a Gruppen mit je $b.',
                  '${List.filled(a, '$b').join(' + ')} = ${a * b}',
                ]
              : [
                  '$a = $tens + $ones',
                  '$tens × $b = ${tens * b}   •   $ones × $b = ${ones * b}',
                  '${tens * b} + ${ones * b} = ${a * b}',
                ],
        );
      default:
        return Problem(
          text: '$a ÷ $b',
          answer: Rational(a, b),
          topic: Topic.division,
          tip:
              'Teilen ist die Umkehrung vom Malnehmen. Frag dich: Wie oft passt $b in $a?',
          steps: [
            '$b × ? = $a',
            '$b × ${a ~/ b} = $a',
            'Also: $a ÷ $b = ${a ~/ b}',
          ],
        );
    }
  }

  Problem _order() {
    final a = between(2, 12), b = between(2, 9), c = between(2, 9);
    final bracket = random.nextBool();
    return Problem(
      text: bracket ? '($a + $b) × $c' : '$a + $b × $c',
      answer: Rational(bracket ? (a + b) * c : a + b * c),
      topic: Topic.multiplication,
      tip:
          'Klammern zuerst! Ohne Klammer rechnest du Mal und Geteilt vor Plus und Minus.',
      steps: bracket
          ? ['$a + $b = ${a + b}', '${a + b} × $c = ${(a + b) * c}']
          : ['$b × $c = ${b * c}', '$a + ${b * c} = ${a + b * c}'],
    );
  }

  Problem _decimal(int level) {
    final d = level >= 7 ? 100 : 10;
    var a = Rational(between(1, d * 8), d), b = Rational(between(1, d * 3), d);
    final op = between(0, 3);
    if (op == 1 && a.n * b.d < b.n * a.d) {
      final t = a;
      a = b;
      b = t;
    }
    if (op >= 2) b = Rational(between(2, 9));
    final result = switch (op) {
      0 => a + b,
      1 => a - b,
      2 => a * b,
      _ => a,
    };
    if (op == 3) {
      final product = a * b;
      return Problem(
        text: '${product.decimal} ÷ ${b.decimal}',
        answer: a,
        topic: Topic.decimals,
        decimalAnswer: true,
        tip:
            'Denk an die passende Malaufgabe. Das Komma bleibt bei der passenden Größe.',
        steps: [
          '${b.decimal} × ? = ${product.decimal}',
          '${b.decimal} × ${a.decimal} = ${product.decimal}',
          'Das Ergebnis ist ${a.decimal}.',
        ],
      );
    }
    return Problem(
      text: '${a.decimal} ${['+', '−', '×'][op]} ${b.decimal}',
      answer: result,
      topic: Topic.decimals,
      decimalAnswer: true,
      tip: op == 2
          ? 'Rechne erst ohne Komma. Danach bekommt das Ergebnis genauso viele Nachkommastellen wie die erste Zahl.'
          : 'Stell dir Euro und Cent vor: Kommas stehen untereinander. Zähle gleich große Stellen zusammen oder zieh sie ab.',
      steps: op == 2
          ? [
              '${a.decimal} = ${a.n} ÷ ${a.d}',
              '${a.n} × ${b.n} = ${a.n * b.n}',
              '${a.n * b.n} ÷ ${a.d} = ${result.decimal}',
            ]
          : [
              'Rechne in ${d == 10 ? 'Zehnteln' : 'Hundertsteln'}.',
              '${a.n * (d ~/ a.d)} ${op == 0 ? '+' : '−'} ${b.n * (d ~/ b.d)} = ${result.n * (d ~/ result.d)}',
              'Teile durch $d: ${result.decimal}',
            ],
    );
  }

  Problem _fractions(int level) {
    var d1 = pick([2, 3, 4, 5, 6, 8]);
    var d2 = level <= 6 ? d1 : pick([2, 3, 4, 6, 8]);
    var n1 = between(1, d1 - 1), n2 = between(1, d2 - 1);
    var a = Rational(n1, d1), b = Rational(n2, d2);
    final minus = random.nextBool();
    if (minus && a.n * b.d < b.n * a.d) {
      final t = a;
      a = b;
      b = t;
      final oldN = n1, oldD = d1;
      n1 = n2;
      d1 = d2;
      n2 = oldN;
      d2 = oldD;
    }
    final common = d1 * d2 ~/ d1.gcd(d2);
    final an = n1 * (common ~/ d1), bn = n2 * (common ~/ d2);
    final result = minus ? a - b : a + b;
    return Problem(
      text: '$n1/$d1 ${minus ? '−' : '+'} $n2/$d2',
      answer: result,
      topic: Topic.fractions,
      tip:
          'Du kannst nur gleich große Stücke zusammenzählen. Mach die unteren Zahlen gleich. Rechne dann oben; die untere Zahl bleibt.',
      steps: [
        '$n1/$d1 = $an/$common   •   $n2/$d2 = $bn/$common',
        '$an ${minus ? '−' : '+'} $bn = ${minus ? an - bn : an + bn}',
        '${minus ? an - bn : an + bn}/$common = ${result.fraction}',
      ],
      visualNumerator: an,
      visualDenominator: common,
    );
  }

  Problem _transform(int level) {
    final d = pick([3, 4, 5, 6, 8]);
    final a = Rational(between(1, d - 1), d);
    final k = between(2, level >= 7 ? 5 : 3);
    final reduce = random.nextBool();
    return Problem(
      text: reduce
          ? 'Kürze ${a.n * k}/${a.d * k} vollständig'
          : 'Erweitere ${a.fraction} auf Nenner ${a.d * k}',
      answer: a,
      topic: Topic.transform,
      requireReduced: reduce,
      requiredDenominator: reduce ? null : a.d * k,
      tip:
          'Oben und unten immer dasselbe tun! Beim Kürzen teilst du beide Zahlen. Beim Erweitern nimmst du beide mal. Der Anteil bleibt gleich.',
      steps: reduce
          ? [
              'Oben: ${a.n * k} ÷ $k = ${a.n}',
              'Unten: ${a.d * k} ÷ $k = ${a.d}',
              '${a.n * k}/${a.d * k} = ${a.fraction}',
            ]
          : [
              'Oben: ${a.n} × $k = ${a.n * k}',
              'Unten: ${a.d} × $k = ${a.d * k}',
              '${a.fraction} = ${a.n * k}/${a.d * k}',
            ],
      visualNumerator: a.n,
      visualDenominator: a.d,
    );
  }

  Problem _fractionProduct(int level) {
    final a = Rational(between(1, 5), pick([3, 4, 6, 8]));
    final b = Rational(between(1, 4), pick([2, 3, 5, 6]));
    final divide = random.nextBool();
    final result = divide ? a / b : a * b;
    return Problem(
      text: '${a.fraction} ${divide ? '÷' : '×'} ${b.fraction}',
      answer: result,
      topic: Topic.fractionProduct,
      tip: divide
          ? 'Beim Teilen drehst du den zweiten Bruch um. Danach rechnest du mal: oben mal oben, unten mal unten.'
          : 'Beim Malnehmen brauchst du keinen gemeinsamen Nenner. Rechne oben mal oben und unten mal unten. Am Ende kannst du kürzen.',
      steps: [
        if (divide) '${a.fraction} × ${b.d}/${b.n}',
        '${a.n} × ${divide ? b.d : b.n} = ${a.n * (divide ? b.d : b.n)}',
        '${a.d} × ${divide ? b.n : b.d} = ${a.d * (divide ? b.n : b.d)}',
        'Gekürzt: ${result.fraction}',
      ],
    );
  }

  Problem _percent(int level) {
    final p = pick(
      level == 9 ? [10, 20, 25, 50, 75] : [5, 10, 15, 20, 25, 30, 75],
    );
    final base = pick([40, 80, 100, 120, 200, 240, 400]);
    final value = Rational(base * p, 100);
    final kind = between(0, level == 10 ? 3 : 1);
    if (kind == 1) {
      return Problem(
        text: '${value.decimal} von $base sind wie viel Prozent?',
        answer: Rational(p),
        topic: Topic.percent,
        suffix: ' %',
        tip:
            'Prozent heißt „von hundert“. Teile den Anteil durch das Ganze und nimm das Ergebnis mal 100.',
        steps: [
          '${value.decimal} ÷ $base = ${Rational(p, 100).decimal}',
          '${Rational(p, 100).decimal} × 100 = $p',
          'Das sind $p %.',
        ],
        visualNumerator: p ~/ 5,
        visualDenominator: 20,
      );
    }
    if (kind == 2) {
      return Problem(
        text: '$p % sind ${value.decimal}. Wie viel sind 100 %?',
        answer: Rational(base),
        topic: Topic.percent,
        tip:
            'Rechne zuerst zurück auf 1 %. Von 1 % kommst du mit mal 100 zum Ganzen.',
        steps: [
          '1 % = ${value.decimal} ÷ $p = ${Rational(base, 100).decimal}',
          '100 % = ${Rational(base, 100).decimal} × 100 = $base',
        ],
      );
    }
    final discount = kind == 3;
    return Problem(
      text: discount
          ? '$base € mit $p % Rabatt. Neuer Preis?'
          : '$p % von $base',
      answer: discount ? Rational(base) - value : value,
      topic: Topic.percent,
      decimalAnswer: true,
      tip:
          'Finde erst 1 %: das Ganze durch 100. Dann nimmst du diesen Wert mal den Prozentsatz.${discount ? ' Den Rabatt ziehst du vom alten Preis ab.' : ''}',
      steps: [
        '1 % = $base ÷ 100 = ${Rational(base, 100).decimal}',
        '$p % = ${Rational(base, 100).decimal} × $p = ${value.decimal}',
        if (discount)
          '$base − ${value.decimal} = ${(Rational(base) - value).decimal} €',
      ],
      visualNumerator: p ~/ 5,
      visualDenominator: 20,
    );
  }
}

const gradeBands = <(int, String)>[
  (90, '1+'),
  (85, '1'),
  (80, '1−'),
  (75, '2+'),
  (70, '2'),
  (65, '2−'),
  (60, '3+'),
  (55, '3'),
  (50, '3−'),
  (45, '4+'),
  (40, '4'),
  (35, '4−'),
  (30, '5+'),
  (25, '5'),
  (20, '5−'),
  (0, '6'),
];
String gradeFor(int correct, int total) {
  if (total <= 0) return '–';
  // Compare without rounding: a shortened test uses equivalent /120 points.
  return gradeBands.firstWhere((band) => correct * 120 >= band.$1 * total).$2;
}

class AdaptiveLevel {
  AdaptiveLevel({
    this.level = 1,
    this.upAfter = 8,
    this.downAfter = 5,
    this.minimum = 1,
  });
  int level;
  final int upAfter, downAfter, minimum;
  int streak = 0, errors = 0;
  int record(bool correct) {
    final previous = level;
    if (correct) {
      streak++;
      if (streak >= upAfter) {
        level = min(10, level + 1);
        streak = 0;
        errors = 0;
      }
    } else {
      streak = 0;
      errors++;
      if (errors >= downAfter) {
        level = max(minimum, level - 1);
        streak = 0;
        errors = 0;
      }
    }
    return level - previous;
  }
}

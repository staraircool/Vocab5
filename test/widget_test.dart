import 'package:flutter_test/flutter_test.dart';

import 'package:vocabpro/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VocabProApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);
    expect(find.text('Hi, Learner'), findsOneWidget);
  });
}


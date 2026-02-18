import 'package:flutter_test/flutter_test.dart';

import 'package:interview_flutter/main.dart';

void main() {
  testWidgets('starter app renders product hub shell', (WidgetTester tester) async {
    await tester.pumpWidget(const InterviewStarterApp());
    await tester.pumpAndSettle();

    expect(find.text('Product Hub'), findsOneWidget);
  });
}

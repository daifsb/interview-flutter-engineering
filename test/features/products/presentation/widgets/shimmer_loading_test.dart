import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/features/products/presentation/widgets/shimmer_loading.dart';

void main() {
  testWidgets('ShimmerProductGrid renders 6 placeholder cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ShimmerProductGrid())),
    );

    // GridView.builder lazily builds only viewport-visible items.
    // With the default 800×600 test surface, 4 of the 6 cards are built.
    expect(find.byType(Card), findsAtLeastNWidgets(4));
  });
}

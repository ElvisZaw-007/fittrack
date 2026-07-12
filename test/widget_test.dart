import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fittrack/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FitTrackApp()));

    await tester.pumpAndSettle();

    expect(find.byType(FitTrackApp), findsOneWidget);
  });
}

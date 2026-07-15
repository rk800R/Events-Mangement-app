import 'package:flutter_test/flutter_test.dart';
import 'package:harmonical/app.dart';

void main() {
  testWidgets('HarmoniCal app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HarmoniCalApp());
    expect(find.text('Month'), findsOneWidget);
  });
}

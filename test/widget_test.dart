import 'package:flutter_test/flutter_test.dart';
import 'package:dars_jadval/main.dart';

void main() {
  testWidgets('Dars jadvali ilovasi ishga tushadi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const SchoolScheduleApp(),
    );

    expect(find.text('Bugun'), findsOneWidget);
    expect(find.text('Jadval'), findsOneWidget);
    expect(find.text("Qo'shish"), findsOneWidget);
    expect(find.text('Sozlamalar'), findsOneWidget);
  });
}
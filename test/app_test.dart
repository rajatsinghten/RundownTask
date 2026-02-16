import 'package:flutter_test/flutter_test.dart';
import 'package:rundown_task/app.dart';

void main() {
  testWidgets('App should render main screen with bottom nav',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RundownTaskApp());

    // Verify bottom nav items are present
    expect(find.text('To Do'), findsOneWidget);
    expect(find.text('Inbox'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Chatbot'), findsOneWidget);

    // Verify home screen is shown by default
    expect(find.text('RunDown'), findsOneWidget);
    expect(find.text('TIMELINE'), findsOneWidget);
  });
}

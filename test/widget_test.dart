import 'package:flutter_test/flutter_test.dart';
import 'package:healthybite/main.dart';

void main() {
  testWidgets('HealthyBite menampilkan halaman utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HealthyBiteApp());

    expect(find.text('HealthyBite 🌿'), findsOneWidget);
    expect(find.text('Makan Sehat, Hidup Lebih Baik'), findsOneWidget);
    expect(find.text('Pilih Tujuan'), findsOneWidget);
  });
}

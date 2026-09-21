import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

void main() {
  testWidgets('root theme, initial destination, and role switch', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'PanganKita');
    expect(app.theme?.colorScheme.primary, PanganKitaColors.brandPrimary);
    expect(app.theme?.navigationBarTheme.indicatorColor, Colors.transparent);
    expect(
      app.theme?.navigationBarTheme.iconTheme?.resolve({
        WidgetState.selected,
      })?.color,
      PanganKitaColors.brandPrimary,
    );
    expect(find.text('Eksplor'), findsWidgets);
    expect(find.text('Paket pastry pilihan'), findsOneWidget);

    await _switchRole(tester, 'Mode Bisnis');
    expect(find.text('Listing'), findsWidgets);
    expect(find.text('Bisnis'), findsOneWidget);

    await _switchRole(tester, 'Mode Konsumen');
    expect(find.text('Eksplor'), findsWidgets);
  });
}

Future<void> _switchRole(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

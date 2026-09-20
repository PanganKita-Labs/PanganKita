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
    expect(
      app.theme?.navigationBarTheme.indicatorColor,
      PanganKitaColors.brandPrimary,
    );
    expect(
      app.theme?.navigationBarTheme.iconTheme?.resolve({
        WidgetState.selected,
      })?.color,
      Colors.white,
    );
    expect(find.text('Jelajahi'), findsWidgets);
    expect(find.text('Paket pastry pilihan'), findsOneWidget);

    await tester.tap(find.text('Mode Bisnis'));
    await tester.pumpAndSettle();
    expect(find.text('Listing'), findsWidgets);
    expect(find.text('Bisnis'), findsOneWidget);

    await tester.tap(find.text('Mode Konsumen'));
    await tester.pumpAndSettle();
    expect(find.text('Jelajahi'), findsWidgets);
  });
}

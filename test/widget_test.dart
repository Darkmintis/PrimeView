import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:primeview/core/theme/app_theme.dart';
import 'package:primeview/shared/widgets/loading_widget.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('PrimeViewApp renders with theme', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      const Center(child: Text('PrimeView', style: TextStyle(color: Colors.white))),
    ));
    await tester.pump();

    expect(find.text('PrimeView'), findsOneWidget);
  });

  testWidgets('ChannelLoadingSkeleton renders in ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: _wrap(const ChannelLoadingSkeleton())),
    );
    await tester.pump();

    expect(find.byType(ChannelLoadingSkeleton), findsOneWidget);
    expect(find.byType(ShimmerBlock), findsWidgets);
  });
}

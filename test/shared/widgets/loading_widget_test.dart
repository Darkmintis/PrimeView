import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:primeview/shared/widgets/loading_widget.dart';

Widget makeTestable(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('ShimmerBlock', () {
    testWidgets('renders with default width', (tester) async {
      await tester.pumpWidget(makeTestable(
        const ShimmerBlock(height: 50),
      ));
      await tester.pump();

      expect(find.byType(ShimmerBlock), findsOneWidget);
    });

    testWidgets('renders with custom width and height', (tester) async {
      await tester.pumpWidget(makeTestable(
        const ShimmerBlock(width: 200, height: 100, borderRadius: 12),
      ));
      await tester.pump();

      expect(find.byType(ShimmerBlock), findsOneWidget);
    });

    testWidgets('renders a Container inside', (tester) async {
      await tester.pumpWidget(makeTestable(
        const ShimmerBlock(height: 30),
      ));
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
    });
  });

  group('ChannelLoadingSkeleton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(makeTestable(
        const ChannelLoadingSkeleton(),
      ));
      await tester.pump();

      expect(find.byType(ChannelLoadingSkeleton), findsOneWidget);
    });

    testWidgets('renders multiple shimmer blocks', (tester) async {
      await tester.pumpWidget(makeTestable(
        const ChannelLoadingSkeleton(),
      ));
      await tester.pump();

      final shimmerBlocks = find.byType(ShimmerBlock);
      expect(shimmerBlocks.evaluate().length, greaterThan(5));
    });
  });
}

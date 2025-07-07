import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

void main() {
  group('createQuery simple integration', () {
    late QueryClient queryClient;

    setUp(() {
      queryClient = QueryClient();
    });

    test('createQuery creates proper configuration', () {
      final config = createQuery(
        ['test'],
        () async => 'Hello',
        enabled: false,
        staleDuration: const Duration(minutes: 5),
      );
      
      expect(config.queryKey, equals(['test']));
      expect(config.fetcher, isNotNull);
      expect(config.enabled, equals(false));
      expect(config.staleDuration, equals(const Duration(minutes: 5)));
    });

    testWidgets('works with useQueryWithConfig', (tester) async {
      final testQuery = createQuery(['test'], () async => 'Test Data');

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<String, dynamic>(testQuery);
                return Text(result.data ?? 'Loading');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Test Data'), findsOneWidget);
    });

    testWidgets('createQuery is now required for useQuery', (tester) async {
      final traditionalQuery = createQuery(
        ['traditional'],
        () async => 'Traditional',
      );
      
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<String, dynamic>(traditionalQuery);
                return Text(result.data ?? 'Loading');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Traditional'), findsOneWidget);
    });

    testWidgets('createQuery with options', (tester) async {
      final optionsQuery = createQuery(
        ['options'],
        () async => 42,
        enabled: true,
        staleDuration: const Duration(seconds: 30),
      );

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<int, dynamic>(optionsQuery);
                return Text(result.data?.toString() ?? 'Loading');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('can also use extension method', (tester) async {
      final extQuery = createQuery(['extension'], () async => 'Via Extension');

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<String, dynamic>(extQuery);
                return Text(result.data ?? 'Loading');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Via Extension'), findsOneWidget);
    });
  });
}
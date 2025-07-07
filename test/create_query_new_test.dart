import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

void main() {
  group('createQuery with useQuery', () {
    late QueryClient queryClient;

    setUp(() {
      queryClient = QueryClient();
    });

    test('should create a simple query config', () {
      final config = createQuery(['test'], () async => 'Hello');
      
      expect(config.queryKey, equals(['test']));
      expect(config.fetcher, isNotNull);
    });

    testWidgets('should work with useQuery', (tester) async {
      final postsQuery = createQuery(['posts'], () async {
        await Future.delayed(const Duration(milliseconds: 50));
        return ['Post 1', 'Post 2', 'Post 3'];
      });

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<List<String>, dynamic>(postsQuery);
                
                if (result.isLoading) {
                  return const Text('Loading');
                }
                
                if (result.isSuccess) {
                  return Text('Posts: ${result.data!.length}');
                }
                
                return const Text('Error');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 50));
      
      expect(find.text('Posts: 3'), findsOneWidget);
    });

    testWidgets('should work with options', (tester) async {
      final numberQuery = createQuery(
        ['number'],
        () async => 42,
        enabled: true,
        refetchOnMount: RefetchOnMount.never,
        staleDuration: const Duration(minutes: 5),
      );

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery<int, dynamic>(numberQuery);
                
                return Text(result.data?.toString() ?? 'No data');
              },
            ),
          ),
        ),
      );

      expect(find.text('No data'), findsOneWidget);
      
      await tester.pumpAndSettle();
      
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('should be reusable across multiple widgets', (tester) async {
      final sharedQuery = createQuery(['shared'], () async => 'Shared Data');

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: Column(
              children: [
                HookBuilder(
                  builder: (context) {
                    final result = useQuery<String, dynamic>(sharedQuery);
                    return Text('Widget1: ${result.data ?? 'Loading'}');
                  },
                ),
                HookBuilder(
                  builder: (context) {
                    final result = useQuery<String, dynamic>(sharedQuery);
                    return Text('Widget2: ${result.data ?? 'Loading'}');
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Widget1: Loading'), findsOneWidget);
      expect(find.text('Widget2: Loading'), findsOneWidget);
      
      await tester.pumpAndSettle();
      
      expect(find.text('Widget1: Shared Data'), findsOneWidget);
      expect(find.text('Widget2: Shared Data'), findsOneWidget);
    });

    testWidgets('should work with useQueryBase for backward compatibility', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                // useQueryBase still supports the old API internally
                final result = useQueryBase<String, dynamic>(
                  ['traditional'],
                  () async => 'Traditional Usage',
                );
                
                return Text(result.data ?? 'Loading');
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      
      await tester.pumpAndSettle();
      
      expect(find.text('Traditional Usage'), findsOneWidget);
    });

    testWidgets('dynamic query creation', (tester) async {
      QueryConfig<String> createUserQuery(int userId) {
        return createQuery(['user', userId], () async => 'User $userId');
      }

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final userId = useState(1);
                final userQuery = createUserQuery(userId.value);
                final result = useQuery<String, dynamic>(userQuery);
                
                return Column(
                  children: [
                    Text(result.data ?? 'Loading'),
                    TextButton(
                      onPressed: () => userId.value = 2,
                      child: const Text('Change User'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Loading'), findsOneWidget);
      
      await tester.pumpAndSettle();
      
      expect(find.text('User 1'), findsOneWidget);
      
      // Change user
      await tester.tap(find.text('Change User'));
      await tester.pump();
      
      expect(find.text('Loading'), findsOneWidget);
      
      await tester.pumpAndSettle();
      
      expect(find.text('User 2'), findsOneWidget);
    });
  });
}
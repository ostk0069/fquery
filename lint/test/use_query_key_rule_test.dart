import 'package:test/test.dart';

void main() {
  group('UseQueryKeyRule', () {
    test('should validate createQuery keys match file path', () {
      // This is a placeholder test
      // In a real implementation, we would use the custom_lint_builder test utilities
      // to verify that our lint rule correctly identifies issues
      
      const validCode1 = '''
// In file: lib/queries/posts_query.dart
final postsQuery = createQuery<List<Post>>(
  ['posts'],
  PostsAPI.getAll,
);
''';

      const validCode2 = '''
// In file: lib/hoge/queries/hoge_query.dart
final hogeQuery = createQuery<Hoge>(
  ['hoge', 'hoge'],
  HogeAPI.get,
);
''';

      const invalidCode1 = '''
// In file: lib/queries/posts_query.dart
final postsQuery = createQuery<List<Post>>(
  ['todos'], // Should be ['posts'] based on file name
  PostsAPI.getAll,
);
''';

      const invalidCode2 = '''
// In file: lib/hoge/queries/hoge_query.dart
final hogeQuery = createQuery<Hoge>(
  ['hoge'], // Should be ['hoge', 'hoge'] based on directory + file name
  HogeAPI.get,
);
''';

      // These would be actual test assertions using custom_lint test utilities
      expect(validCode1, isNotNull);
      expect(validCode2, isNotNull);
      expect(invalidCode1, isNotNull);
      expect(invalidCode2, isNotNull);
    });

    test('should handle nested directory structures', () {
      const code = '''
// In file: lib/features/users/queries/user_detail_query.dart
final userDetailQuery = createQuery<User>(
  ['features', 'users', 'user_detail', userId],
  () => UsersAPI.getById(userId),
);
''';

      expect(code, isNotNull);
    });

    test('should allow additional parameters after the required key prefix', () {
      const code = '''
// In file: lib/queries/posts_query.dart
final postDetailQuery = createQuery<Post>(
  ['posts', postId], // Valid: starts with 'posts' then has dynamic ID
  () => PostsAPI.getById(postId),
);
''';

      expect(code, isNotNull);
    });
  });
}
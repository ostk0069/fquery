import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:dio/dio.dart';
import '../models/post.dart';

// Example demonstrating the select feature
class SelectExamplePage extends HookWidget {
  const SelectExamplePage({Key? key}) : super(key: key);

  Future<List<Post>> getPosts() async {
    final res = await Dio().get('https://jsonplaceholder.typicode.com/posts');
    return (res.data as List)
        .map((e) => Post.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Example 1: Select only post titles
    final postTitles = useQueryWithSelect<List<Post>, Exception, List<String>>(
      ['posts'],
      getPosts,
      select: (posts) => posts.map((post) => post.title).toList(),
    );

    // Example 2: Select post count
    final postCount = useQueryWithSelect<List<Post>, Exception, int>(
      ['posts'],
      getPosts,
      select: (posts) => posts.length,
    );

    // Example 3: Select first 5 posts
    final firstFivePosts = useQueryWithSelect<List<Post>, Exception, List<Post>>(
      ['posts'],
      getPosts,
      select: (posts) => posts.take(5).toList(),
    );

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Select Example'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Post Titles Section
            CupertinoListSection.insetGrouped(
              header: const Text('Post Titles (Select Example)'),
              children: [
                if (postTitles.isLoading)
                  const CupertinoListTile(
                    title: Center(child: CupertinoActivityIndicator()),
                  ),
                if (postTitles.isError)
                  CupertinoListTile(
                    title: Text('Error: ${postTitles.error}'),
                  ),
                if (postTitles.isSuccess && postTitles.data != null)
                  ...postTitles.data!.map((title) => CupertinoListTile(
                        title: Text(title),
                      )),
              ],
            ),
            
            // Post Count Section
            CupertinoListSection.insetGrouped(
              header: const Text('Post Count'),
              children: [
                if (postCount.isLoading)
                  const CupertinoListTile(
                    title: Center(child: CupertinoActivityIndicator()),
                  ),
                if (postCount.isSuccess && postCount.data != null)
                  CupertinoListTile(
                    title: Text('Total Posts: ${postCount.data}'),
                  ),
              ],
            ),

            // First 5 Posts Section
            CupertinoListSection.insetGrouped(
              header: const Text('First 5 Posts'),
              children: [
                if (firstFivePosts.isLoading)
                  const CupertinoListTile(
                    title: Center(child: CupertinoActivityIndicator()),
                  ),
                if (firstFivePosts.isError)
                  CupertinoListTile(
                    title: Text('Error: ${firstFivePosts.error}'),
                  ),
                if (firstFivePosts.isSuccess && firstFivePosts.data != null)
                  ...firstFivePosts.data!.map((post) => CupertinoListTile(
                        title: Text(post.title),
                        subtitle: Text('ID: ${post.id}'),
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Example using QueryBuilder with select
class SelectQueryBuilderExample extends StatelessWidget {
  const SelectQueryBuilderExample({Key? key}) : super(key: key);

  Future<List<Post>> getPosts() async {
    final res = await Dio().get('https://jsonplaceholder.typicode.com/posts');
    return (res.data as List)
        .map((e) => Post.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('QueryBuilder Select Example'),
      ),
      child: SafeArea(
        child: QueryBuilder<List<Post>, Exception, Map<String, dynamic>>(
          ['posts'],
          getPosts,
          select: (posts) => {
            'count': posts.length,
            'titles': posts.take(3).map((p) => p.title).toList(),
            'userIds': posts.map((p) => p.userId).toSet().toList(),
          },
          builder: (context, query) {
            if (query.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            
            if (query.isError) {
              return Center(child: Text('Error: ${query.error}'));
            }
            
            if (query.isSuccess && query.data != null) {
              final data = query.data!;
              return ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    header: const Text('Summary'),
                    children: [
                      CupertinoListTile(
                        title: Text('Total Posts: ${data['count']}'),
                      ),
                      CupertinoListTile(
                        title: Text('Unique Users: ${data['userIds'].length}'),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: const Text('First 3 Post Titles'),
                    children: [
                      ...(data['titles'] as List)
                          .map((title) => CupertinoListTile(
                                title: Text(title),
                              )),
                    ],
                  ),
                ],
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
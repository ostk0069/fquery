import 'package:dio/dio.dart';
import 'package:fquery/fquery.dart';

import '../models/post.dart';
import '../models/todos.dart';

final postsQuery = createQuery<List<Post>>(
  ['posts'],
  () async {
    final res = await Dio().get('https://jsonplaceholder.typicode.com/posts');
    await MockServer.delay();
    return (res.data as List).map((post) => Post.fromMap(post)).toList();
  },
);

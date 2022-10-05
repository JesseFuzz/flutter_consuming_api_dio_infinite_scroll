import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); //: super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List _posts = [];

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (_, index) {
          final post = _posts[index];
          return ListTile(
            title: Text('${post['id']} ${post['title']}'),
            subtitle: Text(post['body']),
          );
        },
      ),
    );
  }

  Future<void> getPosts() async {
    final Response<List> response =
        await Dio().get('https://jsonplaceholder.typicode.com/posts');
    setState(() {
      _posts.addAll(response.data ?? []);
    });
  }
}

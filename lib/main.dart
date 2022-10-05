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
      title: 'Flutter Requsition DIO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lorem ipsum'),
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
  late final ScrollController _controller;

  int _page = 1;
  //criando minha flag booleana para tratar as requisições desnecessárias pra quando a gente chega no fim dos posts:
  bool _isLastPage = false;

  void infiniteScroll() {
    //passo meu método infiniteScroll no addListener e no removeListener
    //se a posição da rolagem for igual a posição máxima da rolagem, faça:
    if (_controller.offset == _controller.position.maxScrollExtent) {
      //se não for a última página eu executo o que está dentro desse IF:
      if (!_isLastPage) {
        _page++; //soma mais 1 a variável da página
        getPosts(); //executa novamente o método getPosts
      }
    }
    //método responsável por fazer o Scroll Infinito
  } //esse método identifica quando o usuário chega até o fim da página e faz uma nova chamada a API

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(
        infiniteScroll); //esse método vai escutar as variações que acontecem no ScrollController
    //aqui eu chamo o método que eu criei para fazer a chamada, o getPosts
    getPosts();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(
        infiniteScroll); //boa prática para quando temos um addListener é termos o remove Listener também.
    _controller.dispose(); //faço isso para desmontar/desligar o meu widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //aqui eu edito como vai aparecer a minha requisição
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _controller,
        //esse elemento ListView me da a opção de scroll
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
    //método usado para fazer a chamada
    final Response<List> response = await Dio().get(
        //dio é o pacote usado para fazer as requisições, assim como o HTTP
        'https://jsonplaceholder.typicode.com/posts?_limit=20&_page=$_page'); //nesse último ponto $_page eu estou concatenando a minha variável _page ao getPosts da página
    //se minha resposta for vazia eu atualizo a minha variável flag:
    if (response.data?.isEmpty ?? false) {
      //não podemos ter null como condição do IF. ?? é o verificador de null do dart, coloquei ele como false, pois caso chegue null não quer dizer
      //que chegou ao final da página, pode ter sido por algum problema. Caso chegue ao final da página ele vai chegar vazio
      _isLastPage = true; //se a lista vier vazia eu atualizo a variável
    }
    setState(() {
      _posts.addAll(response.data ?? []);
    });
  }
}

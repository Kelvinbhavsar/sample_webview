import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  WebViewController? _webViewController;

  void _incrementCounter() {
    _counter++;
    setState(() {
      _webViewController!
          .runJavaScript('receiveMessageFromFlutter("$_counter");');
    });
  }

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadFlutterAsset("assets/sample.html")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "messageHandler",
        onMessageReceived: (JavaScriptMessage javaScriptMessage) {
          print(
              "objec ${int.parse(javaScriptMessage.message.splitMapJoin(".")[0])}");
          setState(() {
            _counter =
                int.parse(javaScriptMessage.message.splitMapJoin(".")[0]);
          });
        },
      );
    super.initState();
  }

  Widget buildWebView() {
    return Column(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: WebViewWidget(
            controller: _webViewController!,
          ),
        ),
        Center(child: Text('$_counter'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: buildWebView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookWebView extends StatefulWidget {
  const FacebookWebView({super.key});

  @override
  State<FacebookWebView> createState() => _FacebookWebViewState();
}

class _FacebookWebViewState extends State<FacebookWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.facebook.com"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facebook"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

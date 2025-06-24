import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.

  runApp(MaterialApp(home: WinWebViewExample()));
}

class WinWebViewExample extends StatefulWidget {
  @override
  _WinWebViewExampleState createState() => _WinWebViewExampleState();
}

class _WinWebViewExampleState extends State<WinWebViewExample> {
  late final WebviewController _controller;
  bool _isReady = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebviewController();

    _controller.initialize().then((_) {
      setState(() => _isReady = true);
      _controller.url.listen((_) => setState(() {}));
      _controller.loadingState.listen((event) {
        print(event);
        setState(() => _isLoading = event == LoadingState.loading);
      });
      _controller.loadUrl('https://miot.pcm-life.com');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        if (_isLoading) const LinearProgressIndicator(),
        Expanded(child: Webview(_controller)),
      ],
    );
  }
}

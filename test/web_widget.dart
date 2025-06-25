import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class WebWidget extends StatefulWidget {
  final String initialUrl;
  const WebWidget({super.key, this.initialUrl = 'https://www.google.com'});

  @override
  State<WebWidget> createState() => _WebWidgetState();
}

class _WebWidgetState extends State<WebWidget> {
  final _controller = WebviewController();
  final _urlController = TextEditingController();
  bool _isLoading = false;
  bool _isWebviewReady = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.initialUrl;
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    try {
      await WebviewController.initializeEnvironment();
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(widget.initialUrl);

      _controller.webMessage.listen((dynamic message) {
        // Handle web messages if needed
      });

      setState(() {
        _isWebviewReady = true;
      });
    } catch (e) {
      debugPrint('Error initializing webview: $e');
    }
  }

  void _loadUrl(String url) async {
    if (url.isNotEmpty && _isWebviewReady) {
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }
      await _controller.loadUrl(url);
    }
  }

  void _goBack() async {
    if (_isWebviewReady) {
      await _controller.goBack();
    }
  }

  void _goForward() async {
    if (_isWebviewReady) {
      await _controller.goForward();
    }
  }

  void _reload() async {
    if (_isWebviewReady) {
      await _controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Browser'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: Column(
        children: [
          // URL Bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _goForward,
                ),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _loadUrl,
                  ),
                ),
              ],
            ),
          ),
          // WebView
          Expanded(
            child: _isWebviewReady
                ? Webview(_controller)
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _urlController.dispose();
    super.dispose();
  }
}

// Example usage for Windows
class WebViewExample extends StatelessWidget {
  const WebViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      home: const WebWidget(initialUrl: 'https://www.google.com'),
    );
  }
}

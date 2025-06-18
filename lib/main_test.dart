import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.lightGreen,
          background: Colors.green.shade50,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _labelText = 'Hello, Flutter!';
  List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  // Settings controllers
  final TextEditingController _homepageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authPasswordController = TextEditingController();
  bool _isAuthenticated = false;

  // Settings values
  String _homepage = '';
  String _username = '';
  String _password = '';
  String _email = '';
  String _phone = '';
  final TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load tasks
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });

    // Load settings
    _homepage = prefs.getString('homepage') ?? '';
    _username = prefs.getString('username') ?? '';
    _password = prefs.getString('password') ?? '';
    _email = prefs.getString('email') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _phoneController.text = _phone;
    // Set controller values
    _homepageController.text = _homepage;
    _usernameController.text = _username;
    _passwordController.text = _password;
    _emailController.text = _email;
    _phoneController.text = _phone;
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
  }

  Future<void> _saveSettings() async {
    if (!_isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please authenticate first')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _homepage = _homepageController.text;
      _username = _usernameController.text;
      _password = _passwordController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
    });

    // Save settings add setting for phone number
    await prefs.setString('homepage', _homepage);
    await prefs.setString('username', _username);
    await prefs.setString('password', _password);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  void _changeText() {
    setState(() {
      _labelText = '<b>You clicked the button!</b>';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
      _saveTasks(); // Save tasks after adding
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks(); // Save tasks after removing
  }

  void _editTask(int index) {
    final TextEditingController editController = TextEditingController(
      text: _tasks[index],
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: 'Edit your task',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.isNotEmpty) {
                setState(() {
                  _tasks[index] = editController.text;
                });
                _saveTasks();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _authenticate() {
    if (_authPasswordController.text == '1234') {
      setState(() {
        _isAuthenticated = true;
        _authPasswordController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication successful')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid password')));
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Html(
            data: _labelText,
            style: {
              "body": Style(
                fontSize: FontSize(24),
                textAlign: TextAlign.center,
              ),
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _changeText, child: const Text('Click me')),
        ],
      ),
    );
  }

  Widget _buildTasksPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a new task',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _addTask, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_tasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isAuthenticated) ...[
            const Text(
              'Authentication Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _authPasswordController,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate'),
            ),
          ] else ...[
            const Text(
              'Application Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _homepageController,
              decoration: const InputDecoration(
                labelText: 'Homepage URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Example')),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildHomePage(), _buildTasksPage(), _buildSettingsPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _homepageController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _authPasswordController.dispose();
    super.dispose();
  }
}

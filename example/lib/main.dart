import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sber_id/sber_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SBerId.instance.initialize(
    SBerIdConfig(
      clientId: 'your-client-id',
      redirectUri: 'yourapp://auth',
      partnerName: 'Your App Name',
    ),
  );



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Ready';
  bool _isInstalled = false;
  SBerIdAuthResponse? _authResult;

  @override
  void initState() {
    super.initState();
    _checkSberIdInstallation();
  }

  Future<void> _checkSberIdInstallation() async {
    try {
      final isInstalled = await SBerId.instance.isSBerIdInstalled();
      setState(() {
        _isInstalled = isInstalled;
        if (isInstalled) {
          _status = 'Sber ID app installed - Native authentication available';
        } else {
          _status = 'Sber ID app not installed - Web authentication available';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _loginWithSBerId() async {
    setState(() {
      _status = 'Logging in...';
    });

    try {
      final result = await SBerId.instance.login();
      setState(() {
        _authResult = result;
        if (result?.isSuccess == true) {
          _status = 'Login successful!';
        } else {
          _status = 'Login failed: ${result?.error}';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Login error: $e';
      });
    }
  }

  Future<void> _logout() async {
    try {
      await SBerId.instance.logout();
      setState(() {
        _authResult = null;
        _status = 'Logout successful';
      });
    } catch (e) {
      setState(() {
        _status = 'Logout error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sber ID Example'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        _isInstalled ? Icons.check_circle : Icons.info,
                        size: 48,
                        color: _isInstalled ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _status,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loginWithSBerId,
                icon: Icon(_isInstalled ? Icons.login : Icons.web),
                label: Text(_isInstalled ? 'Login with Sber ID App' : 'Login via Web'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _authResult != null ? _logout : null,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _checkSberIdInstallation,
                child: const Text('Check Again'),
              ),
              if (_authResult != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Authentication Result:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Success: ${_authResult!.isSuccess}'),
                        if (_authResult!.authCode != null)
                          Text('Auth Code: ${_authResult!.authCode}'),
                        if (_authResult!.state != null)
                          Text('State: ${_authResult!.state}'),
                        if (_authResult!.error != null)
                          Text('Error: ${_authResult!.error}'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

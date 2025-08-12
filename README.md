# Sber ID Flutter Plugin

Flutter plugin for Sber ID authentication on iOS platform.

## Features

- ✅ Sber ID authentication (iOS)
- ✅ Check if Sber ID app is installed
- ✅ Web and native app authentication flows
- 🚧 Android support (coming soon)

## Platform Support

| Platform | Support | Min Version |
|----------|---------|-------------|
| iOS      | ✅      | 15.0+       |
| Android  | 🚧      | Coming soon |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  sber_id: ^0.0.1
```

## iOS Setup

### 1. Minimum iOS Version
Ensure your iOS deployment target is 15.0+ in `ios/Podfile`:

```ruby
platform :ios, '15.0'
```

### 2. Add URL Scheme to Info.plist

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.yourapp.auth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>yourapp</string> <!-- Replace with your scheme -->
        </array>
    </dict>
</array>
```

### 3. Add LSApplicationQueriesSchemes

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sberbankidexternallogin</string>
    <string>sbolidexternallogin</string>
    <string>btripsexpenses</string>
    <string>ios-app-smartonline</string>
    <string>sberid</string>
    <string>sberbankid</string>
</array>
```

### 4. Add NSAppTransportSecurity

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>id.sber.ru</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Usage

```dart
import 'package:sber_id/sber_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize
  await SBerId.instance.initialize(
    SBerIdConfig(
      clientId: 'your-sber-id-client-id',     // From Sber ID developer portal
      redirectUri: 'yourapp://auth',          // Your app's custom URL scheme
      partnerName: 'Your Company Name',       // Your company/app name
      isProduction: false,                    // true for production
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SberIdExample(),
    );
  }
}

class SberIdExample extends StatefulWidget {
  @override
  _SberIdExampleState createState() => _SberIdExampleState();
}

class _SberIdExampleState extends State<SberIdExample> {
  
  Future<void> _checkInstallation() async {
    final isInstalled = await SBerId.instance.isSBerIdInstalled();
    print('Sber ID app installed: $isInstalled');
  }

  Future<void> _login() async {
    final result = await SBerId.instance.login();
    if (result?.isSuccess == true) {
      print('Login successful!');
      print('Auth code: ${result?.authCode}');
      print('State: ${result?.state}');
    } else {
      print('Login failed: ${result?.error}');
    }
  }

  Future<void> _logout() async {
    await SBerId.instance.logout();
    print('Logged out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sber ID Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _checkInstallation,
            child: Text('Check Sber ID Installation'),
          ),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login with Sber ID'),
          ),
          ElevatedButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
```

## Configuration

Replace the placeholder values with your actual Sber ID credentials:

- **clientId**: Your client ID from Sber ID developer portal
- **redirectUri**: Your app's registered redirect URI (must match URL scheme)
- **partnerName**: Your company or application name
- **isProduction**: Set to `true` for production environment

## Requirements

- iOS 15.0+
- Flutter 3.3.0+
- Dart 3.0.0+
- Xcode 15.0+

## License

MIT License

## Support

For issues and feature requests, please visit our [GitHub repository](https://github.com/your-username/sber_id).
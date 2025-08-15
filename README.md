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
| iOS      | ✅      | 14.0+       |
| Android  | 🚧      | Coming soon |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  sber_id: ^0.0.1+1
```

## iOS Setup

### 1. Minimum iOS Version
Ensure your iOS deployment target is 14.0+ in `ios/Podfile`:

```ruby
platform :ios, '14.0'
```

### 2. Configure URL Scheme

#### Step 2.1: Choose your URL scheme
Your `redirectUri` should follow this format: `yourapp://auth`

**Examples:**
- App name "MyStore" → `mystore://auth`
- App name "ShopApp" → `shopapp://auth`

#### Step 2.2: Add URL Scheme to Info.plist

Replace `yourapp` with your chosen scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.example.app</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>yourapp</string> <!-- Replace with your scheme (e.g., mystore, mango) -->
        </array>
    </dict>
</array>
```

**For example for Mango app:**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.mango.app</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>mango</string>
        </array>
    </dict>
</array>
```

### 3. Register redirectUri with Sber ID

⚠️ **Important:** You must register your `redirectUri` with Sber ID:

Contact Sber ID support (`support@ecom.sberbank.ru`) to register your `clientId` and `redirectUri` before using in production.

### 4. Add LSApplicationQueriesSchemes

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

### 5. Add NSAppTransportSecurity

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

  // Initialize with your credentials
  await SBerId.instance.initialize(
    SBerIdConfig(
      clientId: 'your-client-id',           // From Sber ID developer portal
      redirectUri: 'yourapp://auth',        // Must match Info.plist URL scheme
      partnerName: 'Your App Name',         // Your app name
    ),
  );

  runApp(MyApp());
}

// Rest of the example code...
```

## Configuration

### Required Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `clientId` | Your client ID from Sber ID developer portal | `'abc123-def456-ghi789'` |
| `redirectUri` | Your app's custom URL scheme (must be registered with Sber ID) | `'myapp://auth'` |
| `partnerName` | Your company or application name | `'My Company'` |

### URL Scheme Matching

Make sure your configuration matches:

**In your Dart code:**
```dart
redirectUri: 'mango://auth'
```

**In Info.plist:**
```xml
<string>mango</string>  <!-- Same scheme name -->
```

## Troubleshooting

### Common Issues

1. **"Invalid redirect URI" error**
    - Ensure `redirectUri` is registered with Sber ID
    - Check URL scheme matches Info.plist exactly

2. **App doesn't open after authentication**
    - Verify URL scheme in Info.plist
    - Check `CFBundleURLSchemes` array

3. **"Sber ID app not found" error**
    - Add all required schemes to `LSApplicationQueriesSchemes`


## License

MIT License

## Support

For issues and feature requests, please visit our [GitHub repository](https://github.com/nurullohabduvohidov/sber_id).


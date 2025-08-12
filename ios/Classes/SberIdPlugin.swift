import Flutter
import UIKit
import SIDSDK

@objc(SberIdPlugin)
public class SberIdPlugin: NSObject, FlutterPlugin {
    private var flutterAuthResult: FlutterResult?
    private var codeVerifier: String?
    private var config: [String: Any]?

    @objc public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sber_id_auth", binaryMessenger: registrar.messenger())
        let instance = SberIdPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        registrar.addApplicationDelegate(instance)
    }
    @objc public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(call: call, result: result)
        case "startSberIDAuth":
            startSberIDAuth(result: result)
        case "isSberIdInstalled":
            checkSberIdInstalled(result: result)
        case "logout":
            logout(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let config = call.arguments as? [String: Any],
              let clientId = config["clientId"] as? String,
              let partnerName = config["partnerName"] as? String else {
            result(FlutterError(code: "INVALID_CONFIG", message: "Invalid configuration", details: nil))
            return
        }

        self.config = config

        SID.initializer.initialize()

        SID.settings.applyMainPreferences(
            clientID: clientId,
            userID: nil,
            partnerName: partnerName,
            partnerProfileUrl: nil,
            stand: .prom
        )

        result(nil)
    }

    private func startSberIDAuth(result: @escaping FlutterResult) {
        guard let config = self.config,
              let redirectUri = config["redirectUri"] as? String else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Plugin not initialized", details: nil))
            return
        }

        self.codeVerifier = SIDUtils.createVerifier()
        let codeChallenge = SIDUtils.createChallenge(self.codeVerifier!)
        let codeChallengeMethod = SIDAuthRequest.challengeMethod
        let randomState = UUID().uuidString
        let randomNonce = UUID().uuidString

        let scopes = (config["scopes"] as? [String])?.joined(separator: " ") ?? "openid name email"

        let request = SIDAuthRequest(
            scope: scopes,
            state: randomState,
            nonce: randomNonce,
            redirectUri: redirectUri,
            codeChallenge: codeChallenge,
            codeChallengeMethod: codeChallengeMethod
        )

        self.flutterAuthResult = result

        var viewController: UIViewController?

        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                viewController = windowScene.windows.first?.rootViewController
            }
        } else {
            viewController = UIApplication.shared.windows.first?.rootViewController
        }

        guard let vc = viewController else {
            result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "View controller not found", details: nil))
            return
        }

        SID.login.auth(request: request, viewController: vc)
    }

    private func checkSberIdInstalled(result: @escaping FlutterResult) {
        let sberSchemes = ["sberbankidexternallogin://", "sbolidexternallogin://"]

        for scheme in sberSchemes {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                result(true)
                return
            }
        }
        result(false)
    }

    private func logout(result: @escaping FlutterResult) {
        result(nil)
    }
}

extension SberIdPlugin {
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("🔥 Plugin openURL Triggered!")
        print("🌐 URL received: \(url.absoluteString)")

        guard let config = self.config,
              let redirectUri = config["redirectUri"] as? String,
              let redirectURL = URL(string: redirectUri) else {
            print("❌ Invalid redirect config!")
            return false
        }

        if url.scheme == redirectURL.scheme && url.host == redirectURL.host {
            print("✅ Plugin Redirect URL is valid!")
            print("Plugin URLmiz \(url)")

            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems {
                print("📄 Plugin Query Parameters:")
                for item in queryItems {
                    print("\(item.name): \(item.value ?? "nil")")
                }
            }

            SID.login.getResponseFrom(url) { response in
                DispatchQueue.main.async {
                    if response.isSuccess {
                        let authCode = response.authCode ?? ""
                        let state = response.state ?? ""
                        let nonce = response.nonce
                        if !authCode.isEmpty {
                            let resultData: [String: Any] = [
                                "isSuccess": true,
                                "authCode": authCode,
                                "state": state,
                                "nonce": nonce ?? NSNull(),
                                "codeVerifier": self.codeVerifier ?? NSNull(),
                            ]
                            self.flutterAuthResult?(resultData)
                            self.flutterAuthResult = nil
                        } else {
                            self.flutterAuthResult?(
                                FlutterError(
                                    code: "AUTH_CODE_MISSING",
                                    message: "No authorization code received",
                                    details: nil
                                ))
                            self.flutterAuthResult = nil
                        }
                    } else {
                        print("❌ Plugin SberID Auth Failed: \(response.error ?? "Unknown error")")
                        self.flutterAuthResult?(
                            FlutterError(
                                code: "AUTH_ERROR",
                                message: response.error ?? "Internal error",
                                details: nil
                            ))
                        self.flutterAuthResult = nil
                    }
                }
            }
            return true
        }
        print("❌ Plugin Invalid Redirect URL!")
        return false
    }
}
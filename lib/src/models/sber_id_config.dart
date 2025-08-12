class SBerIdConfig {
  final String clientId;
  final String redirectUri;
  final String partnerName;
  final bool isProduction;
  final List<String> scopes;

  const SBerIdConfig({
    required this.clientId,
    required this.redirectUri,
    required this.partnerName,
    this.isProduction = false,
    this.scopes = const ['openid', 'name', 'email'],
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'redirectUri': redirectUri,
      'partnerName': partnerName,
      'isProduction': isProduction,
      'scopes': scopes,
    };
  }
}
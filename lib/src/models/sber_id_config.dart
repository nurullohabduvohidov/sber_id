class SBerIdConfig {
  final String clientId;
  final String redirectUri;
  final String partnerName;
  final List<String> scopes;

  const SBerIdConfig({
    required this.clientId,
    required this.redirectUri,
    required this.partnerName,
    this.scopes = const ['openid', 'name', 'email'],
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'redirectUri': redirectUri,
      'partnerName': partnerName,
      'scopes': scopes,
    };
  }
}
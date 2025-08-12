class SBerIdAuthResponse {
  final bool isSuccess;
  final String? authCode;
  final String? state;
  final String? nonce;
  final String? codeVerifier;
  final String? error;

  SBerIdAuthResponse({
    required this.isSuccess,
    this.authCode,
    this.state,
    this.nonce,
    this.codeVerifier,
    this.error,
  });

  factory SBerIdAuthResponse.fromMap(Map<String, dynamic> map) {
    return SBerIdAuthResponse(
      isSuccess: map['isSuccess'] ?? false,
      authCode: map['authCode'],
      state: map['state'],
      nonce: map['nonce'],
      codeVerifier: map['codeVerifier'],
      error: map['error'],
    );
  }

  factory SBerIdAuthResponse.error(String error) {
    return SBerIdAuthResponse(
      isSuccess: false,
      error: error,
    );
  }

  @override
  String toString() {
    return 'SBerIdAuthResponse(isSuccess: $isSuccess, authCode: $authCode, error: $error)';
  }
}
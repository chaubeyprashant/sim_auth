/// Base exception class
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// Cache exception
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Permission exception
class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);
}

/// No SIM card exception
class NoSimCardException implements Exception {
  final String message;
  const NoSimCardException(this.message);
}




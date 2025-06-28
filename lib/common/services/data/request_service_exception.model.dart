sealed class RequestServiceException implements Exception {
  const RequestServiceException({
    this.message = 'RequestService: exception',
    this.stackTrace,
  });

  final String? message;
  final StackTrace? stackTrace;
}

final class RequestServiceConnectionException extends RequestServiceException {
  const RequestServiceConnectionException({
    super.message = 'RequestService: connection exception',
    super.stackTrace,
  });
}

final class RequestServiceCertificateException extends RequestServiceException {
  const RequestServiceCertificateException({
    super.message = 'RequestService: certificate exception',
    super.stackTrace,
  });
}

final class RequestServiceInvalidResponseException
    extends RequestServiceException {
  const RequestServiceInvalidResponseException({
    super.message = 'RequestService: invalid response exception',
    super.stackTrace,
  });
}

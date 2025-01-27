sealed class ApiResponse<T> {
  final String message;
  final T? data;

  const ApiResponse({
    required this.message,
    this.data,
  });
}

class ApiSuccess<T> extends ApiResponse<T> {
  const ApiSuccess({
    required super.message,
    required T super.data,
  });
}

class ApiError<T> extends ApiResponse<T> {
  final String error;

  const ApiError({
    required super.message,
    this.error = '',
  });
}

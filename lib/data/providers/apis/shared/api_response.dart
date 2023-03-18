class ApiResponse<T> {
  final T? data;
  final Exception? exception;

  ApiResponse({this.data, this.exception});

  isSuccessFull() {
    return exception == null;
  }
}
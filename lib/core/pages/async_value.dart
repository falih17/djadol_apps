import 'package:flutter/material.dart';

import 'error_page.dart';

class ZPageFuture<T> extends StatelessWidget {
  const ZPageFuture({
    super.key,
    required this.future,
    this.loading,
    this.success,
    this.failure,
  });
  final Future<AsyncValue<T>> future;
  final Widget Function()? loading;
  final Widget Function(T value)? success;
  final Widget Function(Object error)? failure;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AsyncValue<T>>(
      key: key,
      future: future,
      initialData: AsyncValue<T>.loading(),
      builder: (context, snapshot) => snapshot.requireData.when(
        loading: () => Center(
          child: loading?.call() ?? const CircularProgressIndicator(),
        ),
        success: (value) => success?.call(value) ?? const SizedBox(),
        failure: (error) => failure?.call(error) ?? const ErrorPage(),
      ),
    );
  }
}

sealed class AsyncValue<T> {
  factory AsyncValue.loading() = _Loading;
  factory AsyncValue.success(T value) = _Success;
  factory AsyncValue.failure(Object error) = _Failure;
  const AsyncValue._();

  Widget when({
    required Widget Function() loading,
    required Widget Function(T value) success,
    required Widget Function(Object error) failure,
  }) =>
      switch (this) {
        _Loading() => loading(),
        _Success(:final value) => success(value),
        _Failure(error: final error) => failure(error),
      };
}

final class _Loading<T> extends AsyncValue<T> {
  const _Loading() : super._();
}

final class _Success<T> extends AsyncValue<T> {
  const _Success(this.value) : super._();
  final T value;
}

final class _Failure<T> extends AsyncValue<T> {
  const _Failure(this.error) : super._();
  final Object error;
}

import 'package:equatable/equatable.dart';

/// Generic domain wrapper for paginated collections.
class PaginatedListEntity<T> extends Equatable {
  final int count;
  final List<T> data;

  const PaginatedListEntity({required this.count, required this.data});

  @override
  List<Object?> get props => [count, data];
}

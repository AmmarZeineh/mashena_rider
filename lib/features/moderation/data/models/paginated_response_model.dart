import 'package:mashena_rider/features/moderation/domain/entities/paginated_list_entity.dart';

/// Generic model for backend responses shaped like `{ "count": int, "data": List }`.
class PaginatedResponseModel<T> {
  final int count;
  final List<T> data;

  const PaginatedResponseModel({required this.count, required this.data});

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final countVal = json['count'];
    final count = countVal is int
        ? countVal
        : (int.tryParse(countVal?.toString() ?? '0') ?? 0);

    final rawList = json['data'] as List<dynamic>? ?? [];
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map(fromJsonT)
        .toList();

    return PaginatedResponseModel(count: count, data: items);
  }

  PaginatedListEntity<E> toEntity<E>(E Function(T) mapper) {
    return PaginatedListEntity<E>(
      count: count,
      data: data.map(mapper).toList(),
    );
  }
}

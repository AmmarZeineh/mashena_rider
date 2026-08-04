int readInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double readDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool readBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  if (value is num) return value != 0;
  return false;
}

String? readImageUrl(Object? value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();

  if (value is Map) {
    for (final key in const ['url', 'imageUrl', 'path', 'src']) {
      final nestedValue = value[key];
      if (nestedValue is String && nestedValue.trim().isNotEmpty) {
        return nestedValue.trim();
      }
    }
  }

  return null;
}

String readStringOrEmpty(Object? value) => (value as String?)?.trim() ?? '';

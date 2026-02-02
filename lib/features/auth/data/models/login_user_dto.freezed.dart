// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginUserDto _$LoginUserDtoFromJson(Map<String, dynamic> json) {
  return _LoginUserDto.fromJson(json);
}

/// @nodoc
mixin _$LoginUserDto {
  int get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this LoginUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginUserDtoCopyWith<LoginUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserDtoCopyWith<$Res> {
  factory $LoginUserDtoCopyWith(
    LoginUserDto value,
    $Res Function(LoginUserDto) then,
  ) = _$LoginUserDtoCopyWithImpl<$Res, LoginUserDto>;
  @useResult
  $Res call({int id, String fullName, String email, String phoneNumber});
}

/// @nodoc
class _$LoginUserDtoCopyWithImpl<$Res, $Val extends LoginUserDto>
    implements $LoginUserDtoCopyWith<$Res> {
  _$LoginUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginUserDtoImplCopyWith<$Res>
    implements $LoginUserDtoCopyWith<$Res> {
  factory _$$LoginUserDtoImplCopyWith(
    _$LoginUserDtoImpl value,
    $Res Function(_$LoginUserDtoImpl) then,
  ) = __$$LoginUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String fullName, String email, String phoneNumber});
}

/// @nodoc
class __$$LoginUserDtoImplCopyWithImpl<$Res>
    extends _$LoginUserDtoCopyWithImpl<$Res, _$LoginUserDtoImpl>
    implements _$$LoginUserDtoImplCopyWith<$Res> {
  __$$LoginUserDtoImplCopyWithImpl(
    _$LoginUserDtoImpl _value,
    $Res Function(_$LoginUserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
  }) {
    return _then(
      _$LoginUserDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginUserDtoImpl implements _LoginUserDto {
  const _$LoginUserDtoImpl({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory _$LoginUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginUserDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'LoginUserDto(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fullName, email, phoneNumber);

  /// Create a copy of LoginUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserDtoImplCopyWith<_$LoginUserDtoImpl> get copyWith =>
      __$$LoginUserDtoImplCopyWithImpl<_$LoginUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginUserDtoImplToJson(this);
  }
}

abstract class _LoginUserDto implements LoginUserDto {
  const factory _LoginUserDto({
    required final int id,
    required final String fullName,
    required final String email,
    required final String phoneNumber,
  }) = _$LoginUserDtoImpl;

  factory _LoginUserDto.fromJson(Map<String, dynamic> json) =
      _$LoginUserDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get fullName;
  @override
  String get email;
  @override
  String get phoneNumber;

  /// Create a copy of LoginUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginUserDtoImplCopyWith<_$LoginUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

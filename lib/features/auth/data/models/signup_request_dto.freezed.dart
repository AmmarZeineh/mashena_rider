// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SignupRequestDto _$SignupRequestDtoFromJson(Map<String, dynamic> json) {
  return _SignupRequestDto.fromJson(json);
}

/// @nodoc
mixin _$SignupRequestDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this SignupRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignupRequestDtoCopyWith<SignupRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupRequestDtoCopyWith<$Res> {
  factory $SignupRequestDtoCopyWith(
    SignupRequestDto value,
    $Res Function(SignupRequestDto) then,
  ) = _$SignupRequestDtoCopyWithImpl<$Res, SignupRequestDto>;
  @useResult
  $Res call({
    String email,
    String password,
    String fullName,
    String phoneNumber,
  });
}

/// @nodoc
class _$SignupRequestDtoCopyWithImpl<$Res, $Val extends SignupRequestDto>
    implements $SignupRequestDtoCopyWith<$Res> {
  _$SignupRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SignupRequestDtoImplCopyWith<$Res>
    implements $SignupRequestDtoCopyWith<$Res> {
  factory _$$SignupRequestDtoImplCopyWith(
    _$SignupRequestDtoImpl value,
    $Res Function(_$SignupRequestDtoImpl) then,
  ) = __$$SignupRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    String password,
    String fullName,
    String phoneNumber,
  });
}

/// @nodoc
class __$$SignupRequestDtoImplCopyWithImpl<$Res>
    extends _$SignupRequestDtoCopyWithImpl<$Res, _$SignupRequestDtoImpl>
    implements _$$SignupRequestDtoImplCopyWith<$Res> {
  __$$SignupRequestDtoImplCopyWithImpl(
    _$SignupRequestDtoImpl _value,
    $Res Function(_$SignupRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = null,
  }) {
    return _then(
      _$SignupRequestDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
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
class _$SignupRequestDtoImpl implements _SignupRequestDto {
  const _$SignupRequestDtoImpl({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
  });

  factory _$SignupRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignupRequestDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String fullName;
  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'SignupRequestDto(email: $email, password: $password, fullName: $fullName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupRequestDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, fullName, phoneNumber);

  /// Create a copy of SignupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupRequestDtoImplCopyWith<_$SignupRequestDtoImpl> get copyWith =>
      __$$SignupRequestDtoImplCopyWithImpl<_$SignupRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SignupRequestDtoImplToJson(this);
  }
}

abstract class _SignupRequestDto implements SignupRequestDto {
  const factory _SignupRequestDto({
    required final String email,
    required final String password,
    required final String fullName,
    required final String phoneNumber,
  }) = _$SignupRequestDtoImpl;

  factory _SignupRequestDto.fromJson(Map<String, dynamic> json) =
      _$SignupRequestDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String get fullName;
  @override
  String get phoneNumber;

  /// Create a copy of SignupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignupRequestDtoImplCopyWith<_$SignupRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

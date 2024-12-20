import 'package:freezed_annotation/freezed_annotation.dart';

part 'signature.freezed.dart';
part 'signature.g.dart';

@freezed
class Signature with _$Signature {
  const factory Signature({
    required String method,
    required String value,
  }) = _Signature;

  factory Signature.fromJson(Map<String, dynamic> json) =>
      _$SignatureFromJson(json);
}

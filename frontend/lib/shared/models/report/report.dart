import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

enum ReportReason {
  spam,
  inappropriate,
  other,
}

@freezed
abstract class Report with _$Report {
  const factory Report({
    required String postId,
    required String reporterId,
    required ReportReason reason,
    String? description,
  }) = _Report;

  factory Report.fromJson(Map<String, Object?> json) => _$ReportFromJson(json);
}

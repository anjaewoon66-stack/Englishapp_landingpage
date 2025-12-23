import 'package:json_annotation/json_annotation.dart';

part 'study_session.g.dart';

@JsonSerializable()
class StudySession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String activityType;
  final int itemsStudied;

  const StudySession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.activityType,
    required this.itemsStudied,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) =>
      _$StudySessionFromJson(json);

  Map<String, dynamic> toJson() => _$StudySessionToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'duration_minutes': durationMinutes,
      'activity_type': activityType,
      'items_studied': itemsStudied,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] as String,
      startTime:
          DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int),
      durationMinutes: map['duration_minutes'] as int,
      activityType: map['activity_type'] as String,
      itemsStudied: map['items_studied'] as int,
    );
  }
}

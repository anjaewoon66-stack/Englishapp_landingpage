// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudySession _$StudySessionFromJson(Map<String, dynamic> json) => StudySession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      activityType: json['activityType'] as String,
      itemsStudied: (json['itemsStudied'] as num).toInt(),
    );

Map<String, dynamic> _$StudySessionToJson(StudySession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'activityType': instance.activityType,
      'itemsStudied': instance.itemsStudied,
    };

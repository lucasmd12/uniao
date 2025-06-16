import 'dart:convert';

class Clan {
  final String id;
  final String name;
  final String tag;
  final String leaderId;
  final String? description;
  final List<String>? members; // IDs, não objetos
  final List<String>? allies;
  final List<String>? enemies;
  final List<String>? textChannels;
  final List<String>? voiceChannels;
  final List<String>? customRoles;
  final Map<String, String>? memberRoles; // userId -> role
  final String? rules;
  final DateTime? createdAt;

  Clan({
    required this.id,
    required this.name,
    required this.tag,
    required this.leaderId,
    this.description,
    this.members,
    this.allies,
    this.enemies,
    this.textChannels,
    this.voiceChannels,
    this.customRoles,
    this.memberRoles,
    this.rules,
    this.createdAt,
  });

  factory Clan.fromMap(Map<String, dynamic> map) {
    return Clan(
      id: map["_id"] ?? "",
      name: map["name"] ?? "",
      tag: map["tag"] ?? "",
      leaderId: map["leaderId"] ?? "",
      description: map["description"],
      members: List<String>.from(map["members"] ?? []),
      allies: List<String>.from(map["allies"] ?? []),
      enemies: List<String>.from(map["enemies"] ?? []),
      textChannels: List<String>.from(map["textChannels"] ?? []),
      voiceChannels: List<String>.from(map["voiceChannels"] ?? []),
      customRoles: List<String>.from(map["customRoles"] ?? []),
      memberRoles: map["memberRoles"] != null
          ? Map<String, String>.from(map["memberRoles"])
          : null,
      rules: map["rules"],
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "tag": tag,
      "leaderId": leaderId,
      if (description != null) "description": description,
      if (members != null) "members": members,
      if (allies != null) "allies": allies,
      if (enemies != null) "enemies": enemies,
      if (textChannels != null) "textChannels": textChannels,
      if (voiceChannels != null) "voiceChannels": voiceChannels,
      if (customRoles != null) "customRoles": customRoles,
      if (memberRoles != null) "memberRoles": memberRoles,
      if (rules != null) "rules": rules,
      if (createdAt != null) "createdAt": createdAt!.toIso8601String(),
    };
  }

  factory Clan.fromJson(String source) => Clan.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}


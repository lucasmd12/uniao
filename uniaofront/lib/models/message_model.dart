import 'dart:convert';

class Message {
  final String id;
  final String clanId; // ou federationId, dependendo do contexto
  final String senderId;
  final String message;
  final DateTime createdAt;
  final String? fileUrl; // Adicionado para suportar imagens/arquivos
  final String? type; // 'text', 'image', 'audio', etc.

  Message({
    required this.id,
    required this.clanId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.fileUrl,
    this.type = 'text',
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? '',
      clanId: map['clan'] ?? map['federation'] ?? '',
      senderId: map['sender'] ?? '',
      message: map['message'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      fileUrl: map['fileUrl'],
      type: map['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'clan': clanId,
      'sender': senderId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (type != null) 'type': type,
    };
  }

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}


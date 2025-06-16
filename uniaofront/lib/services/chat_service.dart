import 'package:flutter/foundation.dart';
import 'package:lucasbeatsfederacao/models/message_model.dart';
import 'package:lucasbeatsfederacao/services/api_service.dart';
import 'package:lucasbeatsfederacao/utils/logger.dart';

class ChatService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Stores messages per chat entity (clanId or federationId)
  final Map<String, List<Message>> _messages = {};

  // Send a message to a specific chat (clan or federation)
  Future<void> sendMessage({
    required String entityId,
    required String message,
    required String chatType, // 'clan' or 'federation'
    String? fileUrl,
    String? messageType = 'text',
  }) async {
    Logger.info("[ChatService] Sending message to $chatType $entityId: $message");

    String endpoint;
    if (chatType == 'clan') {
      endpoint = "/api/clan-chat/$entityId/message";
    } else if (chatType == 'federation') {
      endpoint = "/api/federation-chat/$entityId/message";
    } else {
      throw Exception("Invalid chat type: $chatType");
    }

    try {
      final response = await _apiService.post(
        endpoint,
        {
          "message": message,
          if (fileUrl != null) "fileUrl": fileUrl,
          if (messageType != null) "type": messageType,
        },
        requireAuth: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        final newMessage = Message.fromMap(response);
        if (_messages[entityId] == null) {
          _messages[entityId] = [];
        }
        _messages[entityId]!.add(newMessage);
        notifyListeners();
        Logger.info("Message sent successfully: ${newMessage.message}");
      } else {
        throw Exception("Failed to send message: Invalid response");
      }
    } catch (e) {
      Logger.error("Error sending message: ${e.toString()}");
      rethrow;
    }
  }

  // Get messages for a specific chat (clan or federation)
  Future<List<Message>> getMessages({
    required String entityId,
    required String chatType, // 'clan' or 'federation'
  }) async {
    Logger.info("[ChatService] Getting messages for $chatType $entityId");

    String endpoint;
    if (chatType == 'clan') {
      endpoint = "/api/clan-chat/$entityId/messages";
    } else if (chatType == 'federation') {
      endpoint = "/api/federation-chat/$entityId/messages";
    } else {
      throw Exception("Invalid chat type: $chatType");
    }

    try {
      final response = await _apiService.get(endpoint, requireAuth: true);

      if (response != null && response is List) {
        final fetchedMessages = response.map((json) => Message.fromMap(json)).toList();
        _messages[entityId] = fetchedMessages;
        notifyListeners();
        Logger.info("Messages fetched successfully for $chatType $entityId");
        return fetchedMessages;
      } else {
        throw Exception("Failed to get messages: Invalid response");
      }
    } catch (e) {
      Logger.error("Error getting messages: ${e.toString()}");
      rethrow;
    }
  }

  // Get cached messages for a specific channel
  List<Message> getCachedMessagesForEntity(String entityId) {
    return _messages[entityId] ?? [];
  }

  @override
  void dispose() {
    Logger.info("Disposing ChatService.");
    super.dispose();
  }
}


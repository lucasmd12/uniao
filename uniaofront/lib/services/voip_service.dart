import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lucasbeatsfederacao/models/call_model.dart';
import 'package:lucasbeatsfederacao/utils/logger.dart';

class VoipService with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Call? _currentCall;
  DateTime? _callStartTime;
  Duration _callDuration = Duration.zero;
  Timer? _durationTimer;

  Call? get currentCall => _currentCall;
  Duration get callDuration => _callDuration;

  Future<bool> initiateCall(String calleeId, String calleeUsername) async {
    Logger.info('Initiating call to $calleeUsername ($calleeId)...');
    try {
      // Create a pending call object
      _currentCall = Call(
        id: 'temp_call_id_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID
        callerId: 'current_user_id_placeholder', // TODO: Replace with actual current user ID
        receiverId: calleeId,
        type: CallType.audio, // Default to audio, can be passed as parameter
 status: CallStatus.pending,
        startTime: DateTime.now(),
      );
      notifyListeners();

      final response = await _apiService.post(
        '/api/voip/call/initiate',
        {
          'calleeId': calleeId,
          'callType': _currentCall!.type.toString().split('.').last,
        },
        requireAuth: true,
      );

      if (response != null && response.containsKey('callId')) {
        Logger.info('Call initiated successfully with callId: ${_currentCall!.id}');
        _updateCallStatus(CallStatus.pending); // Explicitly set to pending after successful initiation
      } else {
        Logger.error('Failed to initiate call: Invalid response');
 _updateCallStatus(CallStatus.ended);
        return false;
      }
    } catch (e, s) {
      Logger.error('Error initiating call', error: e, stackTrace: s); // Changed to CallStatus.ended based on context
      // Assume failure leads to ending the call state
 _updateCallStatus(CallStatus.ended);
      return false;
    }
  }

  void receiveIncomingCall(String callId, String callerId, String callerName, CallType type) {
    Logger.info('Received incoming call from $callerName ($callerId) with callId: $callId');
    _currentCall = Call(
      id: callId,
      callerId: callerId,
      receiverId: 'current_user_id_placeholder', // TODO: Replace with actual current user ID
      type: type,
      status: CallStatus.pending,
 startTime: DateTime.now(),
    );
    notifyListeners();
  }

  Future<bool> acceptCall(String callId) async {
    Logger.info('Accepting call $callId...');
    try {
      final response = await _apiService.post(
        '/api/voip/call/accept',
        {
          'callId': callId,
        },
        requireAuth: true,
      );

      if (response != null && response.containsKey('success') && response['success'] == true) {
        _updateCallStatus(CallStatus.active);
        _startCallTimer();
        Logger.info('Call $callId accepted successfully.');
        return true;
      } else {
        Logger.error('Failed to accept call $callId: Invalid response');
 _updateCallStatus(CallStatus.ended);
        return false;
      }
    } catch (e, s) {
      Logger.error('Error accepting call $callId', error: e, stackTrace: s); // Changed to CallStatus.ended based on context
 _updateCallStatus(CallStatus.ended);
      return false;
    }
  }

  Future<bool> rejectCall(String callId) async {
    Logger.info('Rejecting call $callId...');
    try {
      final response = await _apiService.post(
        '/api/voip/call/reject',
        {
          'callId': callId,
        },
        requireAuth: true,
      );

      if (response != null && response.containsKey('success') && response['success'] == true) {
        Logger.info('Call $callId rejected successfully.');
        _updateCallStatus(CallStatus.ended);
        _resetCallData();
        return true;
      } else if (response != null && response.containsKey('error')) {
      } else {
        Logger.error('Failed to reject call $callId: Invalid response');
        return false;
      }
    } catch (e, s) {
      Logger.error('Error rejecting call $callId', error: e, stackTrace: s);
      return false;
    _resetCallData();
  }

  Future<bool> endCall(String callId) async {
    Logger.info('Ending call $callId...');
    try {
      final response = await _apiService.post(
        '/api/voip/call/end',
        {
          'callId': callId,
        },
        requireAuth: true,
      );

      if (response != null && response.containsKey('success') && response['success'] == true) {
        Logger.info('Call $callId ended successfully.');
 _updateCallStatus(CallStatus.ended);
        _resetCallData();
        return true;
      } else {
        Logger.error('Failed to end call $callId: Invalid response');
        return false;
      }
    } catch (e, s) {
      Logger.error('Error ending call $callId', error: e, stackTrace: s);
      return false;
    }
  }

  Future<List<Call>> getCallHistory() async {
    Logger.info('Fetching call history...');
    try {
      final response = await _apiService.get('/api/voip/call/history', requireAuth: true);

      if (response != null && response is List) {
        Logger.info('Call history fetched successfully: ${response.length} items.');
        return response.map((data) => Call.fromJson(data)).toList();
      } else if (response != null && response is Map<String, dynamic> && response.containsKey('calls') && response['calls'] is List) {
        Logger.info('Call history fetched successfully (nested): ${response['calls'].length} items.');
        return (response['calls'] as List).map((data) => Call.fromMap(data)).toList();
      } else {
        Logger.warning('Unexpected format for call history response: $response');
        return [];
      }
    } catch (e, s) {
      Logger.error('Error fetching call history', error: e, stackTrace: s);
      return [];
    }
  }

  void _updateCallStatus(CallStatus newStatus) {
    if (_currentCall != null && _currentCall!.status != newStatus) {
      _currentCall = _currentCall!.copyWith(status: newStatus);
      Logger.info('Call status changed to: ${newStatus.toString().split('.').last}');
      notifyListeners();
    }
  }

  void _startCallTimer() {
    Logger.info('Starting call timer.');
    _callStartTime = DateTime.now();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentCall?.status == CallStatus.active) {
        _callDuration = DateTime.now().difference(_callStartTime!);
        notifyListeners();
      } else {
        _durationTimer?.cancel();
      }
    });
  }

  void _resetCallData() {
    Logger.info('Resetting call data.');
    _currentCall = null;
    _callStartTime = null;
    _callDuration = Duration.zero;
    _durationTimer?.cancel();
    _durationTimer = null;
    notifyListeners(); // Notify to clear UI elements
  }

  String formatCallDuration() {
    final minutes = _callDuration.inMinutes;
    final seconds = _callDuration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    Logger.info('Disposing VoipService...');
    _durationTimer?.cancel();
    _durationTimer = null;
    super.dispose();
  }
}


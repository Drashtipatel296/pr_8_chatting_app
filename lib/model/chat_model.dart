import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? sender, receiver, msg;
  Timestamp? timestamp;
  String? mediaUrl;
  bool read;

  ChatModel({
    required this.sender,
    required this.receiver,
    required this.msg,
    required this.timestamp,
    required this.mediaUrl,
    required this.read,
  });

  factory ChatModel.fromMap(Map m1) {
    return ChatModel(
        sender: m1['sender'],
        receiver: m1['receiver'],
        msg: m1['msg'],
        mediaUrl: m1['mediaUrl'],
        timestamp: m1['timestamp'],
        read: m1['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap(ChatModel chat){
    return {
      'sender' : chat.sender,
      'receiver' : chat.receiver,
      'msg' : chat.msg,
      'timestamp' : chat.timestamp,
      'mediaUrl' : chat.mediaUrl,
      'read' : chat.read,
    };
  }
}
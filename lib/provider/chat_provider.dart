import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../model/chat.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  bool isLoading = false;
  bool isError = false;

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    isError = error;
    notifyListeners();
  }

  String _formattedTime() {
    return DateFormat('h:mm a').format(DateTime.now());
  }

  Future<void> sendMessage(
      String message, context, ScrollController scrollController) async {
    if (message.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    final gemini = Gemini.instance;
    chats.add(Chat(msg: message, isRequest: true, time: _formattedTime()));
    _setLoading(true);
    scrollController.jumpTo(scrollController.position.maxScrollExtent);

    try {
      final response = await gemini.text(message);
      chats.add(Chat(
          msg: response!.output.toString(),
          isRequest: false,
          time: _formattedTime()));

      Future.delayed(
        const Duration(milliseconds: 50),
        () async {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      _setError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendWithImage(String message, File img) async {
    final gemini = Gemini.instance;
    chats.add(
        Chat(msg: message, isRequest: true, img: img, time: _formattedTime()));
    _setLoading(true);


    try {
      final uintList = await img.readAsBytes();
      final response =
          await gemini.textAndImage(text: message, images: [uintList]);
      chats.add(
        Chat(
          msg: response!.output.toString(),
          isRequest: false,
          time: _formattedTime(),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      _setError(true);
    } finally {
      _setLoading(false);
    }
  }
}

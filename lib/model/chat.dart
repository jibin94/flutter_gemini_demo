import 'dart:io';

class Chat {
  final bool isRequest;
  final String msg;
  final File? img;
  final String time;
  const Chat(
      {required this.msg,
      required this.isRequest,
      this.img,
      required this.time});
}

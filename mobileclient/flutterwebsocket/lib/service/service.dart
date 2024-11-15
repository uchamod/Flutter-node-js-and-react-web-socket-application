import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final _socket =
      WebSocketChannel.connect(Uri.parse("ws://192.168.42.149:4000"));

  WebSocketChannel get socket => _socket;

  void sendMassage(String massage) {
    if (massage.isNotEmpty) {
      _socket.sink.add(massage);
    }
  }

  void dispose() {
    _socket.sink.close();
  }
}

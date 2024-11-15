import 'package:flutter/material.dart';
import 'package:flutterwebsocket/service/service.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final ChatService _chatService = ChatService();
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _massages = [];

  //lisent to the data stream  and get the data and set local list
  @override
  void initState() {
    _chatService.socket.stream.listen((data) {
      String massage =
          data is List<int> ? String.fromCharCodes(data) : data.toString();

      setState(() {
        _massages.add({"massage": massage, "isMine": false});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chatService.dispose();
    super.dispose();
  }

  void _sentMassage(String massage) {
    if (massage.isNotEmpty) {
      setState(() {
        _massages.add({"massage": massage, "isMine": true});
      });
      _chatService.sendMassage(massage);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Hello Chaties...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListView.builder(
          itemCount: _massages.length,
          itemBuilder: (context, index) {
            bool msg = _massages[index]["isMine"];
            return Align(
              alignment: msg ? Alignment.bottomRight : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: msg ? Colors.blue.shade500 : Colors.grey.shade200,
                  ),
                  child: Text(
                    _massages[index]["massage"],
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                  child: TextField(
                    cursorColor: Colors.grey.shade600,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Send Massage",
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: Colors.blue.shade500, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: Colors.blue.shade500, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    _sentMassage(_controller.text);
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    size: 32,
                    color: Colors.blue.shade500,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

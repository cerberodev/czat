import 'package:czat/twitch_service.dart';
import 'package:flutter/material.dart';

class Message {
  final String user;
  final String text;
  final String imageUrl;

  Message(this.user, this.text, this.imageUrl);
}

class ChatPage extends StatefulWidget {
  final String clientId;

  const ChatPage({
    Key key,
    @required this.clientId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    _startService();
  }

  _startService() async {
    var stream = await startTwitchService(widget.clientId);

    stream.listen((data) {
      setState(() {
        messages.insert(
          0,
          Message(
            data['name'],
            data['text'],
            data['imageUrl'],
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    stopTwitchService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Czat"),
      ),
      body: ListView.separated(
        itemCount: messages.length,
        itemBuilder: (_, int index) {
          var message = messages[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(message.imageUrl),
            ),
            title: Text(message.user),
            subtitle: Text(message.text),
          );
        },
        separatorBuilder: (_, __) {
          return Divider();
        },
      ),
    );
  }
}

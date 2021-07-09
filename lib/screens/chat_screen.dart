import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _fs = FirebaseFirestore.instance;
User currUser;

class ChatScreen extends StatefulWidget {
  static String id = "/chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String typedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fs.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.lightBlueAccent));
                  }
                  final messages = snapshot.data.docs.reversed;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final messageBubble = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                      child: ListView(
                    children: messageBubbles,
                    reverse: true,
                  ));
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        typedText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 메시지 전송 버튼 클릭 시!
                      messageTextController.clear();
                      _fs.collection("messages").add({
                        "sender": _auth.currentUser.email,
                        "text": typedText
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble({this.text, this.sender});
  final String sender; // 보낸 사람
  final String text; // 메시지

  @override
  _MessageBubbleState createState() =>
      _MessageBubbleState(text: text, sender: sender);
}

class _MessageBubbleState extends State<MessageBubble> {
  //MessageBubble({this.text, this.sender, this.myID});
  _MessageBubbleState({this.text, this.sender});
  final String sender; // 보낸 사람
  final String text; // 메시지
  CrossAxisAlignment alignMessage; // 메시지 align
  Color bubbleColor; // 버블색
  Color textColor; // 텍스트색

  @override
  void initState() {
    super.initState();
    checkA();
  }

  checkA() {
    setState(() {
      if (sender == _auth.currentUser.email) {
        alignMessage = CrossAxisAlignment.start;
        bubbleColor = Colors.blueGrey.shade100;
        textColor = Colors.black.withAlpha(160);
      } else {
        alignMessage = CrossAxisAlignment.end;
        bubbleColor = Colors.lightBlueAccent;
        textColor = Colors.white70;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkA();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(crossAxisAlignment: alignMessage, children: [
        Text(
          sender,
          style: TextStyle(color: Colors.black54, fontSize: 10.0),
        ),
        Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                text,
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            color: bubbleColor),
      ]),
    );
  }
}

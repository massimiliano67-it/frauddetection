import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fraudetection/api/statecard.dart';
import 'package:fraudetection/screen/mainscreen.dart';
import 'package:uuid/uuid.dart';
import 'package:fraudetection/widget/typesim.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.stateCard});

  final StateCard stateCard;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  bool _isSomeoneTyping = false;
  int indexCindyMessage = 0;
  final int MIN = 3;
  final int MAX = 10;
  List<types.Message> _listMessageCyndy = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  final _cindy = const types.User(
    id: '4c2307ba-3d40-442f-b1ff-b271f63904ca',
  );

  @override
  void initState() {
    print("STATECARD: " + widget.stateCard.state);
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/message.json');
    _listMessageCyndy = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    /*final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();*/
    someOneType(true);
    int randomNumber = Random().nextInt(MAX) + MIN;
    print("RANDOM NUMBER: $randomNumber");
    await Future.delayed(Duration(seconds: randomNumber));
    setState(() {
      indexCindyMessage = _listMessageCyndy.length - 1;
      _messages.insert(0, _listMessageCyndy[indexCindyMessage]);
      //_messages = _listMessageCyndy;
    });
    someOneType(false);
  }

  void someOneType(bool isTyping){
    setState(() {
      _isSomeoneTyping = isTyping;
    });
  }

  void _addMessage(types.Message message) async {
    someOneType(true);
    int randomNumber = Random().nextInt(MAX) + MIN;
    print("RANDOM NUMBER: $randomNumber");
    await Future.delayed(Duration(seconds: randomNumber));
    setState(() {
      _isSomeoneTyping = true;
      _messages.insert(0, message);
      indexCindyMessage--;
      print("INDEXCINDY: $indexCindyMessage");
      _messages.insert(0, _listMessageCyndy[indexCindyMessage]);
      if (indexCindyMessage == 5) {
        final textMessage = types.TextMessage(
          author: _cindy,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: "8/20 ELECTRONIX MARKETPLACE 302.450 CLP",
        );
        _messages.insert(0, textMessage);
        final textMessage1 = types.TextMessage(
          author: _cindy,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: "8/20 BEAUTY BARGAINZ MARKETPLACE 54.300 CLP",
        );
        _messages.insert(0, textMessage1);
      }
    });
    someOneType(false);
  }


  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Cindy"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => {
              widget.stateCard.state = "Bloqueada",
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(stateCard: widget.stateCard)),
              )
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Chat(
                messages: _messages,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: typingIndicator(
                showIndicator: _isSomeoneTyping,
              ),
            ),
          ],
        ));
  }
}

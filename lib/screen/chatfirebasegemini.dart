// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../api/statecard.dart';
import 'mainscreen.dart';

// REQUIRED if you want to run on Web
const FirebaseOptions? options = null;

class ChatScreenFirebaseGemini extends StatefulWidget {
  const ChatScreenFirebaseGemini(
      {super.key, required this.title, required this.stateCard});

  final StateCard stateCard;
  final String title;

  @override
  State<ChatScreenFirebaseGemini> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenFirebaseGemini> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading:  IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(stateCard: widget.stateCard)),
            )
          },
        ),
      ),
      body: ChatWidget(stateCard: widget.stateCard, title: ""),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.stateCard, required this.title});

  final StateCard stateCard;
  final String title;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  ChatSession? _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  String _prompt =
      "Eres un agente inteligente de nombre Cindy que me esta escribiendo para validar si reconozco tres unos cargos en mi tarjeta"
      "El dialogo lo debe iniciar tu, te presenta, me saluda (mi nombre es Massimiliano) preguntándome si un reconozco un cargo de 50.000 pesos en un comercio (puedes inventar el rubro) de hacer 15 días atrás"
      "-- ejemplo: Hola Massimiliano soy Cindy, tu asistente persona del Banco de Chile"
      " Una vez que contesto a la primera pregunta de manera negativa o positiva, tu me muestra otros dos cargos (pones nombres de fantasía). Si yo rechazo todo, tu me anula el cargo y me boquea la tarjeta y me dice me enviará una nueva en 3 5 días hábiles. Me debe pedir de confirmar la dirección que es El Remanso de Las Condes 11.110, Las Condes"
      " Cuando hace el resumen y me dice si bloque la tarjeta, debe ser especifico que anula los cargos no reconocidos y acuérdate de los cargo que reconocí"
      " Puedes aceptar preguntas para validar los comercios por ejemplo saber la dirección"
      "-- ejemplo me das la dirección del comercio?"
      " Para calcular las fechas considera que hoy estamos a 7 de octubre del 2024"
      " Al final cuando me saluda, en caso que bloqueaste la tarjeta avísame que el numero de caso asociado al bloqueo de la tarjeta de crédito es el numero (puedes inventar un numero de 6 dígitos)"
      " Si te hago pregunta afuera de este guion, debe contestar que por seguridad no está habilitada a responder a preguntas que no están relacionadas con esta conversación. Si estas habilitada a darme las direcciones de los comercios";

  @override
  void initState() {
    super.initState();

    initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-002',
        systemInstruction: Content.system(_prompt),
      );
      _functionCallModel = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-002',
        systemInstruction: Content.system(_prompt),
      );
      _chat = _model.startChat();
      _sendChatMessage("hola");
    });
  }

  Future<void> initFirebase() async {
    // ignore: avoid_redundant_argument_values
    await Firebase.initializeApp(options: options);
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(stateCard: widget.stateCard)),
              )
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, idx) {
                    var content = _generatedContent[idx];
                    return MessageWidget(
                      text: content.text,
                      image: content.image,
                      isFromUser: content.fromUser,
                    );
                  },
                  itemCount: _generatedContent.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: _textFieldFocus,
                        decoration: textFieldDecoration,
                        controller: _textController,
                        onSubmitted: _sendChatMessage,
                      ),
                    ),
                    const SizedBox.square(
                      dimension: 15,
                    ),
                    IconButton(
                      tooltip: 'tokenCount Test',
                      onPressed: !_loading
                          ? () async {
                              await _testCountToken();
                            }
                          : null,
                      icon: Icon(
                        Icons.numbers,
                        color: _loading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_loading)
                      IconButton(
                        onPressed: () async {
                          await _sendChatMessage(_textController.text);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    else
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 25,
                ),
                child: Text(
                  'Total message count: ${_chat?.history.length ?? 0}',
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      var response = await _chat?.sendMessage(
        Content.text(message),
      );
      var text = response?.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
        if(widget.stateCard.state == "Activa") {
          widget.stateCard.state = _findBlockCardWord(text);
          print("STATE :" + widget.stateCard.state);
        }
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _testCountToken() async {
    setState(() {
      _loading = true;
    });

    const prompt = 'tell a short story';
    var response = await _model.countTokens([Content.text(prompt)]);
    print(
      'token: ${response.totalTokens}, billable characters: ${response.totalBillableCharacters}',
    );

    setState(() {
      _loading = false;
    });
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

String _findBlockCardWord(String text) {
  if (text.contains('bloque')) {
    return "Bloqueada";
  } else {
    return "Activa";
  }
}

class MessageWidget extends StatelessWidget {
  final Image? image;
  final String? text;
  final bool isFromUser;

  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                if (text case final text?) MarkdownBody(data: text),
                if (image case final image?) image,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

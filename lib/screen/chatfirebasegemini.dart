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
import 'package:flutter_tts/flutter_tts.dart';

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
enum TtsState { playing, stopped, paused, continued }

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  ChatSession? _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

   final String _prompt =
      "Eres un agente inteligente de nombre Cindy de Banco de Chile que me esta escribiendo para validar si reconozco unos cargos en mi tarjeta."
      "El dialogo lo debe iniciar tu, te presenta, me saluda (mi nombre es Massimiliano) preguntándome si un reconozco un cargo de (puedes usar un valor entre 1.000.000 y 1.500.000) de pesos en un comercio (puedes inventar el rubro) de hacer 5 minutos  atrás."
      "Avisame que la sospecha que es un fraude se debe al alto monto."
      "Considera siempre que el primer cargo se realizó hace meno de 10. Los otros cargos se hicieron antes."
      "Nunca debe decir la hora en los mensajes."
      "Los montos del segundo y tercer cargos no pueden ser mayor de 100.000 pesos."
      "Una vez que contesto a la primera pregunta rechazando o reconociendo el cargo, tu me muestra otros dos cargos (pones nombres de fantasía)."
      "Si yo rechazo uno mas cargos de los tres cargos presentado, tu me anula los cargos rechazados, mantiene los cargos reconocidos y me boquea la tarjeta."
      "Si yo rechazo uno mas cargos de los tres cargos presentado, me dice me enviará la nueva tarjeta en 3 5 días hábiles. Me debe pedir de confirmar la dirección que es El Remanso de Las Condes 11.110, Las Condes"
      "Cuando hace el resumen bloqueste la tarjeta, debe ser especifico que anula los cargos no reconocidos y mantiene los cargo que reconocido."
       "Si no rechazo nigun cargos, me saluda cordialmente y confirma que mantienes los cargos."
       "Puedes aceptar preguntas para validar los comercios por ejemplo saber la dirección"
      "-- ejemplo me das la dirección del comercio?"
      "Para calcular las fechas considera que hoy estamos a 8 de octubre del 2024"
      "Al final cuando me saluda, en caso que bloqueaste la tarjeta avísame que el numero de caso asociado al bloqueo de la tarjeta de crédito es el numero (puedes inventar un numero de 6 dígitos)"
      "Si te hago pregunta afuera de este guion, debe contestar que por seguridad no está habilitada a responder a preguntas que no están relacionadas con esta conversación. Si estas habilitada a darme las direcciones de los comercios";

  //for TTS
  late FlutterTts flutterTts;
  String? language = "es-mx";
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  int? _inputLength;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;
  bool isAndroid = true;

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  dynamic initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
      _setlanguage(language!);

    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
        _loading = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        _loading = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
        _loading = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
        _loading = false;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
        _loading = true;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
        _loading = false;
      });
    });
  }

  Future<void> _speak(String textToVoice) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (textToVoice.isNotEmpty) {
      await flutterTts.speak(textToVoice);
    }
    }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future<void> _setlanguage(String language) async {
    await flutterTts.setLanguage(language);
}



  @override
  void initState() {
    super.initState();

    initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-002',
        systemInstruction: Content.system(_prompt),
      );
      _chat = _model.startChat();
      _sendChatMessage("hola");
      initTts();
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
        print("RESPONSE: " + text.toString());
        //_speak(text);
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

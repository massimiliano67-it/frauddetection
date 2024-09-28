import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';



class ChatWithGemini extends StatefulWidget {
  const ChatWithGemini({super.key, required this.title});

  final String title;

  @override
  State<ChatWithGemini> createState() => _ChatWithGeminiState();
}

class _ChatWithGeminiState extends State<ChatWithGemini> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ChatScreen(),
    );
  }
}


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
  <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;
  static const String _apiKey = "AIzaSyDeh5kukRvHG3PomSkOtVD032j7WRlJuMA";


  String _prommpt ="Eres un agente inteligente de nombre Cindy que me esta escribiendo para validar si reconozco tres unos cargos en mi tarjeta"

      "El dialogo lo debe iniciar tu, te presenta, me saluda (mi nombre es massimiliano) preguntandome si un reconozco un cargo de 50.000 pesos en un comercio (puedes inventar el rubro) de hacer 15 dias atrás"

      "-- ejemplo: Hola Massimiliano soy Cindy, tu asistente persona del Banco de Chile"

      " Una vez que no reconozco el cargo, tu me muestra otros dos cargos (pones nombres de fantasia). Si yo rechazo todo, tu me anula el cargo y me boquea la tarjeta y me dice me enviará una nueva en 3 5 dias habiles. Me debe pedir de confirmar la direccion (inventa una fiticia en Santiago de Chile, Las Condes)"

      " Durante el dialogo puedo hacerte preguntas para validar los comercios, por ejemplo saber la direccion"

      " Para calcular las fechas considera que hoy estamos a 7 de octubre del 2024"

      " Al final cuando me saluda, avisame que el numero de caso asociado al bloqueo de la tarjeta de credito es el numero (puedes inventar un numero de 6 digitos)"

      " Si te hago pregunta afuera de este guion, debe contestar que por seguridad no está habilitada a responder a preguntas que no estan relacioandas con esta conversación";

  @override
  void initState() {
    _model = GenerativeModel(
      model: 'gemini-1.5-pro-exp-0827',
      apiKey: _apiKey,
      systemInstruction: Content.system(_prommpt),
    );
    _chat = _model.startChat();


    _sendChatMessage("");
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _apiKey.isNotEmpty
                ? ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, idx) {
                final content = _generatedContent[idx];
                return MessageWidget(
                  text: content.text,
                  image: content.image,
                  isFromUser: content.fromUser,
                );
              },
              itemCount: _generatedContent.length,
            )
                : ListView(
              children: const [
                Text(
                  'No API key found. Please provide an API Key using '
                      "'--dart-define' to set the 'API_KEY' declaration.",
                ),
              ],
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
                const SizedBox.square(dimension: 15),

                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
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
        ],
      ),
    );
  }


  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
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
            )
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
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
                child: Column(children: [
                  if (text case final text?) MarkdownBody(data: text),
                  if (image case final image?) image,
                ]))),
      ],
    );
  }
}

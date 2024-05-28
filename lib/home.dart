import 'package:chatbot_v1/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //comenzamos con la implementacion primero importamos e inicializamos gemini
  late final GenerativeModel _model; 
  //
//implementamos las sesiones de chat
  late final ChatSession _chatSession;
//
//editor de texto
final FocusNode _textFieldFocus = FocusNode();
//obtener el user input
final TextEditingController _textController = TextEditingController();
//
// ignore: unused_field
bool _loading = false;
final ScrollController _scrollController = ScrollController();

//
//inicializamos usano la apikey de gemini
  @override
  void initState(){
    super.initState();
    _model = GenerativeModel(
      //aca usamos el modelo de gemini que estemos usando gemini-pro o gemini
      model: 'gemini', 
      apiKey: const String.fromEnvironment('Api_key'),
           
      );
      var apikey = const String.fromEnvironment('Api_key');
        print('Api Key: $apikey ');

      //lo iniciamos en el state
      _chatSession = _model.startChat();

  }

     Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try{
      final response = await _chatSession.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      if (text == null) {
        _showError ('No hay respuesta de la API');
        return;
      }else{
        setState((){
          _loading = false;
          _scrollDown();
        });
      }
    }catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    }finally{
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
   }

   void _scrollDown(){
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      )
      
      );
   }


   InputDecoration textFieldDecoration(){
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'De que requieres una consulta?',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        )
      ) 
   );
   
  }

   void _showError(String message) {
    showDialog(
      context: context, 
      builder: (context) {
        return  AlertDialog(
          title: const Text('Algo ocurrio'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(onPressed:(){
              Navigator.of(context).pop();
            },
            child: const Text('Ready bebe.'),
            )
          ],
        );
      }

    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creado con amor y dolor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatSession.history.length,
                itemBuilder: (context, index) {
                  final Content content= _chatSession.history.toList()[index];
                  final text = 
                  content.parts.whereType<TextPart>().map<String>((e)=>e.text).join('');
      
                  return MessageWidget(
                    text: text, 
                    isFromuser: content.role == 'user',
                    );
      
                }
              )
            ),
            Padding(padding: EdgeInsets.symmetric(
              vertical: 29,
              horizontal: 15,

            ),
            child: Row(
              children: [
                Expanded(child: TextField(
                  autofocus: true,
                  focusNode: _textFieldFocus,
                  decoration: textFieldDecoration(),
                  controller: _textController,
                  onSubmitted: _sendChatMessage,
                )
                ),
                const SizedBox(height: 15,)
              ],
            ),
            )
          ],
        ),
      ),
    );
  }


 
}
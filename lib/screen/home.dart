import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:gemini/models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const key = 'AIzaSyAJa7cv5o5ak4_2fFrd6o7g7NrZ6SvxgjY';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: key);
  TextEditingController Start = TextEditingController();
  List<Message> chatlist = [];
  void sendMessage() async {
    chatlist.add(
      Message(
        isuser: true,
        message: Start.text,
        date: DateTime.now(),
      ),
    );
    final content = [Content.text(Start.text)];
    final response = await model.generateContent(content);
    chatlist.add(Message(
      isuser: false,
      message: response.text ?? '',
      date: DateTime.now(),
    ));
    Start.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 2, 56, 100),
          title: Text(
            'Gemini AI',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatlist.length,
                  itemBuilder: (context, index) {
                    return BubbleNormal(
                      text: chatlist[index].message,
                      isSender: chatlist[index].isuser,
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: Start,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter here'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          sendMessage();
                        },
                        child: Icon(
                          Icons.send,
                          size: 25,
                        )),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

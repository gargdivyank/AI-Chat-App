import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
  );
 ChatUser geminiUser = ChatUser(
  id: '1',
  firstName: 'Gemini',
  profileImage: 'assets/images/gemini-gets-a-new-avatar-what-does-googles-latest-play-hold-for-you.webp', // Replace with any suitable image URL
);
  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background for a clean look
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gemini Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 153, 125, 227),
        elevation: 5,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        sendButtonBuilder: (onSend) => IconButton(
          icon: const Icon(Icons.send, color: Color.fromARGB(255, 59, 162, 247), size: 28),
          onPressed: onSend,
        ),
        inputDecoration: InputDecoration(
          hintText: "Type your message...",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        trailing: [
          IconButton(
            icon: const Icon(Icons.image, color: Color.fromARGB(255, 59, 162, 247), size: 28),
            onPressed: _sendMediaMessage,
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
 messageOptions: MessageOptions(
  currentUserContainerColor: Colors.redAccent,
  containerColor: Colors.white,
  textColor: Colors.black,
  currentUserTextColor: Colors.white,
  messageDecorationBuilder: (message, previousMessage, nextMessage) => BoxDecoration(
    color: message.user.id == currentUser.id ? const Color.fromARGB(255, 77, 177, 213) : Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        spreadRadius: 1,
        blurRadius: 5,
      ),
    ],
  ),
  messageTextBuilder: (message, previousMessage, nextMessage) {
    return Text(
      message.text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Bigger text with better readability
    );
  },
),


    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;

       String response = event.content?.parts
    ?.whereType<TextPart>() // Extract only text parts
    .map((e) => e.text.trim()) // Ensure each part is trimmed properly
    .join(' ') ?? ''; // Join with spaces
 // Join all parts

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response; // Append new response
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture",
        medias: [
          ChatMedia(url: image.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}

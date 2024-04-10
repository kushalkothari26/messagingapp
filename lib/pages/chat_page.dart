import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messagingapp/components/chat_bubble.dart';
import 'package:messagingapp/components/my_textfield.dart';
import 'package:messagingapp/services/auth/auth_service.dart';
import 'package:messagingapp/services/chat/chat_service.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID
  });
  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();

  final ChatService _chatService=ChatService();

  final AuthService _authService=AuthService();

  FocusNode myFocusNode=FocusNode();
  @override
  void initState(){
    super.initState();
    
    myFocusNode.addListener(() { 
      if(myFocusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 500),()=>scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500),()=>scrollDown());
  }
  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }
  final ScrollController _scrollController=ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn
    );
  }

  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverID,_messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID=_authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID,senderID),
        builder: (context,snapshot){
      if(snapshot.hasError){
        return const Text("Error!");
      }
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Text("Loading..");
      }
      return ListView(
        controller: _scrollController,
        children:
          snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
      );
    });
  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic>data=doc.data() as Map<String,dynamic>;

    bool isCurrentUser=data['senderID']==_authService.getCurrentUser()!.uid;

    var alignment=isCurrentUser?Alignment.centerRight: Alignment.centerLeft;

    return Container(alignment: alignment,child: Column(
      crossAxisAlignment: isCurrentUser?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
      ],
    ));
  }

  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child:
              MyTextField(
                controller: _messageController,
                hintText: "Type a Message",
                obscureText: false,
                focusNode: myFocusNode,
              )
              ),
            Container(
                decoration: const BoxDecoration(color:Colors.green,shape: BoxShape.circle),
                margin: const EdgeInsets.only(right: 25),
                child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.send,color: Colors.white,))
            )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: sendMessage,
          //       child: Container(
          //           padding: const EdgeInsets.all(20),
          //           decoration: BoxDecoration(color:Colors.red,shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10)),
          //           child: const Text("you gave")
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: sendMessage,
          //       child: Container(
          //         padding: const EdgeInsets.all(20),
          //           decoration: BoxDecoration(color:Colors.green,shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10)),
          //           child: const Text("you Received")
          //       ),
          //     )
          //   ],
          // )
        ],
      ),

    );
  }
}

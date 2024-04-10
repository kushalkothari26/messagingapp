import 'package:flutter/material.dart';
import 'package:messagingapp/components/user_tile.dart';
import 'package:messagingapp/pages/chat_page.dart';
import 'package:messagingapp/services/auth/auth_service.dart';
import 'package:messagingapp/services/chat/chat_service.dart';

import '../components/my_drawer.dart';
class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService=ChatService();
  final AuthService _authService=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),backgroundColor: Colors.transparent,foregroundColor: Colors.green,),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }
  Widget _buildUserList(){
    return StreamBuilder(stream: _chatService.getUserStream(), builder: (context,snapshot){
      if(snapshot.hasError){
        return const Text("Error");
      }

      if(snapshot.connectionState==ConnectionState.waiting){
        return const Text("Loading...");
      }
      return ListView(
        children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
      );
    });

  }
  Widget _buildUserListItem(
      Map<String,dynamic> userData,BuildContext context){
    if(userData["email"]!=_authService.getCurrentUser()!.email){
      return UserTile(
          text: userData["email"],
          onTap:(){
            Navigator.push(
                context,MaterialPageRoute(builder: (context)=>ChatPage(
              receiverEmail: userData["email"],
              receiverID: userData["uid"],
            ),)
            );
          }
      );

    }else{
      return Container();
    }
  }
}

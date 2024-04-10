
import 'package:flutter/material.dart';
import 'package:messagingapp/components/my_button.dart';
import 'package:messagingapp/components/my_textfield.dart';
import 'package:messagingapp/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final void Function()? onTap;
  LoginPage({super.key,required this.onTap});

  void login(BuildContext context)async{
    final authService=AuthService();
    try{
      await authService.signInWithEmailPassword(_emailController.text,_passwordController.text);
    }catch(e){
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text(e.toString()),
      ));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 40,),
          Text ("Welcome back!!! you have been missed",style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),),
          const SizedBox(height: 50,),
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
            focusNode: null,
          ),
          const SizedBox(height: 20,),
          MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
            focusNode: null,
          ),
          const SizedBox(height: 20,),
          MyButton(text: "Login",onTap: ()=>login(context),),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a Member?',style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              GestureDetector(onTap: onTap,child: Text('Register Now',style:TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),))
            ],
          )
        ],

      ),
    );
  }
}

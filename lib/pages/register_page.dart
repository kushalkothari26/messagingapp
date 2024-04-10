import 'package:flutter/material.dart';
import 'package:messagingapp/components/my_button.dart';
import 'package:messagingapp/components/my_textfield.dart';
import 'package:messagingapp/services/auth/auth_service.dart';
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key,required this.onTap});
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _conpasswordController=TextEditingController();
  final void Function()? onTap;

  register(BuildContext context){
    final authService=AuthService();
    if(_passwordController.text==_conpasswordController.text){
      try{
        authService.signUpWithEmailPassword(_emailController.text, _passwordController.text);
      }catch(e){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }
    }
    else{
      showDialog(context: context, builder: (context)=>const AlertDialog(
        title: Text("passwords don't match"),
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
          const SizedBox(height: 50,),
          Text ("hey!!! Welcome to the App",style: TextStyle(
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
          MyTextField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _conpasswordController,
            focusNode: null,
          ),
          const SizedBox(height: 20,),
          MyButton(text: "Register",onTap: ()=>register(context),),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already a Member?',style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              GestureDetector(onTap: onTap,child: Text('Login Now',style:TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),))
            ],
          )
        ],

      ),
    );
  }
}

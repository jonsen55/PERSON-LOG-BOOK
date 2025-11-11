// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_third/components/buildTextField.dart';
import 'package:hive_third/view/home_screen.dart';
import 'package:hive_third/view/register_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool isValidEmail = true;
  String _email = 'guest';
  String _password = '';
  // SharedPreferences? prefsData;

  

  // String? validateEmail(String? value){
  //   final RegExp emailValidatorRegExp = RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
  //   );
  //   if(value == null || value.isEmpty){
  //     // print("EMPTY XA");
  //     return 'Please enter email';
  //   }else if(!emailValidatorRegExp.hasMatch(value)){
  
  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _email = prefs.getString('email') ?? 'guest';
  //     _password = prefs.getString('password') ?? 'user';
  //   });
  // }
  bool? isSelected = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Login',
        //   style: TextStyle(
        //       color: Colors.white,
        //       fontFamily: 'Montserrat',
        //       fontWeight: FontWeight.bold,
        //     ),
        // ),
        toolbarHeight: 0,
        backgroundColor: Colors.deepPurple[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
              height: 140,
              color: Colors.deepPurple[700],
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(450),
                border: Border.all(color: Colors.white, width: 5),
                color: Colors.deepPurple[700],
                // image: DecorationImage(
                //   image: AssetImage('assets/images/0.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),child: Icon(Icons.person,size: 100,color: Colors.white,),
            ),
              ],
            ),
            SizedBox(height: 40,),
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
              child: Column(
                children: [
                  buildTextField(
                    prefixIcon: Icons.email,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        isValidEmail = false;
                        // print("EMPTY XA");
                        return 'Please enter an email';
                      }else if(!isValidEmail){
                        isValidEmail = false;
                        // print("INVALID XA");
                        return 'Please enter a valid email';
                      }
                      isValidEmail = true;
                      // print("VALID XA");
                      return "Successfull";
                    }
                  ),
                  SizedBox(height: 20,),
                  buildTextField(
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    isPassword: true,
                    isPasswordVisible: false,
                    hintText: 'Password',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter a password';
                      }
                    }
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(value: isSelected, onChanged: (value){
                          setState(() {
                            isSelected = value;
                          });
                        },
                        activeColor: Colors.deepPurple[700],),
                        Text('Remember me', style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'Monetserrat',
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                      onTap: (){
                        // Future<void> getSavedEmail() async{
                        //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                        //   emailController.text = prefs.getString('email') ?? '';
                        // }
                        // Future<void> getSavedPassword(String email) async{
                        //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                        //   if(email == prefs.getString('email')){
                        //     prefsData = prefs.getString('password') ?? '';
                        //   }
                        // }
                        // validateEmail(emailController.text.toString());
                        // _loadUserData();

                        
                        if(_email == emailController.text.toString() && _password == passwordController.text.toString()){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 1800),
                              backgroundColor: Colors.deepPurple[700],
                              content: Text("Logged in successfully"),
                            ),
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 1800),
                              backgroundColor: Color.fromARGB(255, 255, 98, 87),
                              content: Text("Invalid Credentials"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.deepPurple[700],
                        ),
                        child: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? '),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                          child: Text('Sign up', style: TextStyle(color: Colors.deepPurple[700]),),
                        ),
                      ],
                    ),
                ],
              )
            ),
        
          ],
        ),
      ),
    );
  }
}
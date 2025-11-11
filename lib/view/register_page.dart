import 'package:flutter/material.dart';
import 'package:hive_third/view/login_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import './../components/buildTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isValidEmail = true;
  String? response;
  final _formKey = GlobalKey<FormState>();

  

  String? validateEmail(String? value){
    final RegExp emailValidatorRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    );
    if(value == null || value.isEmpty){
      isValidEmail = false;
      // print("EMPTY XA");
      return 'Please enter an email';
    }else if(!emailValidatorRegExp.hasMatch(value)){
      isValidEmail = false;
      // print("INVALID XA");
      return 'Please enter a valid email';
    }
    isValidEmail = true;
    // print("VALID XA");
    return "Successfull";
  }
  bool? isSelected = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      prefixIcon: Icons.email,
                      hintText: 'Email',
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (value.length < 8) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20,),
                    buildTextField(
                      isPassword: true,
                      isPasswordVisible: false,
                      prefixIcon: Icons.lock,
                      hintText: 'Password',
                      onVisibilityToggle: (){},
                      
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }else if(value.length < 8){
                          return 'Password must be at least 8 characters';
                        }else{
                          return null;
                        }
                      },
                      controller: passwordController,
                    ),
                    SizedBox(height: 20,),
                    buildTextField(controller: usernameController, prefixIcon: Icons.person, hintText: 'Username', validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                    }),
                    SizedBox(height: 20,),
                    GestureDetector(
                        onTap: (){
                          response = validateEmail(emailController.text.toString());
                          // print(response);
                          if(isValidEmail == true){
                            if(passwordController.text.length > 8){
                              // saveData(emailController.text.toString(), passwordController.text.toString());
                              // readData();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 1800),
                                  backgroundColor: Color.fromARGB(255, 255, 98, 87),
                                  content: Text('Password must be at least 8 characters', style: TextStyle(color: Colors.white),),
                                ),
                              );
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 1800),
                                backgroundColor: Color.fromARGB(255, 255, 98, 87),
                                content: Text(response??"Invalid Email", style: TextStyle(color: Colors.white),),
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
                          child: Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ),
                  ],
                ),
              )
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())),
                  child: Text('Login', style: TextStyle(color: Colors.deepPurple[700]),),
                ),
              ],
            ),
        
          ],
        ),
      ),
    );
  }
  // Future<void> saveData(String email, String password) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    
  //   if(prefs.getString('email') != email){
  //     if(password.length >= 8){
  //       await prefs.setString('email', email);
  //       await prefs.setString('password', password);
  //       emailController.clear();
  //       passwordController.clear();
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(
  //       //     duration: Duration(milliseconds: 1800),
  //       //     backgroundColor: Colors.deepPurple[700],
  //       //     content: Text('Successfully registered!', style: TextStyle(color: Colors.white),),
  //       //   ),
  //       // );
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: Duration(milliseconds: 1800),
  //           backgroundColor: Color.fromARGB(255, 255, 98, 87),
  //           content: Text('Password must be at least 8 characters', style: TextStyle(color: Colors.white),),
  //         ),
  //       );
  //     }
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: Duration(milliseconds: 1800),
  //         backgroundColor: Color.fromARGB(255, 255, 98, 87),
  //         content: Text('Email already exists', style: TextStyle(color: Colors.white),),
  //       ),
  //     );
  //   }

  // }
  // Future<void> readData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    
  //   String? email = prefs.getString('email');
  //   String? password = prefs.getString('password');
    
    
  //   print('Email: $email');
  //   print('Password: $password');
    
  // }
}

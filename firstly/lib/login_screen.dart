import 'package:firstly/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FormScreen extends StatefulWidget {
  
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen>{
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Padding(
          padding:EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/ema_logo.jpeg",
                  height: 200, 
                  width: 200,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      // 
                      onPressed: () async {
                          await signInWithGoogle();
                        },
                      icon: FaIcon(FontAwesomeIcons.google),
                      label: Text("With Google"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, 
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                      },
                      icon: FaIcon(FontAwesomeIcons.facebook),
                      label: Text("With Facebook"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value){
                    bool emailValid = RegExp(
                            r"^[zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                    if(value.isEmpty){
                      return "Enter Email";
                    }
                      else if(!emailValid){
                          return "Enter Valid Email";
                        }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: (){
                        setState((){
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Password";
                    }
                    else if(passController.text.length < 6){
                      return "Password Length schould be more than 6 characters";
                    }
                  },
                ),

                const SizedBox(height: 20),
                InkWell(
                  child: Container(
                    height: 30,
                     width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("Login button pressed");
                          if(_formfield.currentState!.validate()){
                            print("Form is valid. Adding data to Firestore.");
                            await users.add({
                            'email': emailController.text,
                            'password': passController.text,
                          });
                            print("Data Added Successfully");
                            emailController.clear();
                            passController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomCreateListingScreen(announcements: []),
                              ),
                            );
                          }
                        },
                        child: Center(
                      child: Text("Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      )),
                      ),
                    ), 
                    ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Text(
                        "Create a new account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      ),
                  ],
                ),
                
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

Future<void> signInWithGoogle() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);      
      final User? user = userCredential.user;

      await _firestore.collection('users').doc(user!.uid).set({
        'email': user.email,
      });

    } catch (e) {
      print("Erreur lors de la connexion avec Google : $e");
    }
  }

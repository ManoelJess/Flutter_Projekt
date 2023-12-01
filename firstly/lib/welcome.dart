import 'package:firstly/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class welcomeScreen extends StatefulWidget {  

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/ema_logo.jpeg",
                  width: 100.w,
                  height: 20.h,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 1.6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User BookMyTime App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'You will be satisfied, just visited the app and find what you want',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () { 
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => FormScreen(),
                              ));
                          }, 
                          child: Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            backgroundColor: Color(0xFF835DF1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(onPressed: () {}, 
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFF835DF1),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),

      )
    ),
    );
  }
  
}
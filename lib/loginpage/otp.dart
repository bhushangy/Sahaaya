import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class otp extends StatefulWidget {
  @override
  _otpState createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;


  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted = (
        FirebaseUser user) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
      });
    };

    final PhoneVerificationFailed verificationFailed = (
        AuthException authException) {
      setState(() {
        print('Phone number verification failed. Code: ${authException
            .code}. Message: ${authException.message}');
      }
      );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber(String smsCode) async {
//    await FirebaseAuth.instance
//        .signInWithPhoneNumber(
//        verificationId: verificationId,
//        smsCode: smsCode)
//        .then((FirebaseUser user) async {
//      final FirebaseUser currentUser = await _auth.currentUser();
//      assert(user.uid == currentUser.uid);
//      print('signed in with phone number successful: user -> $user');
//    });
    Future getUserFromCodePhone(       String code, String verificationID) async {     FirebaseAuth mAuth = FirebaseAuth.instance;      AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(         verificationId: verificationID, smsCode: code);     try {       AuthResult result = await mAuth.signInWithCredential(phoneAuthCredential);        FirebaseUser currentUser = await mAuth.currentUser();       if (currentUser != null && result.user.uid == currentUser.uid) {         return currentUser;       } else {         return null;       }     } on PlatformException catch (_) {}      return null;   }

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Phone Verificationn"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller: _phoneNumberController,
            ),
            new TextField(
              controller: _smsCodeController,
            ),
            new FlatButton(
                onPressed: () =>
                    _signInWithPhoneNumber(_smsCodeController.text),
                child: const Text("Sign In"))
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _sendCodeToPhoneNumber(),
        tooltip: 'get code',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_firebase/verifypage.dart';
import 'package:phone_auth_firebase/widget/button.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final phoneController = TextEditingController();

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final _auth = FirebaseAuth.instance;

  void sendOTP(phoneNumber) {
    _isLoading.value = true;
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          debugPrint(e.toString());
        },
        codeSent: (String verifId, int? token) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyPage(verifId: verifId)));
        },
        codeAutoRetrievalTimeout: (e) {
          debugPrint(e.toString());
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Phone Verification",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Please enter your mobile number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("Add (+91) before your phone number"),
              // const Text("You will receive a 6 digit code"),
              // const Text("to verify next"),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "Mobile Number"),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (context, value, child) => BoxButton(
                        loading: _isLoading.value,
                        text: "CONTINUE",
                        onTap: () {
                          if (phoneController.text.isNotEmpty) {
                            _isLoading.value = true;
                            sendOTP(phoneController.text.toString());
                          }
                        },
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

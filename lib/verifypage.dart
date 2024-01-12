// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_auth_firebase/welcomepage.dart';

import 'package:phone_auth_firebase/widget/button.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({
    Key? key,
    required this.verifId,
  }) : super(key: key);
  final String verifId;

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  TextEditingController verifyCodeController = TextEditingController();
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final _auth = FirebaseAuth.instance;

  void verifyCode(verifyCode) async {
    _isLoading.value = true;
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verifId, smsCode: verifyCode.toString());
    try {
      await _auth.signInWithCredential(credential);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WelcomePage()));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Verify Code",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Verify Phone",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("Code sent to your phone number"),
              const SizedBox(
                height: 20,
              ),
              Form(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          height: 45,
                          width: 41,
                          child: TextFormField(
                            controller: otpControllers[index],
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColor))),
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.length == 1 && index == 5) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                        ),
                      ))),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (context, value, child) => BoxButton(
                        loading: _isLoading.value,
                        text: "VERIFY",
                        onTap: () {
                          String enteredOTP = otpControllers.fold<String>(
                              '', (prev, controller) => prev + controller.text);
                          debugPrint("MY VERIFICATION CODE IS :$enteredOTP");

                          if (enteredOTP.length < 5) {
                          } else {
                            _isLoading.value = true;
                            verifyCode(enteredOTP);
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

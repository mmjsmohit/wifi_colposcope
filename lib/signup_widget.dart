import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wifi_colposcope/main.dart';
import 'package:email_validator/email_validator.dart';

import 'screens/add_image.dart';
import 'utils.dart';

class SignupWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignupWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  bool clickedOnSignUp = false;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final comorbiditiesController = TextEditingController();
  final doctorVisitController = TextEditingController();
  final doctorNameController = TextEditingController();
  final hospitalNameController = TextEditingController();
  String bloodGroupValue = 'A+';
  var db = FirebaseFirestore.instance.collection("users");
  final List<String> _bloodGroupList = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Future<void> deactivate() async {
    if (clickedOnSignUp) {
      final firebaseUser = FirebaseAuth.instance.currentUser!;
      // Create a new user with a first and last name
      final user = <String, dynamic>{
        "uid": firebaseUser.uid,
        "name": nameController.text,
        "age": ageController.text,
        "address": addressController.text,
        "blood_group": bloodGroupValue,
        "weight": weightController.text,
        "height": heightController.text,
        "comorbidities": comorbiditiesController.text,
        "visit_details": doctorVisitController.text,
        "doctor_name": doctorNameController.text,
        "hospital_name": hospitalNameController.text
      };
      print(user);
      await firebaseUser.updateDisplayName(user['name']);
      db.doc(emailController.text).set(user);
    }
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/ceeri_logo.png'),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration:
                      InputDecoration(labelText: 'Enter your Full Name'),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: confirmPasswordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) =>
                      passwordController.text != confirmPasswordController.text
                          ? 'Passwords do not match'
                          : null,
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: addressController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(
                  height: 4,
                ),
                DropdownButton<String>(
                  value: bloodGroupValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      bloodGroupValue = newValue!;
                    });
                  },
                  items: _bloodGroupList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: weightController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Weight (in kg)'),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: heightController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Height (in cm)'),
                ),
                TextField(
                  controller: comorbiditiesController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Comorbidities'),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Text('Last Doctor Visit Details'),
                ),
                TextField(
                  controller: doctorVisitController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Visit Details'),
                ),
                TextField(
                  controller: doctorNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Doctor Name'),
                ),
                TextField(
                  controller: hospitalNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Hospital Name'),
                ),
                SizedBox(
                  height: 4,
                ),
                FloatingActionButton(
                    child: Icon(Icons.add_a_photo),
                    onPressed: () {
                      if (emailController.text != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddImage(
                                  emailAddress: emailController.text,
                                )));
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: signUp,
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  icon: Icon(
                    Icons.arrow_right_alt,
                    size: 32,
                  ),
                  label: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    clickedOnSignUp = true;
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

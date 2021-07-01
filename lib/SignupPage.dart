import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class _SignupPageState extends State<SignupPage> {
 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  var items = ['belgavi,karnataka', 'bengluru,karnataka'];

  void signUpDetail(String username, String email, String phone,
      String password, String dropDownValue) async {
    var data = jsonEncode({
      "UserName": username,
      "Password": password,
      "Email": email,
      "Phone": phone,
      "Location": dropDownValue
    });

    var response = await http.post(
      Uri.http('192.168.43.242:5000', 'register'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final finalresponse = jsonDecode(response.body);
  
    if (finalresponse['result']['status'] == 1) {
      print(finalresponse['result']['status']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            'Registered Successfully',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Fail to register',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Widget _submitButton() {
    String userName;
    String email;
    String phone;
    String password;

    return GestureDetector(
      onTap: () => {
        print(dropDownValue),
        formKey.currentState.validate(),
        userName = _usernameController.text,
        email = _emailController.text,
        phone = _phoneController.text,
        password = _passwordController.text,
       
        signUpDetail(userName, email, phone, password, dropDownValue)
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Colors.redAccent
           
            ),
        child: Text(
          'Sign up',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: 'S',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 60)),
        TextSpan(
            text: 'ign', style: TextStyle(color: Colors.black, fontSize: 40)),
        TextSpan(
          text: 'u',
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 40),
        ),
        TextSpan(
          text: 'p',
          style: TextStyle(color: Colors.redAccent, fontSize: 30),
        ),
        TextSpan(
          text: '?',
          style: TextStyle(color: Colors.redAccent, fontSize: 50),
        ),
        TextSpan(
          text: '?',
          style: TextStyle(color: Colors.redAccent, fontSize: 30),
        ),
        TextSpan(
          text: '?',
          style: TextStyle(color: Colors.redAccent, fontSize: 20),
        ),
      ]),
    );
  }

  String dropDownValue;
  List<String> location = ["belgavi,karanataka", "benglore,karanataka"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         key: _scaffoldKey,
        body: Container(
      padding: EdgeInsets.only(top: 100, right: 30.0, left: 30.0, bottom: 60.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _title(),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    border: InputBorder.none,
                    hintText: "Your good name",
                    labelText: "Enter your name"),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: validateEmail,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    border: InputBorder.none,
                    hintText: "email address",
                    labelText: "Email"),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: validateMobile,
                
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  border: InputBorder.none,
                  hintText: "mobile Number",
                  labelText: "Mobile Number",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "This filed is required";
                  }
                  if (value.length < 4) {
                    return "Create a strong a password";
                  }
                  return null;
                },
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  border: InputBorder.none,
                  hintText: "password",
                  labelText: "password",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Choose Location",
                  fillColor: Color(0xfff3f3f4),
                ),
                value: dropDownValue,
                
                onChanged: (String value) {
                  setState(() {
                    dropDownValue = value;
                  });
                },
                items: location
                    .map((location) => DropdownMenuItem(
                        value: location, child: Text("$location")))
                    .toList(),
              ),
              
              SizedBox(
                height: 30,
              ),
              _submitButton(),
            ],
          ),
        ),
      ),
    ));
  }
}

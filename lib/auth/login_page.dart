import 'package:flutter/material.dart';

import '../core/utils/api_service.dart';
import '../core/widgets/zui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    username.text = 'admin';
    password.text = 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Screen'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/login.png'),
                  ZInput(
                    label: 'Username',
                    hintText: 'username',
                    controller: username,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) => (value?.contains('@') ?? false)
                    //     ? null
                    //     : 'Please enter a valid email.',
                  ),
                  const SizedBox(height: 4),
                  ZInput.password(
                    label: 'Password',
                    controller: password,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) => 8 <= (value?.length ?? 0)
                    //     ? null
                    //     : 'Password must be at least 8 characters long.',
                  ),
                  const SizedBox(height: 30),
                  ZButton(
                    text: 'Login',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      dataPost();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> dataPost() async {
    final body = <String, dynamic>{
      "username": username.text,
      "password": password.text,
    };

    try {
      final r = await ApiService().post('/auth/login', body, context: context);
      print(r);
      ApiService().setToken(r.data['token']);
      Navigator.pop(context);
      ZToast.success(context, 'Login success');
    } catch (e) {
      ZToast.error(context, 'Error, Failed to login');
    }
  }
}

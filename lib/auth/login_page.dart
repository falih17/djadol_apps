import 'package:djadol_mobile/core/utils/store.dart';
import 'package:flutter/material.dart';

import '../core/utils/api_service.dart';
import '../core/widgets/zui.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final storedUsername = await Store().getUsername();
    if (storedUsername != null) {
      setState(() {
        username.text = storedUsername;
        _rememberMe = true;
      });
    }
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
                    hintText: 'password',
                    controller: password,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) => 8 <= (value?.length ?? 0)
                    //     ? null
                    //     : 'Password must be at least 8 characters long.',
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
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
    if (_rememberMe) {
      await Store().setUsername(username.text);
    } else {
      await Store().clearUsername();
    }

    final body = <String, dynamic>{
      "username": username.text,
      "password": password.text,
    };

    try {
      final r = await ApiService().post('/auth/login', body, context: context);
      Store().setToken(r.data['token'], r.data['user_id']);
      await Store().setFullName(r.data['full_name']); // add this line

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      ZToast.success(context, 'Login success');
    } catch (e) {
      ZToast.error(context, 'Error, Failed to login');
    }
  }
}

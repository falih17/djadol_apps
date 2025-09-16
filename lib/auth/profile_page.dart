import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';

import '../core/utils/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordOldController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    var result = await ApiService().get('/getone/40/${Store().userId}');
    print(result);
    if (result != null) {
      _fullnameController.text = result['full_name'] ?? '';
      _phoneController.text = result['phone'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    var data = {
      'id': Store().userId,
      'form_id': 40,
      'full_name': _fullnameController.text,
      'phone': _phoneController.text,
    };

    var result = await ApiService().post('/api/form_action', data, context: context);
    setState(() => _isLoading = false);

    // if (result.success) {
      Navigator.pop(context, true);
    // }
  }

  Future<void> _password() async {
    if (_passwordController.text.isEmpty && _passwordOldController.text.isEmpty) {
      ZToast.error(context, 'Password wajib diisi');
      return;
    }
    setState(() => _isLoading = true);

    var data = {
      'old_password': _passwordOldController.text,
      'password': _passwordController.text,
    };

    // Only send password if not empty
    

    var result = await ApiService().post('/act/changeuserpassword', data, context: context);
    if(!result.data['success']){
      ZToast.error(context, result.data['message']);
    }else{
      ZToast.success(context, result.data['message']);
    }
    setState(() => _isLoading = false);

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit Password')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ZInput(
                //   controller: _fullnameController,
                //   label: 'Fullname',
                //   validator: (v) =>
                //       v == null || v.isEmpty ? 'Fullname required' : null,
                // ),
                // const SizedBox(height: 16),
                // ZInput(
                //   controller: _phoneController,
                //   label: 'Phone',
                //   validator: (v) =>
                //       v == null || v.isEmpty ? 'Phone required' : null,
                // ),
                // ZButton(
                //   text: _isLoading ? 'Saving...' : 'Save',
                //   onPressed: _isLoading ? null : _saveProfile,
                // ),
                // const SizedBox(height: 16),
                ZInput.password(
                  controller: _passwordOldController,
                  label: 'Password Lama',
                  obscureText: true,
                ),
                ZInput.password(
                  controller: _passwordController,
                  label: 'Password Baru',
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                ZButton(
                  text: _isLoading ? 'Saving...' : 'Save',
                  onPressed: _isLoading ? null : _password,
                ),
              ],
            ),
          ),
        ),
      );
}
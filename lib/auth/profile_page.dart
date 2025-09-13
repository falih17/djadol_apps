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
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    Map<String, dynamic> data = {
        'form_id': '40',
        'id': Store().userId,
      };
    // Fetch current user profile
    var result = await ApiService().get('/form/40/'$Store().userId);
    if (result.data != null) {
      _fullnameController.text = result.data['fullname'] ?? '';
      _phoneController.text = result.data['phone'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    var data = {
      'id': Store().userId,
      'form_id': 40,
      'fullname': _fullnameController.text,
      'phone': _phoneController.text,
    };

    // Only send password if not empty
    if (_passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
    }

    var result = await ApiService().post('/act/save', data, context: context);
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ZInput(
                  controller: _fullnameController,
                  label: 'Fullname',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Fullname required' : null,
                ),
                const SizedBox(height: 16),
                ZInput(
                  controller: _phoneController,
                  label: 'Phone',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Phone required' : null,
                ),
                const SizedBox(height: 16),
                ZInput(
                  controller: _passwordController,
                  label: 'Password (leave blank to keep current)',
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                ZButton(
                  text: _isLoading ? 'Saving...' : 'Save',
                  onPressed: _isLoading ? null : _saveProfile,
                ),
              ],
            ),
          ),
        ),
      );
}
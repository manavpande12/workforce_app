import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_input.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/user_image_picker.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confPassController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isAuthenticating = false;
  String? _enteredName;
  String? _enteredEmail;
  String? _enteredPassword;
  String? _enteredConfPassword;
  File? _selectedImage;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confPassController = TextEditingController();

  Future<void> _authenticate() async {
    // Fetch user inputs
    _enteredName = _nameController.text.trim();
    _enteredEmail = _emailController.text.trim();
    _enteredPassword = _passController.text.trim();
    _enteredConfPassword = _confPassController.text.trim();

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_form.currentState!.validate()) {
      context.showSnackBar('Please fill all fields correctly!', isError: true);
      return;
    }

    // Additional validation for sign-up
    if (!_isLogin) {
      if (_selectedImage == null) {
        context.showSnackBar('Please select an image!', isError: true);
        return;
      }
      if (_enteredPassword != _enteredConfPassword) {
        context.showSnackBar('Passwords do not match!', isError: true);
        return;
      }
    }

    // Save form state
    _form.currentState!.save();

    try {
      setState(() => _isAuthenticating = true);

      if (_isLogin) {
        await ref
            .read(userProvider.notifier)
            .login(_enteredEmail!, _enteredPassword!);
      } else {
        await ref.read(userProvider.notifier).signup(
              _enteredEmail!,
              _enteredPassword!,
              _enteredName!,
              _selectedImage!,
            );
      }
    } catch (e) {
      if (mounted) context.showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLogin
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      child: Hero(
                        tag: 'splash',
                        child: Image.asset(
                          logo,
                          width: 240,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? bgrey.withValues(alpha: 0.6)
                    : grey.withValues(alpha: 0.6),
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _isLogin
                                ? 'Login to your Account'
                                : 'Create Your Account',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              setState(() => _selectedImage = pickedImage);
                            },
                          ),
                        if (!_isLogin)
                          CustomInput(
                            controller: _nameController,
                            kType: TextInputType.name,
                            labelText: 'Name',
                            validationType: ValidationType.name,
                            maxLength: 50,
                          ),
                        const SizedBox(height: 20),
                        CustomInput(
                          controller: _emailController,
                          kType: TextInputType.emailAddress,
                          labelText: 'Email',
                          validationType: ValidationType.email,
                          maxLength: 100,
                        ),
                        const SizedBox(height: 20),
                        CustomInput(
                          controller: _passController,
                          kType: TextInputType.visiblePassword,
                          labelText: 'Password',
                          maxLength: 20,
                          validationType: ValidationType.password,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ...(!_isLogin
                            ? [
                                CustomInput(
                                  controller: _confPassController,
                                  kType: TextInputType.visiblePassword,
                                  labelText: 'Confirm Password',
                                  maxLength: 20,
                                  validationType: ValidationType.none,
                                  obscureText: true,
                                ),
                                SizedBox(height: 20),
                              ]
                            : []),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          CustomButton(
                            fgClr: black,
                            bgClr: yellow,
                            text: _isLogin ? 'Login' : 'Register',
                            onTap: _authenticate,
                            iClr: black,
                            icon: _isLogin
                                ? Icons.login
                                : Icons.app_registration_rounded,
                            iSize: 30,
                          ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _form.currentState?.reset();
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create An Account'
                                  : 'I Already Have An Account.',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

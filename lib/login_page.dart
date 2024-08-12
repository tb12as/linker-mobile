import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lnkr_syafiq_afifuddin/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _checkIsLogged(BuildContext context) async {
    final http = HttpHelper();
    final response = await http.get('/user');
    if (response.statusCode == 200 && context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> _login(BuildContext context) async {
    _isLoading = true;
    setState(() => {});

    final username = usernameController.text;
    final password = passwordController.text;

    final http = HttpHelper();

    if (username.isEmpty || password.isEmpty) {
      _isLoading = false;
      setState(() => {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    _isLoading = true;
    setState(() => {});
    final response = await http.post(
      '/login',
      {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['data']['token'];

      // Store the token in local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navigate to the next screen (home page)
      if (context.mounted) {
        _isLoading = false;
        setState(() => {});
        Navigator.pushReplacementNamed(context, '/');
      }
    } else {
      final body = jsonDecode(response.body);
      String? message = body['message'];

      _isLoading = false;
      setState(() => {});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${message ?? ''}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkIsLogged(context);

    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // form start
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/logo.png',
                        height: 90,
                        width: 90,
                      ),
                      // const Text("Login",
                      //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome back, please login to continue",
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30))),
                        onPressed: () => {_login(context)},
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

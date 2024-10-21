import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/RegistreModel.dart';
import 'package:medigo/screens/home.dart';
import 'package:medigo/screens/mypharmacie.dart';
import 'package:medigo/screens/registrer.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/userservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      ApiResponse<Map<String, dynamic>> response =
          await SignInService(_emailController.text, _passwordController.text);

      setState(() {
        _isLoading = false;
      });

      if (response.erreur == null && response.data != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('quartier');

        String token = response.data!['token'] ?? '';
        String id = response.data!['agent_id'] ?? '';
        String nom = response.data!['agent_nom'] ?? '';
        String prenom = response.data!['agent_prenom'] ?? '';
        String telephone = response.data!['agent_telephone'] ?? '';
        String email = response.data!['agent_email'] ?? '';

        await prefs.setString('token', token);
        await prefs.setString('agent_id', id);
        await prefs.setString('agent_nom', nom);
        await prefs.setString('agent_prenom', prenom);
        await prefs.setString('agent_telephone', telephone);
        await prefs.setString('agent_email', email);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyPharmacie()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.erreur}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Se Connecter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 93, 76),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined, // Icône d'email
                                color: Color.fromARGB(255, 0, 93, 76),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 93, 76),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline, // Icône de mot de passe
                                color: Color.fromARGB(255, 0, 93, 76),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 0, 93, 76),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              icon: Icon(Icons.login, color: Colors.white),
                              label: const Text(
                                'Se connecter',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    child: Text(
                      'Pas encore de compte? S\'inscrire',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 93, 76),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

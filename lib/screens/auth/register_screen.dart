// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // VALIDAÇÃO (LÓGICA)
  String? _validateName(String name) {
    if (name.length < 3) {
      return 'O nome deve ter no mínimo 3 letras.';
    }
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s]+$");
    if (!nameRegex.hasMatch(name)) {
      return 'O nome deve conter apenas letras.';
    }
    return null;
  }

  String? _validateEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      return 'Digite um email válido (ex: nome@email.com).';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.length < 4) {
      return 'A senha deve ter no mínimo 4 caracteres.';
    }
    return null;
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Preencha todos os campos.', isError: true);
      return;
    }

    final nameError = _validateName(name);
    if (nameError != null) {
      _showSnackBar(nameError, isError: true);
      return;
    }

    final emailError = _validateEmail(email);
    if (emailError != null) {
      _showSnackBar(emailError, isError: true);
      return;
    }

    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      _showSnackBar(passwordError, isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('As senhas não coincidem.', isError: true);
      return;
    }

    final success = authService.register(name, email, password);

    if (success) {
      _showSnackBar('Cadastro realizado com sucesso!', isError: false);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      _showSnackBar('Este email já está cadastrado.', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Gerenciador de Tarefas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gerencie seu tempo de forma inteligente!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Crie sua Conta',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Nome Completo',
                                prefixIcon: Icon(Icons.person_outline),
                                hintText: 'Mínimo 3 letras',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'exemplo@email.com',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                hintText: 'Mínimo 4 caracteres',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              obscureText: _obscurePassword,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirmar Senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () => setState(() =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                child: const Text('Cadastrar'),
                              ),
                            ),
                          ],
                        ),
                      ),
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

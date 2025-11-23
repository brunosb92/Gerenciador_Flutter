import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../calendar/calendar_screen.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  void _handleLogin() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, preencha email e senha.', isError: true);
      return;
    }

    final isValid = authService.login(email, password);

    if (isValid) {
      _showSnackBar('Login realizado com sucesso!', isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarScreen(userEmail: email),
        ),
      );
    } else {
      _showSnackBar('Email ou senha inválidos.', isError: true);
    }
  }

  // SHOWDIALOG (ESQUECEU SENHA)
  void _showForgotPasswordDialog() {
    final recoveryEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Recuperar Senha',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Digite seu email para receber um link de redefinição.'),
            const SizedBox(height: 20),
            TextField(
              controller: recoveryEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = recoveryEmailController.text.trim();
              if (email.isEmpty) return;

              Navigator.pop(ctx);

              if (authService.emailExists(email)) {
                _showSnackBar('Email de recuperação enviado para $email',
                    isError: false);
              } else {
                _showSnackBar('Email não encontrado no sistema.',
                    isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  //SNACKBAR (SUCESS/FAIL LOGIN)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    Image.asset(
                      'assets/images/logo.png',
                      height: 60,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gerencie seu tempo de forma inteligente!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
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
                              'Bem-vindo(a)!',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 40),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () =>
                                      setState(() => _isObscure = !_isObscure),
                                ),
                              ),
                              obscureText: _isObscure,
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                child: const Text('Entrar'),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextButton(
                              onPressed: _showForgotPasswordDialog,
                              child: const Text('Esqueceu sua senha?'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'Crie sua conta aqui',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
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

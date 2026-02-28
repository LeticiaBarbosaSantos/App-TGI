import 'package:flutter/material.dart';
import 'services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _loading = false;
  bool _senhaVisivel = false;

  // Função de login com validação na API
  void fazerLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha e-mail e senha corretamente!"),
          backgroundColor: Color.fromARGB(222, 59, 59, 59),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await ApiService.loginUsuario(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      // Login bem-sucedido - salvar dados e ir para home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login realizado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar para home com ID do usuário
      Navigator.pushReplacementNamed(
        context,
        "/home",
        arguments: response['usuario_id'],
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 Stack permite colocar decoração atrás do conteúdo
      body: Stack(
        children: [

          // 🔹 Decoração cinza no canto superior
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 🔹 Decoração cinza no canto inferior
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 162, 162, 162),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 🔹 Conteúdo principal
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 40),

                  // 🔹 Título
                  const Text(
                    "Bem-vindo ao",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Logo
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/logotipo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Texto auxiliar
                  const Text(
                    "Seu app para compras rápidas,\nhistórico e muito mais.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 🔹 Campo e-mail
                  TextField(
                    controller: emailController,
                    enabled: !_loading,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Campo senha com toggle de visibilidade
                  TextField(
                    controller: senhaController,
                    enabled: !_loading,
                    obscureText: !_senhaVisivel,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _senhaVisivel = !_senhaVisivel);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 🔹 Botão Entrar com estado de carregamento
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : fazerLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF568F7C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Entrar",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Cadastro
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.pushNamed(context, "/cadastro");
                          },
                    child: const Text(
                      "Não tem conta? Cadastre-se",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF568F7C),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

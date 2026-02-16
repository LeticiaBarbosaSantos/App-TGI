 import 'package:flutter/material.dart';
import 'services/api_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _loading = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  final Color darkBlue = const Color(0xFF07142B);
  final Color accent = const Color(0xFF568F7C);

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email é obrigatório";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Email inválido";
    }
    return null;
  }

  String? _validarCPF(String? value) {
    if (value == null || value.isEmpty) {
      return "CPF é obrigatório";
    }
    if (value.length != 11) {
      return "CPF deve ter 11 dígitos";
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return "Senha é obrigatória";
    }
    if (value.length < 6) {
      return "Senha deve ter no mínimo 6 caracteres";
    }
    return null;
  }

  void _fazerCadastro() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não correspondem")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await ApiService.registrarUsuario(
        nome: _nomeController.text,
        email: _emailController.text,
        cpf: _cpfController.text,
        senha: _senhaController.text,
        telefone: _telefoneController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso! Faça login."),
          backgroundColor: Colors.green,
        ),
      );

      // Voltar para login
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Cadastro",
          style: TextStyle(
            color: darkBlue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            "Crie sua conta SmartPay",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Preencha os dados abaixo para se cadastrar",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),

          // Formulário
          Form(
            key: _formKey,
            child: Column(
              children: [
                _campoTexto(
                  controller: _nomeController,
                  label: "Nome Completo",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nome é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  tipo: TextInputType.emailAddress,
                  validator: _validarEmail,
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _cpfController,
                  label: "CPF (11 dígitos)",
                  icon: Icons.credit_card,
                  tipo: TextInputType.number,
                  validator: _validarCPF,
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _telefoneController,
                  label: "Telefone",
                  icon: Icons.phone,
                  tipo: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _senhaController,
                  label: "Senha",
                  icon: Icons.lock,
                  obscuro: !_senhaVisivel,
                  validator: _validarSenha,
                  suffix: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () => _senhaVisivel = !_senhaVisivel,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _confirmarSenhaController,
                  label: "Confirmar Senha",
                  icon: Icons.lock,
                  obscuro: !_confirmarSenhaVisivel,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirme sua senha";
                    }
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _confirmarSenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _confirmarSenhaVisivel = !_confirmarSenhaVisivel,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Botão Cadastro
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _loading ? null : _fazerCadastro,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Cadastrar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Já tem conta? "),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Faça login",
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscuro = false,
    TextInputType tipo = TextInputType.text,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscuro,
      keyboardType: tipo,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accent),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accent),
        ),
      ),
    );
  }
}

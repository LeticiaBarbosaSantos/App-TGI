import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/api_service.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    String text = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) text += '.';
      if (i == 9) text += '-';
      text += digits[i];
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    String text = '';
    if (digits.isEmpty) {
      text = '';
    } else if (digits.length <= 2) {
      text = '(${digits}';
    } else if (digits.length <= 6) {
      text = '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      text =
          '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else {
      text =
          '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class DataNascimentoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    String text = '';
    if (digits.isEmpty) {
      text = '';
    } else if (digits.length <= 2) {
      text = digits;
    } else if (digits.length <= 4) {
      text = '${digits.substring(0, 2)}/${digits.substring(2)}';
    } else {
      text =
          '${digits.substring(0, 2)}/${digits.substring(2, 4)}/${digits.substring(4)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

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
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _metodoPagamentoController =
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

  String _somenteDigitos(String text) => text.replaceAll(RegExp(r'\D'), '');

  String? _validarCPF(String? value) {
    final cpf = _somenteDigitos(value ?? '');
    if (cpf.isEmpty) {
      return "CPF é obrigatório";
    }
    if (cpf.length != 11) {
      return "CPF deve ter 11 dígitos";
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final telefone = _somenteDigitos(value);
    if (telefone.length < 10 || telefone.length > 11) {
      return "Telefone deve ter 10 ou 11 dígitos";
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

    final cpf = _somenteDigitos(_cpfController.text);
    final telefone = _telefoneController.text.trim().isEmpty
        ? null
        : _somenteDigitos(_telefoneController.text);

    try {
      final resposta = await ApiService.registrarUsuario(
        nome: _nomeController.text,
        email: _emailController.text,
        cpf: cpf,
        senha: _senhaController.text,
        telefone: telefone,
        // Campos extras para perfil
        endereco: _enderecoController.text.trim().isEmpty
            ? null
            : _enderecoController.text.trim(),
        nascimento: _nascimentoController.text.trim().isEmpty
            ? null
            : _nascimentoController.text.trim(),
        metodo_pagamento: _metodoPagamentoController.text.trim().isEmpty
            ? null
            : _metodoPagamentoController.text.trim(),
      );

      ApiService.currentUserId = resposta['usuario_id'] ?? resposta['id'];
      ApiService.currentUserName = _nomeController.text;
      ApiService.currentUserEmail = _emailController.text;
      ApiService.currentUserCpf = cpf;
      ApiService.currentUserTelefone = telefone;
      ApiService.currentUserEndereco = _enderecoController.text.trim();
      ApiService.currentUserNascimento = _nascimentoController.text.trim();
      ApiService.currentUserMetodoPagamento = _metodoPagamentoController.text
          .trim();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cadastro realizado com sucesso! Bem-vindo à StarFast.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Ir para perfil após cadastro
      Navigator.pushReplacementNamed(context, '/perfil');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
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
            "Crie sua conta StarFast",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Preencha os dados abaixo para se cadastrar",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                  label: "CPF",
                  icon: Icons.credit_card,
                  tipo: TextInputType.number,
                  inputFormatters: [CpfInputFormatter()],
                  validator: _validarCPF,
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _telefoneController,
                  label: "Telefone",
                  icon: Icons.phone,
                  tipo: TextInputType.phone,
                  inputFormatters: [TelefoneInputFormatter()],
                  validator: _validarTelefone,
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _enderecoController,
                  label: "Endereço",
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Endereço é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _nascimentoController,
                  label: "Data de nascimento (DD/MM/AAAA)",
                  icon: Icons.cake,
                  tipo: TextInputType.datetime,
                  inputFormatters: [DataNascimentoInputFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Data de nascimento é obrigatória";
                    }
                    if (!RegExp(r"^\d{2}/\d{2}/\d{4}").hasMatch(value)) {
                      return "Use o formato DD/MM/AAAA";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _campoTexto(
                  controller: _metodoPagamentoController,
                  label: "Método de pagamento (ex: Cartão ****1234)",
                  icon: Icons.payment,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o método de pagamento";
                    }
                    return null;
                  },
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
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _senhaVisivel = !_senhaVisivel);
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
                        () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel,
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
                  style: TextStyle(color: accent, fontWeight: FontWeight.bold),
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
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscuro,
      keyboardType: tipo,
      inputFormatters: inputFormatters,
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

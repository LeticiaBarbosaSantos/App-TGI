import 'package:flutter/material.dart';
import 'botao_menu.dart';
import 'services/api_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final Color darkBlue = const Color(0xFF07142B);
  final Color accent = const Color(0xFF568F7C);

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController nascimentoController = TextEditingController();
  final TextEditingController pagamentoController = TextEditingController();

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      int? userId = ApiService.currentUserId;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (userId == null && args is int) {
        userId = args;
      }

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      ApiService.currentUserId = userId;
      final perfil = await ApiService.obterPerfil(userId);
      nomeController.text = perfil['nome'] ?? ApiService.currentUserName ?? '';
      emailController.text =
          perfil['email'] ?? ApiService.currentUserEmail ?? '';
      cpfController.text = perfil['cpf'] ?? ApiService.currentUserCpf ?? '';
      telefoneController.text =
          perfil['telefone'] ?? ApiService.currentUserTelefone ?? '';
      enderecoController.text =
          perfil['endereco'] ?? ApiService.currentUserEndereco ?? '';
      nascimentoController.text =
          perfil['data_nascimento'] ?? ApiService.currentUserNascimento ?? '';
      pagamentoController.text =
          perfil['metodo_pagamento'] ??
          ApiService.currentUserMetodoPagamento ??
          '';

      if (pagamentoController.text.isEmpty) {
        pagamentoController.text = 'Nenhum método cadastrado';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _salvarPerfil() async {
    final usuarioId = ApiService.currentUserId;
    if (usuarioId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado')));
      return;
    }

    final dados = {
      'nome': nomeController.text.trim(),
      'email': emailController.text.trim(),
      'cpf': cpfController.text.trim(),
      'telefone': telefoneController.text.trim(),
      'endereco': enderecoController.text.trim(),
      'data_nascimento': nascimentoController.text.trim(),
      'metodo_pagamento': pagamentoController.text.trim(),
    };

    try {
      await ApiService.atualizarPerfil(usuarioId: usuarioId, dados: dados);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      await _carregarPerfil();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: darkBlue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: accent.withValues(alpha: 0.3),
                child: const Icon(Icons.person, size: 45, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                'Editar Perfil',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _input('Nome completo', nomeController),
          _input('E-mail', emailController),
          _input('CPF', cpfController),
          _input('Telefone', telefoneController),
          _input('Endereço', enderecoController),
          _input('Data de nascimento', nascimentoController),
          _input('Forma de pagamento', pagamentoController),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _salvarPerfil,
            child: const Text(
              'Salvar alterações',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          cursorColor: accent,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: accent, width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

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
  final TextEditingController enderecoController = TextEditingController();
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

      final perfil = await ApiService.obterPerfil(userId);
      nomeController.text = perfil['nome'] ?? ApiService.currentUserName ?? '';
      emailController.text = perfil['email'] ?? ApiService.currentUserEmail ?? '';
      enderecoController.text = perfil['endereco'] ?? '';

      if (perfil['metodosPagamento'] is List && (perfil['metodosPagamento'] as List).isNotEmpty) {
        final metodo = perfil['metodosPagamento'][0];
        pagamentoController.text = '${metodo['tipo'] ?? ''} ${metodo['ultimos_digitos'] ?? ''}';
      } else {
        pagamentoController.text = 'Nenhum método cadastrado';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar perfil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
          _input('Endereço', enderecoController),
          _input('Forma de pagamento', pagamentoController),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: accent,
                  content: const Text('Informações salvas!'),
                ),
              );
            },
            child: const Text(
              'Salvar alterações',
              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
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

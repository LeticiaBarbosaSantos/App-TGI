import 'package:flutter/material.dart';
import 'botao_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Estabelecimentos",
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Perto de você",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 10),

          _estabelecimentoCard(
            nome: "Supermercado Ideal",
            endereco: "Rua das Flores, 120",
            contexto: context,
          ),

          _estabelecimentoCard(
            nome: "Padaria Central",
            endereco: "Av. Paulista, 200",
            contexto: context,
          ),

          _estabelecimentoCard(
            nome: "Loja da Esquina",
            endereco: "Rua Azul, 88",
            contexto: context,
          ),
        ],
      ),
    );
  }

  Widget _estabelecimentoCard({
    required String nome,
    required String endereco,
    required BuildContext contexto,
  }) {
    const Color darkBlue = Color(0xFF07142B);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          nome,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        subtitle: Text(
          endereco,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: darkBlue),
        onTap: () {
          Navigator.pushNamed(contexto, "/carrinho");
        },
      ),
    );
  }
}
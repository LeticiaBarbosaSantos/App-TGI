import 'package:flutter/material.dart';
import 'botao_menu.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, this.userName = "Usuário"});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // -------- CABEÇALHO --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Olá,",
                    style: TextStyle(
                      fontSize: 20,
                      color: darkBlue,
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/perfil",
                    arguments: userName,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Atalhos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _atalho(
                icon: Icons.qr_code_scanner,
                label: "QR Code",
                onPressed: () => Navigator.pushNamed(context, "/qrcode"),
              ),
              _atalho(
                icon: Icons.shopping_cart,
                label: "Carrinho",
                onPressed: () => Navigator.pushNamed(context, "/carrinho"),
              ),
              _atalho(
                icon: Icons.history,
                label: "Histórico",
                onPressed: () => Navigator.pushNamed(context, "/carrinho"),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Estabelecimentos próximos",
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

          const SizedBox(height: 30),

          const Text(
            "Últimas atividades",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 10),

          _atividade("Compra no Supermercado Ideal", "R\$ 48,90"),
          _atividade("Compra na Padaria Central", "R\$ 16,50"),
          _atividade("Identificação realizada", "Hoje • 14:22"),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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

  Widget _atividade(String titulo, String valor) {
    const Color darkBlue = Color(0xFF07142B);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle, color: darkBlue),
      title: Text(
        titulo,
        style: const TextStyle(color: darkBlue),
      ),
      trailing: Text(
        valor,
        style: const TextStyle(
          color: darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _atalho({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    const Color darkBlue = Color(0xFF07142B);

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

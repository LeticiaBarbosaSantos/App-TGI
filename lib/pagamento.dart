import 'package:flutter/material.dart';

class PagamentoScreen extends StatelessWidget {
  const PagamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Método de Pagamento",
          style: TextStyle(
            color: darkBlue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 10),

          const Text(
            "Selecione uma forma de pagamento:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 20),

          _opcaoPagamento(
            context,
            icon: Icons.credit_card,
            titulo: "Cartão de Crédito",
            subtitulo: "Visa, MasterCard, Elo...",
            accent: accent,
          ),

          _opcaoPagamento(
            context,
            icon: Icons.account_balance,
            titulo: "Débito Bancário",
            subtitulo: "Itaú, Bradesco, Caixa...",
            accent: accent,
          ),

          _opcaoPagamento(
            context,
            icon: Icons.pix,
            titulo: "PIX",
            subtitulo: "Pagamento instantâneo",
            accent: accent,
          ),

          const SizedBox(height: 40),

          // BOTÃO DE CANCELAR
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: darkBlue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // WIDGET DA OPÇÃO DE PAGAMENTO
  // -------------------------
  Widget _opcaoPagamento(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Color accent,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: accent),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          // Apenas SIMULA o pagamento
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Pagamento iniciado"),
              content: Text(
                  "Simulação de pagamento usando:\n\n$titulo\n\nIsso é apenas uma demonstração."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fechar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

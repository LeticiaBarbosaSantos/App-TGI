import 'package:flutter/material.dart';

class PagamentoSimuladoScreen extends StatelessWidget {
  const PagamentoSimuladoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text(
          "Pagamento",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecione a forma de pagamento:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // --- PIX ---
            _opcaoPagamento(
              icon: Icons.qr_code_2,
              titulo: "PIX",
              descricao: "Pagamento instantâneo",
            ),

            const SizedBox(height: 10),

            // --- Cartão ---
            _opcaoPagamento(
              icon: Icons.credit_card,
              titulo: "Cartão de Crédito",
              descricao: "Visa, Mastercard",
            ),

            const SizedBox(height: 10),

            // --- Dinheiro ---
            _opcaoPagamento(
              icon: Icons.attach_money,
              titulo: "Dinheiro",
              descricao: "Pagar direto no caixa",
            ),

            const Spacer(),

            // BOTÕES
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: darkBlue, width: 2),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 18, color: darkBlue),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/identificacao_concluida");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                    ),
                    child: const Text(
                      "Confirmar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _opcaoPagamento({
    required IconData icon,
    required String titulo,
    required String descricao,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 35, color: Color(0xFF07142B)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                descricao,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              )
            ],
          ),
        ],
      ),
    );
  }
}

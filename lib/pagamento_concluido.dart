import 'package:flutter/material.dart';
import 'botao_menu.dart';

class PagamentoConcluidoScreen extends StatelessWidget {
  const PagamentoConcluidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      bottomNavigationBar: const BotaoMenu(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, size: 130, color: accent),
            SizedBox(height: 20),
            Text(
              "Pagamento concluído!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

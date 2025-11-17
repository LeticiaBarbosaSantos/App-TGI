import 'package:flutter/material.dart';

class SuccessIdentificacaoScreen extends StatelessWidget {
  const SuccessIdentificacaoScreen({super.key});

  // Paleta
  static const darkBlue = Color(0xFF07142B);
  static const teal = Color(0xFF326D6C);
  static const accent = Color(0xFF568F7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Topo fundo azul escuro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 120, bottom: 70),
            decoration: const BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                // Ícone grande indicando sucesso
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                    border: Border.all(color: accent, width: 4),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Identificação Concluída!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    "Sua identidade foi confirmada com sucesso. Agora você pode continuar para sua experiência de compras.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 70),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // Aqui você decide para onde deseja ir:
                  Navigator.pop(context); // Ou menu, carrinho, etc.
                },
                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "SmartPay • Segurança Inteligente",
              style: TextStyle(
                fontSize: 14,
                color: darkBlue.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

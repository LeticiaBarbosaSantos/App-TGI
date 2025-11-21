import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'botao_menu.dart';
=======
import 'menu.dart';
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9

class IdentificacaoScreen extends StatelessWidget {
  const IdentificacaoScreen({super.key});

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color teal = Color(0xFF326D6C);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),
=======
  static const darkBlue = Color(0xFF07142B);
  static const teal = Color(0xFF326D6C);
  static const accent = Color(0xFF568F7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9

      body: Column(
        children: [
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
              children: const [
                Icon(Icons.pan_tool_alt, size: 100, color: Colors.white),
                SizedBox(height: 30),
                Text(
                  "Identificação",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
<<<<<<< HEAD
                    "Aproxime sua palma da mão ao leitor para iniciar.",
=======
                    "Aproxime sua palma da mão ao leitor para iniciar a identificação.",
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
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

          const SizedBox(height: 60),

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
<<<<<<< HEAD
                  Navigator.pushNamed(context, '/identificacao_concluida');
=======
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
                },
                child: const Text(
                  "Iniciar identificação",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          TextButton(
<<<<<<< HEAD
            onPressed: () {
              Navigator.pushNamed(context, '/qrcode');
            },
=======
            onPressed: () {},
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
            child: const Text(
              "Entrar com QR Code",
              style: TextStyle(
                color: teal,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
<<<<<<< HEAD
=======

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              "Tecnologia de identificação SmartPay",
              style: TextStyle(
                fontSize: 13,
                color: darkBlue,
              ),
            ),
          )
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
        ],
      ),
    );
  }
}

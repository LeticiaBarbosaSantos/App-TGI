import 'package:flutter/material.dart';
import 'menu.dart';

class IdentificacaoScreen extends StatelessWidget {
  const IdentificacaoScreen({super.key});

  static const darkBlue = Color(0xFF07142B);
  static const teal = Color(0xFF326D6C);
  static const accent = Color(0xFF568F7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                    "Aproxime sua palma da mão ao leitor para iniciar a identificação.",
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
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
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
            onPressed: () {},
            child: const Text(
              "Entrar com QR Code",
              style: TextStyle(
                color: teal,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'botao_menu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
=======

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
<<<<<<< HEAD
=======
    const Color teal = Color(0xFF326D6C);
    const Color lightGreen = Color(0xFF85B093);
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,
<<<<<<< HEAD
      bottomNavigationBar: const BotaoMenu(),

=======
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 60),
            decoration: const BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
<<<<<<< HEAD
              children: const [
                Icon(Icons.pan_tool_alt, size: 90, color: Colors.white70),
                SizedBox(height: 20),
                Text(
=======
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
                  "SmartPay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
<<<<<<< HEAD
                SizedBox(height: 10),
                Padding(
=======
                const SizedBox(height: 10),
                const Padding(
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Entre, identifique-se e pague usando sua palma da mão.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 45),

<<<<<<< HEAD
=======
          // Botão principal
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
<<<<<<< HEAD
                onPressed: () {
                  Navigator.pushNamed(context, '/identificacao');
                },
=======
                onPressed: () {},
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
                child: const Text(
                  "Criar conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextButton(
<<<<<<< HEAD
            onPressed: () {
              Navigator.pushNamed(context, '/identificacao');
            },
=======
            onPressed: () {},
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
            child: const Text(
              "Já tenho uma conta",
              style: TextStyle(
                color: darkBlue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
<<<<<<< HEAD
=======

      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(icon: Icons.home, label: "Home"),
            _NavItem(icon: Icons.location_on, label: "Locais"),
            _NavItem(icon: Icons.help_outline, label: "Ajuda"),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const Color color = Color(0xFF326D6C);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26, color: color),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
    );
  }
}

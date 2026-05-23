import 'package:flutter/material.dart';

class BotaoMenu extends StatelessWidget {
  final String rotaAtual; // <-- Criamos a variável aqui

  const BotaoMenu({super.key, required this.rotaAtual});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          // HOME
          _menuButton(
            context,
            route: "/home",
            icon: Icons.home,
            label: "Home",
            active: rotaAtual == "/home", // Compara com a variável exata
            activeColor: accent,
            inactiveColor: darkBlue,
          ),

          // PERFIL
          _menuButton(
            context,
            route: "/perfil",
            icon: Icons.person,
            label: "Perfil",
            active: rotaAtual == "/perfil", // Compara com a variável exata
            activeColor: accent,
            inactiveColor: darkBlue,
          ),

          // CARRINHO
          _menuButton(
            context,
            route: "/carrinho",
            icon: Icons.shopping_cart,
            label: "Carrinho",
            active: rotaAtual == "/carrinho", // Compara com a variável exata
            activeColor: accent,
            inactiveColor: darkBlue,
          ),

          // QR CODE
          _menuButton(
            context,
            route: "/qrcode",
            icon: Icons.qr_code_scanner,
            label: "QR Code",
            active: rotaAtual == "/qrcode", // Compara com a variável exata
            activeColor: accent,
            inactiveColor: darkBlue,
          ),
        ],
      ),
    );
  }

  Widget _menuButton(
      BuildContext context, {
        required String route,
        required IconData icon,
        required String label,
        required bool active,
        required Color activeColor,
        required Color inactiveColor,
      }) {
    return GestureDetector(
      onTap: () {
        // Só navega se o botão clicado for diferente da tela atual
        if (rotaAtual != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: active ? activeColor : inactiveColor),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? activeColor : inactiveColor,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
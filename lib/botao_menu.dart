import 'package:flutter/material.dart';

class BotaoMenu extends StatelessWidget {
  const BotaoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const Color teal = Color(0xFF326D6C);

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavItem(icon: Icons.home, label: "Home", route: "/menu"),
          _NavItem(icon: Icons.shopping_cart, label: "Carrinho", route: "/carrinho"),
          _NavItem(icon: Icons.qr_code_scanner, label: "QR Code", route: "/qrcode"),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    const Color teal = Color(0xFF326D6C);

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: teal),
          SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: teal,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

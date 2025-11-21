import 'package:flutter/material.dart';
import 'botao_menu.dart';

class CarrinhoVirtualScreen extends StatelessWidget {
  const CarrinhoVirtualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);

    return Scaffold(
      bottomNavigationBar: const BotaoMenu(),

      body: Center(
        child: Text(
          "Seu carrinho está vazio",
          style: TextStyle(
            fontSize: 20,
            color: darkBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

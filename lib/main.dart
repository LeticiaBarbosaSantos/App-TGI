import 'package:flutter/material.dart';
import 'menu.dart';
<<<<<<< HEAD
import 'carrinho_virtual.dart';
import 'identificacao.dart';
import 'identificacao_qrcode.dart';
import 'identificacao_concluida.dart';

void main() {
  runApp(const SmartPayApp());
}

class SmartPayApp extends StatelessWidget {
  const SmartPayApp({super.key});
=======

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      initialRoute: "/menu",
      routes: {
        "/menu": (context) => const MenuScreen(),
        "/carrinho": (context) => const CarrinhoVirtualScreen(),
        "/identificacao": (context) => const IdentificacaoScreen(),
        "/qrcode": (context) => const QRCodeScreen(),
        "/identificacao_concluida": (context) => const IdentificacaoConcluidaScreen(),
      },
=======
      title: "Navegação App",
      home: const HomeScreen(),
>>>>>>> 232724f60f82c587704f0a1b02a8d2a8c03e57b9
    );
  }
}

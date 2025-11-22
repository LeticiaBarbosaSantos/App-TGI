import 'package:flutter/material.dart';
import 'menu.dart'; 
import 'carrinho_virtual.dart';  
import 'identificacao.dart';
import 'identificacao_qrcode.dart';
import 'identificacao_concluida.dart';
import 'perfil.dart';

void main() {
  runApp(const SmartPayApp());
}

class SmartPayApp extends StatelessWidget {
  const SmartPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/home", 
      routes: {
        "/home": (context) => const HomeScreen(),
        "/carrinho": (context) => const CarrinhoVirtualScreen(),
        "/identificacao": (context) => const IdentificacaoScreen(),
        "/qrcode": (context) => const QRCodeScreen(),
        "/identificacao_concluida": (context) => const IdentificacaoConcluidaScreen(),
        "/perfil": (context) => const PerfilScreen(),
      },
    );
  }
}

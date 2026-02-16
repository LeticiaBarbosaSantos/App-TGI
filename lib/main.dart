import 'package:flutter/material.dart';
import 'menu.dart'; 
import 'carrinho_virtual.dart';  
import 'identificacao.dart';
import 'identificacao_qrcode.dart';
import 'pagamento_concluido.dart';
import 'perfil.dart';
import 'pagamento.dart';
import 'login.dart';
import 'cadastro.dart';

void main() {
  runApp(const SmartPayApp());
}

class SmartPayApp extends StatelessWidget {
  const SmartPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login", 
      routes: {
        "/login": (context) => const LoginScreen(),
        "/cadastro": (context) => const CadastroScreen(),
        "/home": (context) => const HomeScreen(),
        "/carrinho": (context) => const CarrinhoVirtualScreen(),
        "/identificacao": (context) => const IdentificacaoScreen(),
        "/qrcode": (context) => const QRCodeScreen(),
        "/pagamento_concluida": (context) => const PagamentoConcluidoScreen(),
        "/perfil": (context) => const PerfilScreen(),
        "/pagamento": (context) => const PagamentoScreen(),
      },
    );
  }
}

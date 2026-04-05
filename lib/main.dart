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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/login":
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case "/cadastro":
            return MaterialPageRoute(builder: (_) => const CadastroScreen());
          case "/home":
            final usuarioId = settings.arguments as int? ?? 1;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(usuarioId: usuarioId),
            );
          case "/carrinho":
            final usuarioId = settings.arguments as int? ?? 1;
            return MaterialPageRoute(
              builder: (_) => CarrinhoVirtualScreen(usuarioId: usuarioId),
            );
          case "/identificacao":
            return MaterialPageRoute(builder: (_) => const IdentificacaoScreen());
          case "/qrcode":
            return MaterialPageRoute(builder: (_) => const QRCodeScreen());
          case "/pagamento_concluida":
            return MaterialPageRoute(builder: (_) => const PagamentoConcluidoScreen());
          case "/perfil":
            return MaterialPageRoute(builder: (_) => const PerfilScreen());
          case "/pagamento":
            return MaterialPageRoute(builder: (_) => const PagamentoScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}

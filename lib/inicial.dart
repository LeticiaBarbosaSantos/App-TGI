import 'package:flutter/material.dart';

// A tela de boas-vindas do aplicativo
class InicialScreen extends StatelessWidget {
  const InicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo da tela
      backgroundColor: const Color.fromARGB(179, 255, 255, 255),

      // SafeArea evita que conteúdo fique atrás da barra superior
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24), // espaçamento interno da tela
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // espaço superior

              // Ícone grande no topo — você pode trocar por uma imagem
              Icon(
                Icons.qr_code_2,
                size: 100,
                color: Colors.green.shade700,
              ),

              const SizedBox(height: 30),

              // Título principal da tela
              const Text(
                "Bem-vindo ao TGI Market",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,          // tamanho da fonte
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // cor do texto
                ),
              ),

              const SizedBox(height: 12),

              // Texto descritivo da tela
              const Text(
                "Seu app para compras rápidas, QR Code,\nhistórico e muito mais.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              // Empurra os botões para baixo
              const Spacer(),

              // BOTÃO DE LOGIN
              SizedBox(
                width: double.infinity, // ocupa 100% da largura
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green.shade700, // cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // bordas arredondadas
                    ),
                  ),

                  // Navega para a página de login
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },

                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // BOTÃO DE CADASTRO (contorno)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Colors.green.shade700, // cor da borda
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  // Navega para a página de cadastro
                  onPressed: () {
                    Navigator.pushNamed(context, "/cadastro");
                  },

                  child: Text(
                    "Criar conta",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

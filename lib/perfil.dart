import 'package:flutter/material.dart';
import 'botao_menu.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    final String userName =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Usuário";

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(color: darkBlue),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Salvar",
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // FOTO DE PERFIL
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("assets/user.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "FOTO DO PERFIL",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 30),

            _profileField("Nome", userName),
            _profileField("Email", "usuario@email.com"),
            _profileField("Título", "Usuário SmartPay"),
            _profileField("Localização", "Brasil"),
          ],
        ),
      ),
    );
  }

  Widget _profileField(String title, String value) {
    const Color darkBlue = Color(0xFF07142B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: darkBlue),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 12),
      ],
    );
  }
}

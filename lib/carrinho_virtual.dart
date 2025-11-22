import 'package:flutter/material.dart';
import 'botao_menu.dart';

class CarrinhoVirtualScreen extends StatelessWidget {
  const CarrinhoVirtualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotaoMenu(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Carrinho",
          style: TextStyle(
            fontSize: 22,
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Itens do carrinho",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 10),

          _item("Pão francês", "R\$ 2,50"),
          _item("Café moído", "R\$ 15,00"),
          _item("Leite integral", "R\$ 6,90"),

          const SizedBox(height: 25),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/pagamento");
            },
            child: const Text(
              "Finalizar Pagamento",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          const SizedBox(height: 35),

          const Text(
            "Histórico de compras",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 10),

          _historico("Compra no Supermercado Ideal", "R\$ 42,30"),
          _historico("Padaria Central", "R\$ 12,90"),
        ],
      ),
    );
  }

  Widget _item(String nome, String preco) {
    return ListTile(
      title: Text(nome),
      trailing: Text(preco),
    );
  }


  Widget _historico(String descricao, String valor) {
    return Card(
      child: ListTile(
        title: Text(descricao),
        trailing: Text(
          valor,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
}

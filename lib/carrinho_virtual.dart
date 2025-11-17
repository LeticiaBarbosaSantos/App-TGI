import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Cores da paleta
  static const darkBlue = Color(0xFF07142B);
  static const teal = Color(0xFF326D6C);
  static const accent = Color(0xFF568F7C);
  static const light = Color(0xFF85B093);

  // Lista de produtos do carrinho
  List<CartItem> items = [
    CartItem(name: "Maçã Gala", price: 4.50, qty: 1, icon: Icons.apple),
    CartItem(name: "Arroz Branco", price: 8.90, qty: 2, icon: Icons.shopping_bag),
    CartItem(name: "Leite Integral", price: 5.20, qty: 1, icon: Icons.local_drink),
  ];

  double get total {
    return items.fold(0, (sum, item) => sum + (item.price * item.qty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _cartItem(items[index]);
              },
            ),
          ),

          // ---- Total e botão ----
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    Text(
                      "R\$ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: teal,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Finalizar Compra",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Voltar ao Menu",
                      style: TextStyle(
                        fontSize: 16,
                        color: teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Widget item do carrinho ----
  Widget _cartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: light.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Ícone ou imagem
          CircleAvatar(
            radius: 26,
            backgroundColor: teal,
            child: Icon(item.icon, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 16),

          // Nome e preço
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "R\$ ${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Controle de quantidade
          Row(
            children: [
              _qtyButton(
                icon: Icons.remove,
                color: accent,
                onTap: () {
                  setState(() {
                    if (item.qty > 1) item.qty--;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item.qty.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _qtyButton(
                icon: Icons.add,
                color: teal,
                onTap: () {
                  setState(() {
                    item.qty++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // ---- Botão de quantidade ----
  Widget _qtyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ---- Classe do item ----
class CartItem {
  String name;
  double price;
  int qty;
  IconData icon;

  CartItem({
    required this.name,
    required this.price,
    required this.qty,
    required this.icon,
  });
}

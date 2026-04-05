import 'package:flutter/material.dart';
import 'botao_menu.dart';
import 'services/api_service.dart';

class CarrinhoVirtualScreen extends StatefulWidget {
  final int usuarioId;

  const CarrinhoVirtualScreen({super.key, required this.usuarioId});

  @override
  State<CarrinhoVirtualScreen> createState() => _CarrinhoVirtualScreenState();
}

class _CarrinhoVirtualScreenState extends State<CarrinhoVirtualScreen> {
  late Future<List<Map<String, dynamic>>> _futureItens;
  late final int usuarioId;

  @override
  void initState() {
    super.initState();
    usuarioId = widget.usuarioId;
    _futureItens = ApiService.listarCarrinho(usuarioId);
  }

  Future<void> _atualizarCarrinho() async {
    setState(() {
      _futureItens = ApiService.listarCarrinho(usuarioId);
    });
  }

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
          'Carrinho',
          style: TextStyle(
            fontSize: 22,
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureItens,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Erro ao carregar o carrinho.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _atualizarCarrinho,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final itens = snapshot.data ?? [];
            final total = itens.fold<double>(0, (previousValue, item) {
              final precoTotal = item['preco_total'];
              return previousValue + (precoTotal is num ? precoTotal.toDouble() : double.parse(precoTotal.toString()));
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Itens do carrinho',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                if (itens.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Nenhum item no carrinho no momento.'),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: itens.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        final precoTotal = item['preco_total'];
                        return ListTile(
                          title: Text(item['nome'] ?? 'Produto sem nome'),
                          subtitle: Text('Quantidade: ${item['quantidade']}'),
                          trailing: Text(
                            'R\$ ${precoTotal is num ? precoTotal.toStringAsFixed(2) : double.parse(precoTotal.toString()).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Total: R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/pagamento');
                  },
                  child: const Text(
                    'Finalizar Pagamento',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Histórico de compras',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                _historico('Compra no Supermercado Ideal', 'R\$ 42,30'),
                _historico('Padaria Central', 'R\$ 12,90'),
              ],
            );
          },
        ),
      ),
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

import 'package:flutter/material.dart';
import 'botao_menu.dart';
import 'services/api_service.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final TextEditingController qrController = TextEditingController();
  bool _loading = false;
  String _mensagem = '';

  Future<void> _validarQRCode() async {
    String qrData = qrController.text.trim();

    if (qrData.isEmpty) {
      setState(() => _mensagem = 'Por favor, escaneie ou insira um QR code');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await ApiService.validarQRCode(qrData);

      if (!mounted) return;

      // QR code válido - ir para o carrinho do usuário
      setState(() => _mensagem = 'Usuário identificado!');

      Navigator.pushReplacementNamed(
        context,
        '/carrinho',
        arguments: response['usuario_id'],
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _mensagem = 'QR code inválido ou não encontrado');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      bottomNavigationBar: const BotaoMenu(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 60),
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
                  SizedBox(height: 25),
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Escaneie seu QR code personalizado para entrar no estabelecimento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: qrController,
                    enabled: !_loading,
                    decoration: InputDecoration(
                      labelText: 'Digite o código QR ou escaneie',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.qr_code, color: darkBlue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_mensagem.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _mensagem.contains('identificado')
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _mensagem,
                        style: TextStyle(
                          color: _mensagem.contains('identificado')
                            ? Colors.green
                            : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _validarQRCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Validar QR Code',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

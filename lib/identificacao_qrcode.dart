import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'botao_menu.dart';
import 'services/api_service.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String? _qrData;

  @override
  void initState() {
    super.initState();
    _gerarQRCode();
  }

  void _gerarQRCode() {
    final userId = ApiService.currentUserId;
    final userName = ApiService.currentUserName;

    if (userId != null) {
      _qrData = 'USER_ID:$userId;NAME:$userName;TIMESTAMP:${DateTime.now().millisecondsSinceEpoch}';
    } else {
      _qrData = 'ERROR:NO_USER_LOGGED_IN';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF07142B);
    const Color accent = Color(0xFF568F7C);

    return Scaffold(
      bottomNavigationBar: const BotaoMenu(rotaAtual: '/qrcode'),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
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
            Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent, width: 4),
              ),
              child: _qrData != null
                  ? QrImageView(
                      data: _qrData!,
                      version: QrVersions.auto,
                      size: 180.0,
                      backgroundColor: Colors.white,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),

            const SizedBox(height: 20),

            if (_qrData != null && _qrData!.startsWith('ERROR'))
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Erro: Nenhum usuário logado. Faça login primeiro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

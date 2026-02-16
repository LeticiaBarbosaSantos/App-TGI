import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost:8000";
  
  // ==================== AUTENTICAÇÃO ====================
  
  static Future<Map<String, dynamic>> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final erro = jsonDecode(response.body);
        throw Exception(erro['detail'] ?? 'Erro ao fazer login');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nome,
    required String email,
    required String cpf,
    required String senha,
    String? telefone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/registro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'cpf': cpf,
          'senha': senha,
          'telefone': telefone,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final erro = jsonDecode(response.body);
        throw Exception(erro['detail'] ?? 'Erro ao registrar usuário');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  // ==================== USUÁRIOS ====================
  
  static Future<Map<String, dynamic>> obterPerfil(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/perfil/$usuarioId'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<Map<String, dynamic>> atualizarPerfil({
    required int usuarioId,
    required Map<String, dynamic> dados,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/perfil/$usuarioId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao atualizar perfil');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<void> verificarRosto(int usuarioId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verificar-rosto/$usuarioId'),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Erro ao verificar rosto');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<void> verificarDocumento(int usuarioId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verificar-documento/$usuarioId'),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Erro ao verificar documento');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  // ==================== PRODUTOS ====================
  
  static Future<List<Map<String, dynamic>>> listarProdutos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/produtos'),
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao listar produtos');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  // ==================== TRANSAÇÕES ====================
  
  static Future<Map<String, dynamic>> criarTransacao({
    required int usuarioId,
    required double valor,
    required String metodoPagamento,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transacoes/criar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': usuarioId,
          'valor': valor,
          'metodo_pagamento': metodoPagamento,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao criar transação');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<Map<String, dynamic>> confirmarTransacao(int transacaoId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transacoes/$transacaoId/confirmar'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao confirmar transação');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> listarTransacoes(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transacoes/usuario/$usuarioId'),
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao listar transações');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  // ==================== RECONHECIMENTO ====================
  
  static Future<Map<String, dynamic>> processarReconhecimento({
    required int usuarioId,
    required String tipo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reconhecimento/processar?usuario_id=$usuarioId&tipo=$tipo'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro no reconhecimento');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  // ==================== HEALTH CHECK ====================
  
  static Future<bool> verificarConexao() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

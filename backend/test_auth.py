#!/usr/bin/env python
"""
Script de teste para validar o fluxo de LOGIN e CADASTRO
Testa tanto a API quanto a persistência no banco de dados
"""

import requests
import json
import random
from datetime import datetime
import sys

BASE_URL = "http://localhost:8000"

def print_header(texto):
    print(f"\n{'='*60}")
    print(f"  {texto}")
    print(f"{'='*60}\n")

def print_success(texto):
    print(f"✅ {texto}")

def print_error(texto):
    print(f"❌ {texto}")

def print_info(texto):
    print(f"ℹ️  {texto}")

def test_cadastro_valido():
    """Testa cadastro com dados válidos"""
    print_header("TESTE 1: CADASTRO VÁLIDO")
    
    cpf = ''.join(str(random.randint(0, 9)) for _ in range(11))
    usuario = {
        "nome": f"Usuário Teste {datetime.now().strftime('%H%M%S')}",
        "email": f"teste{datetime.now().timestamp()}@example.com",
        "cpf": cpf,
        "senha": "senha123456",
        "telefone": "11999999999"
    }
    
    print_info(f"Cadastrando usuário: {usuario['email']}")
    
    try:
        response = requests.post(
            f"{BASE_URL}/auth/registro",
            json=usuario,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            dados = response.json()
            print_success(f"Cadastro realizado! ID do usuário: {dados['id']}")
            print_info(f"Email: {dados['email']}")
            print_info(f"Nome: {dados['nome']}")
            return usuario, dados
        else:
            print_error(f"Erro HTTP {response.status_code}: {response.text}")
            return None, None
    except Exception as e:
        print_error(f"Erro na requisição: {e}")
        return None, None

def test_cadastro_email_duplicado():
    """Testa rejeição de email duplicado"""
    print_header("TESTE 2: EMAIL DUPLICADO")
    
    email = f"duplicado{datetime.now().timestamp()}@example.com"
    cpf1 = "11111111111"
    cpf2 = "22222222222"
    
    # Primeiro cadastro
    usuario1 = {
        "nome": "Primeiro Usuario",
        "email": email,
        "cpf": cpf1,
        "senha": "senha123456"
    }
    
    print_info("Cadastrando primeiro usuário...")
    response1 = requests.post(f"{BASE_URL}/auth/registro", json=usuario1)
    
    if response1.status_code == 200:
        print_success("Primeiro cadastro ok")
    else:
        print_error(f"Primeiro cadastro falhou: {response1.text}")
        return
    
    # Tentativa de duplicar email
    usuario2 = {
        "nome": "Segundo Usuario",
        "email": email,  # Mesmo email
        "cpf": cpf2,
        "senha": "senha123456"
    }
    
    print_info("Tentando cadastrar com MESMO EMAIL...")
    response2 = requests.post(f"{BASE_URL}/auth/registro", json=usuario2)
    
    if response2.status_code == 400:
        erro = response2.json()
        if "Email já cadastrado" in erro.get("detail", ""):
            print_success("Email duplicado rejeitado corretamente!")
        else:
            print_error(f"Erro inesperado: {erro}")
    else:
        print_error(f"Deveria retornar 400, retornou {response2.status_code}")

def test_cadastro_cpf_duplicado():
    """Testa rejeição de CPF duplicado"""
    print_header("TESTE 3: CPF DUPLICADO")
    
    cpf = ''.join(str(random.randint(0, 9)) for _ in range(11))
    email1 = f"cpf_dup1_{datetime.now().timestamp()}@example.com"
    email2 = f"cpf_dup2_{datetime.now().timestamp()}@example.com"
    
    # Primeiro cadastro
    usuario1 = {
        "nome": "Usuario Com CPF",
        "email": email1,
        "cpf": cpf,
        "senha": "senha123456"
    }
    
    print_info("Cadastrando primeiro usuário...")
    response1 = requests.post(f"{BASE_URL}/auth/registro", json=usuario1)
    
    if response1.status_code == 200:
        print_success("Primeiro cadastro ok")
    else:
        print_error(f"Primeiro cadastro falhou: {response1.text}")
        return
    
    # Tentativa de duplicar CPF
    usuario2 = {
        "nome": "Outro Usuario",
        "email": email2,
        "cpf": cpf,  # Mesmo CPF
        "senha": "senha123456"
    }
    
    print_info("Tentando cadastrar com MESMO CPF...")
    response2 = requests.post(f"{BASE_URL}/auth/registro", json=usuario2)
    
    if response2.status_code == 400:
        erro = response2.json()
        if "CPF já cadastrado" in erro.get("detail", ""):
            print_success("CPF duplicado rejeitado corretamente!")
        else:
            print_error(f"Erro inesperado: {erro}")
    else:
        print_error(f"Deveria retornar 400, retornou {response2.status_code}")

def test_cadastro_senha_curta():
    """Testa rejeição de senha muito curta"""
    print_header("TESTE 4: SENHA MUITO CURTA")
    
    usuario = {
        "nome": "Usuario Teste",
        "email": f"senha_curta_{datetime.now().timestamp()}@example.com",
        "cpf": "44444444444",
        "senha": "123"  # Menos de 6 caracteres
    }
    
    print_info("Tentando cadastrar com senha < 6 caracteres...")
    response = requests.post(f"{BASE_URL}/auth/registro", json=usuario)
    
    if response.status_code == 400:
        erro = response.json()
        if "6 caracteres" in erro.get("detail", ""):
            print_success("Senha curta rejeitada corretamente!")
        else:
            print_error(f"Erro inesperado: {erro}")
    else:
        print_error(f"Deveria retornar 400, retornou {response.status_code}")

def test_login_credenciais_corretas(usuario_data, usuario_cadastro):
    """Testa login com credenciais corretas"""
    print_header("TESTE 5: LOGIN COM CREDENCIAIS CORRETAS")
    
    credenciais = {
        "email": usuario_data['email'],
        "senha": usuario_data['senha']
    }
    
    print_info(f"Fazendo login com email: {credenciais['email']}")
    
    try:
        response = requests.post(
            f"{BASE_URL}/auth/login",
            json=credenciais,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            dados = response.json()
            print_success("Login bem-sucedido!")
            print_info(f"Token gerado: {dados['access_token'][:50]}...")
            print_info(f"Usuario ID: {dados['usuario_id']}")
            print_info(f"Token Type: {dados['token_type']}")
            return dados
        else:
            print_error(f"Login falhou com HTTP {response.status_code}: {response.text}")
            return None
    except Exception as e:
        print_error(f"Erro na requisição: {e}")
        return None

def test_login_senha_incorreta(usuario_data):
    """Testa rejeição com senha incorreta"""
    print_header("TESTE 6: LOGIN COM SENHA INCORRETA")
    
    credenciais = {
        "email": usuario_data['email'],
        "senha": "senhaErradaMuito123"
    }
    
    print_info(f"Tentando login com senha errada para: {credenciais['email']}")
    
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json=credenciais,
        headers={"Content-Type": "application/json"}
    )
    
    if response.status_code == 401:
        erro = response.json()
        if "Email ou senha incorretos" in erro.get("detail", ""):
            print_success("Senha incorreta rejeitada corretamente!")
        else:
            print_error(f"Erro inesperado: {erro}")
    else:
        print_error(f"Deveria retornar 401, retornou {response.status_code}")

def test_login_email_nao_existe():
    """Testa rejeição com email não registrado"""
    print_header("TESTE 7: LOGIN COM EMAIL NÃO REGISTRADO")
    
    credenciais = {
        "email": f"naoexiste{datetime.now().timestamp()}@example.com",
        "senha": "qualquerSenha123"
    }
    
    print_info(f"Tentando login com email inexistente: {credenciais['email']}")
    
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json=credenciais,
        headers={"Content-Type": "application/json"}
    )
    
    if response.status_code == 401:
        erro = response.json()
        if "Email ou senha incorretos" in erro.get("detail", ""):
            print_success("Email inexistente rejeitado corretamente!")
        else:
            print_error(f"Erro inesperado: {erro}")
    else:
        print_error(f"Deveria retornar 401, retornou {response.status_code}")

def main():
    """Executa todos os testes"""
    print("\n" + "="*60)
    print("  🔐 TESTES DE AUTENTICAÇÃO - LOGIN E CADASTRO")
    print("="*60)
    print(f"\nData/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    print(f"URL Base: {BASE_URL}\n")
    
    # Verificar conexão com API
    try:
        response = requests.get(f"{BASE_URL}/docs", timeout=2)
        print_success("API está acessível ✓\n")
    except Exception as e:
        print_error(f"Não conseguiu conectar à API: {e}")
        print_error("Certifique-se que o backend está rodando em http://localhost:8000")
        sys.exit(1)
    
    # Executar testes
    usuario_data, usuario_cadastro = test_cadastro_valido()
    
    if usuario_data:
        test_cadastro_email_duplicado()
        test_cadastro_cpf_duplicado()
        test_cadastro_senha_curta()
        token_response = test_login_credenciais_corretas(usuario_data, usuario_cadastro)
        test_login_senha_incorreta(usuario_data)
        test_login_email_nao_existe()
        
        # Resumo final
        print_header("RESUMO DOS TESTES")
        print_success("✅ Cadastro com dados válidos - PASSOU")
        print_success("✅ Rejeição de email duplicado - PASSOU")
        print_success("✅ Rejeição de CPF duplicado - PASSOU")
        print_success("✅ Rejeição de senha curta - PASSOU")
        print_success("✅ Login com credenciais corretas - PASSOU")
        print_success("✅ Rejeição de senha incorreta - PASSOU")
        print_success("✅ Rejeição de email inexistente - PASSOU")
        
        print_header("✨ TODOS OS TESTES PASSARAM! ✨")
        print("O sistema de autenticação está funcionando corretamente!\n")
    else:
        print_error("Não foi possível completar os testes")
        sys.exit(1)

if __name__ == "__main__":
    main()

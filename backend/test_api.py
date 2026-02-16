#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script para testar a API localmente
Execute: python test_api.py
"""

from fastapi.testclient import TestClient
from main import app
from database import SessionLocal
from models import Usuario
import json

client = TestClient(app)

print("=" * 60)
print("TESTE DE AUTENTICACAO - SmartPay API")
print("=" * 60)

# ==================== TESTE 1: CADASTRO ====================
print("\n[OK] TESTE 1: CADASTRO DE NOVO USUARIO")
print("-" * 60)

usuario_cadastro = {
    "nome": "Joao Silva",
    "email": "joao@test.com",
    "cpf": "12345678901",
    "senha": "senha123",
    "telefone": "11987654321",
    "data_nascimento": "1995-05-15"
}

print(f"Enviando: {json.dumps(usuario_cadastro, indent=2)}")
response = client.post("/auth/registro", json=usuario_cadastro)
print(f"Status: {response.status_code}")
print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")

if response.status_code == 200:
    usuario_id = response.json()["id"]
    print(f"[OK] Usuario criado com ID: {usuario_id}")
else:
    print(f"[ERRO] {response.json()}")
    usuario_id = None

# ==================== TESTE 2: LOGIN COM SUCESSO ====================
print("\n[OK] TESTE 2: LOGIN COM SUCESSO")
print("-" * 60)

login_dados = {
    "email": "joao@test.com",
    "senha": "senha123"
}

print(f"Enviando: {json.dumps(login_dados, indent=2)}")
response = client.post("/auth/login", json=login_dados)
print(f"Status: {response.status_code}")
resposta_json = response.json()
print(f"Resposta: {json.dumps(resposta_json, indent=2, default=str)}")

if response.status_code == 200:
    token = resposta_json["access_token"]
    print(f"[OK] Login bem-sucedido!")
    print(f"Token: {token[:50]}...")
else:
    print(f"[ERRO] {resposta_json}")

# ==================== TESTE 3: LOGIN COM SENHA ERRADA ====================
print("\n[OK] TESTE 3: LOGIN COM SENHA ERRADA")
print("-" * 60)

login_errado = {
    "email": "joao@test.com",
    "senha": "senhaErrada123"
}

print(f"Enviando: {json.dumps(login_errado, indent=2)}")
response = client.post("/auth/login", json=login_errado)
print(f"Status: {response.status_code}")
print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")

if response.status_code == 401:
    print(f"[OK] Sistema bloqueou corretamente!")
else:
    print(f"[ERRO] Seguranca comprometida!")

# ==================== TESTE 4: OBTER PERFIL ====================
if usuario_id:
    print("\n[OK] TESTE 4: OBTER PERFIL DO USUARIO")
    print("-" * 60)
    
    response = client.get(f"/auth/perfil/{usuario_id}")
    print(f"Status: {response.status_code}")
    print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")
    
    if response.status_code == 200:
        print(f"[OK] Perfil obtido com sucesso!")
    else:
        print(f"[ERRO] {response.json()}")

# ==================== TESTE 5: ATUALIZAR PERFIL ====================
if usuario_id:
    print("\n[OK] TESTE 5: ATUALIZAR PERFIL")
    print("-" * 60)
    
    updates = {
        "nome": "Joao da Silva",
        "telefone": "11999999999",
        "endereco": "Rua Teste, 123",
        "numero_endereco": "123",
        "cep": "01234567",
        "cidade": "Sao Paulo",
        "estado": "SP"
    }
    
    print(f"Atualizando: {json.dumps(updates, indent=2)}")
    response = client.put(f"/auth/perfil/{usuario_id}", json=updates)
    print(f"Status: {response.status_code}")
    print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")
    
    if response.status_code == 200:
        print(f"[OK] Perfil atualizado com sucesso!")
    else:
        print(f"[ERRO] {response.json()}")

# ==================== TESTE 6: VERIFICAR ROSTO ====================
if usuario_id:
    print("\n[OK] TESTE 6: VERIFICAR ROSTO")
    print("-" * 60)
    
    response = client.post(f"/auth/verificar-rosto/{usuario_id}")
    print(f"Status: {response.status_code}")
    print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")
    
    if response.status_code == 200:
        print(f"[OK] Rosto marcado como verificado!")
    else:
        print(f"[ERRO] {response.json()}")

# ==================== TESTE 7: VERIFICAR EMAIL ====================
if usuario_id:
    print("\n[OK] TESTE 7: VERIFICAR EMAIL")
    print("-" * 60)
    
    response = client.post(f"/auth/verificar-email/{usuario_id}")
    print(f"Status: {response.status_code}")
    print(f"Resposta: {json.dumps(response.json(), indent=2, default=str)}")
    
    if response.status_code == 200:
        print(f"[OK] Email marcado como verificado!")
    else:
        print(f"[ERRO] {response.json()}")

# ==================== TESTE 8: OBTER PERFIL COM VERIFICACOES ====================
if usuario_id:
    print("\n[OK] TESTE 8: VERIFICAR ATUALIZACOES DE VERIFICACAO")
    print("-" * 60)
    
    response = client.get(f"/auth/perfil/{usuario_id}")
    perfil = response.json()
    print(f"Email verificado: {perfil['email_verificado']}")
    print(f"Rosto verificado: {perfil['rosto_verificado']}")
    print(f"Documento verificado: {perfil['documento_verificado']}")

# ==================== TESTE 9: HEALTH CHECK ====================
print("\n[OK] TESTE 9: HEALTH CHECK")
print("-" * 60)

response = client.get("/health")
print(f"Status: {response.status_code}")
print(f"Resposta: {json.dumps(response.json(), indent=2)}")

if response.status_code == 200:
    print(f"[OK] API esta online!")

print("\n" + "=" * 60)
print("TESTES CONCLUIDOS!")
print("=" * 60)

# Verificar banco de dados
print("\nDADOS NO BANCO:")
print("-" * 60)

db = SessionLocal()
usuarios = db.query(Usuario).all()
print(f"Total de usuarios: {len(usuarios)}")
for user in usuarios:
    print(f"  - {user.nome} ({user.email}) - Email verificado: {user.email_verificado}, Rosto: {user.rosto_verificado}")
db.close()

import os
# Força o TensorFlow a usar o motor clássico (compatível com o Teachable Machine)
os.environ["TF_USE_LEGACY_KERAS"] = "1"

import cv2
import numpy as np
from tensorflow.keras.models import load_model
import requests
import time

API_URL = "http://localhost:8000"
USUARIO_ID = 1

# IDs oficiais do banco de dados
ID_REXONA = 2
ID_TENYS = 3

# Carrega o modelo de forma limpa
modelo = load_model("keras_model.h5", compile=False)

# Carrega os nomes das classes
nomes_classes = open("labels.txt", "r").readlines()

# Inicializa a webcam
camera = cv2.VideoCapture(0)

print("Sistema de Visão Computacional de Múltiplos Produtos Ativo!")
print("Pressione 'q' para encerrar.")

# Estado inicial da prateleira (assume que começa cheia)
estado_atual = None

def alterar_carrinho(acao, produto_id, nome_produto):
    """
    Função unificada para adicionar ou remover produtos.
    acao: 'adicionar' ou 'remover'
    """
    url_base = f"{API_URL}/carrinho/{USUARIO_ID}/itens"
    try:
        if acao == 'adicionar':
            print(f"\n>>> EVENTO: {nome_produto} retirado! Adicionando ao carrinho... <<<")
            resposta = requests.post(url_base, json={"produto_id": produto_id, "quantidade": 1}, timeout=3)
        elif acao == 'remover':
            print(f"\n>>> EVENTO: {nome_produto} devolvido! Removendo do carrinho... <<<")
            resposta = requests.delete(f"{url_base}/{produto_id}", timeout=3)
            
        if resposta.status_code == 200:
            print(f"✅ {nome_produto} atualizado no carrinho com sucesso.")
        else:
            print(f"❌ Falha na API ({resposta.status_code}): {resposta.text}")
    except Exception as e:
        print(f"⚠️ Erro de conexão com o backend: {e}")

while True:
    sucesso, imagem_quadro = camera.read()
    if not sucesso:
        print("Falha ao capturar a câmera.")
        break

    # Prepara a imagem para a IA do Google (224x224 pixels)
    imagem_redimensionada = cv2.resize(imagem_quadro, (224, 224), interpolation=cv2.INTER_AREA)
    imagem_array = np.asarray(imagem_redimensionada, dtype=np.float32).reshape(1, 224, 224, 3)
    imagem_array = (imagem_array / 127.5) - 1 # Normalização

    # A IA analisa a imagem
    previsao = modelo.predict(imagem_array, verbose=0)
    indice_maior_certeza = np.argmax(previsao)
    nome_classe = nomes_classes[indice_maior_certeza].strip().lower()
    confianca = previsao[0][indice_maior_certeza]

    status_texto = "Analisando..."
    cor_borda = (255, 255, 255) # Branco

    # Só toma uma decisão se a IA tiver mais de 80% de certeza, evitando oscilações
    if confianca > 0.5:
        # Traduz o nome da classe do Teachable Machine para um estado interno
        estado_detectado = None
        if "ambos" in nome_classe:
            estado_detectado = "Ambos"
            status_texto = "Prateleira Cheia"
            cor_borda = (255, 255, 0) # Ciano
        elif "rexona" in nome_classe:
            estado_detectado = "Rexona"
            status_texto = "Apenas Rexona"
            cor_borda = (0, 255, 0) # Verde
        elif "tenys" in nome_classe or "tenis" in nome_classe or "pé" in nome_classe:
            estado_detectado = "Tenys"
            status_texto = "Apenas Tenys Pe"
            cor_borda = (255, 0, 255) # Rosa
        elif "vazi" in nome_classe:
            estado_detectado = "Vazio"
            status_texto = "Prateleira Vazia"
            cor_borda = (0, 0, 255) # Vermelho

        # --- O CÉREBRO DE TRANSIÇÃO ---
        if estado_detectado and estado_detectado != estado_atual:
            
            # 1. Se a prateleira estava cheia e algo mudou:
            if estado_atual == "Ambos":
                if estado_detectado == "Rexona":
                    alterar_carrinho("adicionar", ID_TENYS, "Tenys Pé")
                elif estado_detectado == "Tenys":
                    alterar_carrinho("adicionar", ID_REXONA, "Rexona")
                elif estado_detectado == "Vazio":
                    alterar_carrinho("adicionar", ID_REXONA, "Rexona")
                    alterar_carrinho("adicionar", ID_TENYS, "Tenys Pé")

            # 2. Se só tinha o Rexona e algo mudou:
            elif estado_atual == "Rexona":
                if estado_detectado == "Ambos":
                    alterar_carrinho("remover", ID_TENYS, "Tenys Pé")
                elif estado_detectado == "Vazio":
                    alterar_carrinho("adicionar", ID_REXONA, "Rexona")

            # 3. Se só tinha o Tenys Pé e algo mudou:
            elif estado_atual == "Tenys":
                if estado_detectado == "Ambos":
                    alterar_carrinho("remover", ID_REXONA, "Rexona")
                elif estado_detectado == "Vazio":
                    alterar_carrinho("adicionar", ID_TENYS, "Tenys Pé")

            # 4. Se a prateleira estava vazia e algo foi devolvido:
            elif estado_atual == "Vazio":
                if estado_detectado == "Rexona":
                    alterar_carrinho("remover", ID_REXONA, "Rexona")
                elif estado_detectado == "Tenys":
                    alterar_carrinho("remover", ID_TENYS, "Tenys Pé")
                elif estado_detectado == "Ambos":
                    alterar_carrinho("remover", ID_REXONA, "Rexona")
                    alterar_carrinho("remover", ID_TENYS, "Tenys Pé")

            # Atualiza a memória da IA para o novo estado
            estado_atual = estado_detectado
            time.sleep(1) # Pausa de 1 segundo para evitar chamadas duplas rápidas na API

    # Interface Visual
    cv2.putText(imagem_quadro, status_texto, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, cor_borda, 2)
    cv2.putText(imagem_quadro, f"Certeza: {confianca*100:.0f}%", (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 0), 2)
    cv2.imshow("Monitoramento de Varejo Autonomo", imagem_quadro)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

camera.release()
cv2.destroyAllWindows()
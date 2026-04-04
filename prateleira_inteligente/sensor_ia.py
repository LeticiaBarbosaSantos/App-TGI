import os
# --- A MÁGICA ---
# Força o TensorFlow a usar o motor clássico (compatível com o Teachable Machine)
os.environ["TF_USE_LEGACY_KERAS"] = "1"

import cv2
import numpy as np
from tensorflow.keras.models import load_model

# Carrega o modelo de forma limpa
modelo = load_model("keras_model.h5", compile=False)

# Carrega os nomes das classes (ex: 0 Rexona, 1 Vazio)
nomes_classes = open("labels.txt", "r").readlines()

# Inicializa a webcam
camera = cv2.VideoCapture(0)

print("Sistema de Visão Computacional Ativo!")
print("Pressione 'q' para encerrar.")

produto_na_prateleira = True

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
    nome_classe = nomes_classes[indice_maior_certeza].strip()
    confianca = previsao[0][indice_maior_certeza]

    # --- LÓGICA DE DETECÇÃO ---
    # IMPORTANTE: Se os seus nomes no Teachable Machine forem diferentes, ajuste aqui!
    # --- LÓGICA DE DETECÇÃO ---
    if "Rexona" in nome_classe and confianca > 0.8:
        status_texto = "PRODUTO DETECTADO: Rexona na prateleira"
        cor_borda = (0, 255, 0) # Verde
        produto_na_prateleira = True
        
    elif "Vazia" in nome_classe and confianca > 0.8:
        status_texto = "ALERTA: Prateleira vazia! Produto no carrinho."
        cor_borda = (0, 0, 255) # Vermelho
        
        # O gatilho para o Firebase (só aciona no momento que tira)
        if produto_na_prateleira:
            print("\n>>> EVENTO: Rexona retirado! Enviando para o App... <<<\n")
            produto_na_prateleira = False
            
    elif "ruídos" in nome_classe or "Mão" in nome_classe:
        status_texto = "Movimento detectado..."
        cor_borda = (0, 255, 255) # Amarelo (Fica aguardando a mão sair)
            
    else:
        status_texto = "Analisando..."
        cor_borda = (255, 255, 255) # Branco

    # Desenha o status na tela
    cv2.putText(imagem_quadro, status_texto, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, cor_borda, 2)
    cv2.imshow("Monitoramento de Varejo Autonomo - TGI 2", imagem_quadro)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

camera.release()
cv2.destroyAllWindows()

# Desenha o status na tela
cv2.putText(imagem_quadro, status_texto, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, cor_borda, 2)
    
# --- LINHA NOVA PARA DEBUG ---
cv2.putText(imagem_quadro, f"Certeza da IA: {nome_classe} - {confianca*100:.0f}%", (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 0), 2)
    
cv2.imshow("Monitoramento de Varejo Autonomo - TGI 2", imagem_quadro)
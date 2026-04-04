import cv2 # Importa a biblioteca de visão computacional (OpenCV)

# Configura o acesso à webcam (0 geralmente é a câmera padrão do notebook)
video_captura = cv2.VideoCapture(0)

# Verifica se a câmera abriu corretamente
if not video_captura.isOpened():
    print("Erro: Não foi possível acessar a câmera do notebook.")
    exit()

print("Monitoramento da prateleira iniciado!")
print("Dica: Clique na janela da imagem e aperte 'q' para encerrar.")

while True:
    # 'sucesso' será verdadeiro se a câmera capturar a imagem
    # 'frame' é a imagem (quadro) atual capturada pela câmera
    sucesso, imagem_quadro = video_captura.read()

    # Se houver uma falha na captura, encerra o loop
    if not sucesso:
        print("Erro ao receber imagem da webcam.")
        break

    # --- ESPAÇO PARA A LÓGICA DE DETECÇÃO (FASE 2) ---
    # Aqui é onde vamos verificar se o produto saiu da frente do sensor
    
    # Exibe a imagem em uma janela chamada 'Sistema de Automação de Varejo'
    cv2.imshow('Sistema de Automacao de Varejo - TGI 2', imagem_quadro)

    # O comando waitKey(1) espera 1 milissegundo por uma tecla
    # Se a tecla 'q' (de quit/sair) for pressionada, interrompe o monitoramento
    if cv2.waitKey(1) & 0xFF == ord('q'):
        print("Encerrando o monitoramento...")
        break

# Ao sair do loop, precisamos 'soltar' a câmera para outros apps usarem
video_captura.release()

# Fecha todas as janelas que o Python abriu
cv2.destroyAllWindows()
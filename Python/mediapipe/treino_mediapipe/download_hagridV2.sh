#!/bin/bash

# ============================================================
# HaGRIDv2 - Download Dataset (V2 Otimizado e Agnóstico)
# ============================================================

set -u

# ------------------------------------------------------------
# CONFIGURAÇÕES
# ------------------------------------------------------------

MAX_PARALLEL=15
MAX_RETRIES=5
TOTAL_IMAGES=2000

BASE_DIR="/home/jplop/Documents"
REMOTEZIP="/home/jplop/Documents/venv_utils/bin/remotezip"
URL_BASE="https://rndml-team-cv.obs.ru-moscow-1.hc.sbercloud.ru/datasets/hagrid_v2/hagrid_v2_zip"

# ------------------------------------------------------------
# CORES E CLEANUP
# ------------------------------------------------------------

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

count_images() {
    find "$DEST_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l
}

cleanup() {
    trap - INT TERM
    echo
    echo -e "${YELLOW}Cancelando download... Por favor, aguarde.${NC}"
    kill -- -$$ 2>/dev/null || true
    wait 2>/dev/null || true
    echo -e "${GREEN}Download cancelado com segurança.${NC}"
    exit 130
}

trap cleanup INT TERM

# ------------------------------------------------------------
# CABEÇALHO E SETUP
# ------------------------------------------------------------

clear
echo "============================================"
echo "       HaGRIDv2 - Download Dataset"
echo "============================================"
echo "Downloads simultâneos: $MAX_PARALLEL"
echo

read -rp "Digite o nome do gesto: " GESTURE

if [[ -z "$GESTURE" ]]; then
    echo -e "${RED}Erro: nenhum gesto informado.${NC}"
    exit 1
fi

DEST_DIR="$BASE_DIR/$GESTURE"
LIST_FILE="$DEST_DIR/arquivos.txt"
mkdir -p "$DEST_DIR"
ZIP_URL="$URL_BASE/$GESTURE.zip"

# ------------------------------------------------------------
# GERAR LISTA DE ARQUIVOS (Blindado para V2)
# ------------------------------------------------------------

if [[ -f "$LIST_FILE" ]]; then
    echo "Lista de arquivos já existe. Usando lista existente."
else
    echo "Lista não encontrada. Mapeando o ZIP da V2..."
    echo
    "$REMOTEZIP" -l "$ZIP_URL" > "$DEST_DIR/zip_listing.txt"

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erro ao obter lista do ZIP. Verifique se o gesto existe no servidor.${NC}"
        exit 1
    fi

    # Pega o caminho original exato de dentro do ZIP
    grep -E '\.jpg$|\.jpeg$|\.png$' "$DEST_DIR/zip_listing.txt" \
        | awk '{print $NF}' \
        | head -n "$TOTAL_IMAGES" \
        > "$LIST_FILE"

    rm -f "$DEST_DIR/zip_listing.txt"
fi

TOTAL=$(wc -l < "$LIST_FILE")
echo -e "${GREEN}Encontradas $TOTAL imagens na lista.${NC}"
echo

# ------------------------------------------------------------
# FUNÇÃO DE DOWNLOAD
# ------------------------------------------------------------

download_one() {
    local FILE_IN_ZIP="$1"
    local INDEX="$2"
    local BASENAME="$3"
    local OUTPUT="$4"
    
    local ATTEMPT=1

    while [[ $ATTEMPT -le $MAX_RETRIES ]]; do
        # Extrai no diretório de destino usando a estrutura que estiver no ZIP
        "$REMOTEZIP" -d "$DEST_DIR" "$ZIP_URL" "$FILE_IN_ZIP" >/dev/null 2>&1
        STATUS=$?

        # Se o remotezip criou subpastas indesejadas, jogamos a imagem para a raiz do destino
        if [[ -f "$DEST_DIR/$FILE_IN_ZIP" && "$DEST_DIR/$FILE_IN_ZIP" != "$OUTPUT" ]]; then
            mv "$DEST_DIR/$FILE_IN_ZIP" "$OUTPUT" 2>/dev/null
        fi

        if [[ $STATUS -eq 0 && -f "$OUTPUT" && -s "$OUTPUT" ]]; then
            echo -e "${GREEN}[OK] [$INDEX/$TOTAL] $BASENAME${NC}"
            return 0
        fi

        echo -e "${YELLOW}[RETRY] [$INDEX/$TOTAL] tentativa $ATTEMPT/$MAX_RETRIES - $BASENAME${NC}"
        rm -f "$OUTPUT" "$DEST_DIR/$FILE_IN_ZIP" 2>/dev/null
        sleep 1
        ((ATTEMPT++))
    done

    echo -e "${RED}[ERRO] [$INDEX/$TOTAL] Falha ao baixar $BASENAME após $MAX_RETRIES tentativas.${NC}"
    return 1
}

# ------------------------------------------------------------
# INÍCIO DO DOWNLOAD
# ------------------------------------------------------------

echo "Iniciando download em PARALELO..."
echo

START_TIME=$(date +%s)
INDEX=0

while IFS= read -r FILE_LINE; do
    ((INDEX++))
    
    BASENAME=$(basename "$FILE_LINE")
    OUTPUT="$DEST_DIR/$BASENAME"
    
    # Agora a variável usa o caminho exato e dinâmico da V2
    FILE_IN_ZIP="$FILE_LINE"

    if [[ -f "$OUTPUT" && -s "$OUTPUT" ]]; then
        echo -e "${NC}[SKIP] [$INDEX/$TOTAL] $BASENAME${NC}"
        continue
    fi

    download_one "$FILE_IN_ZIP" "$INDEX" "$BASENAME" "$OUTPUT" &

    while [[ $(jobs -r -p | wc -l) -ge $MAX_PARALLEL ]]; do
        sleep 0.2
    done
done < "$LIST_FILE"

wait

# ------------------------------------------------------------
# RESULTADO FINAL
# ------------------------------------------------------------

END_TIME=$(date +%s)
FINAL_COUNT=$(count_images)

echo
echo "============================================"
echo "              DOWNLOAD FINALIZADO"
echo "============================================"
echo "Gesto:                 $GESTURE"
echo "Esperadas:             $TOTAL_IMAGES"
echo "No disco:              $FINAL_COUNT"
echo "Tempo:                 $((END_TIME - START_TIME))s"

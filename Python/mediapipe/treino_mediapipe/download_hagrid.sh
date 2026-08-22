#!/bin/bash

# ============================================================
# HaGRIDv2 - Download Dataset (Paralelo Otimizado)
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
URL_BASE="https://rndml-team-cv.obs.ru-moscow-1.hc.sbercloud.ru/datasets/hagrid/hagrid_dataset_new_554800/hagrid_dataset"

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ------------------------------------------------------------
# FUNÇÕES GERAIS
# ------------------------------------------------------------

count_images() {
    find "$DEST_DIR" \
        -maxdepth 1 \
        -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
        | wc -l
}

cleanup() {
    # Desativa o trap para evitar múltiplas chamadas por processos filhos
    trap - INT TERM
    echo
    echo -e "${YELLOW}Cancelando download... Por favor, aguarde.${NC}"
    
    # Mata silenciosamente o grupo de processos atual (script principal + todos os filhos)
    kill -- -$$ 2>/dev/null || true
    wait 2>/dev/null || true
    
    echo -e "${GREEN}Download cancelado com segurança.${NC}"
    exit 130
}

# Associa o Ctrl+C ao cleanup
trap cleanup INT TERM

# ------------------------------------------------------------
# CABEÇALHO E SETUP
# ------------------------------------------------------------

clear
echo "============================================"
echo "       HaGRIDv2 - Download Dataset"
echo "============================================"
echo "Downloads simultâneos: $MAX_PARALLEL"
echo "Máximo de tentativas:  $MAX_RETRIES"
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

echo
echo "Gesto:       $GESTURE"
echo "Destino:     $DEST_DIR"
echo "Quantidade:  $TOTAL_IMAGES imagens"
echo

# ------------------------------------------------------------
# GERAR LISTA DE ARQUIVOS
# ------------------------------------------------------------

if [[ -f "$LIST_FILE" ]]; then
    echo "Lista de arquivos já existe. Usando lista existente."
else
    echo "Lista de arquivos não encontrada. Obtendo lista do ZIP..."
    echo

    "$REMOTEZIP" -l "$ZIP_URL" > "$DEST_DIR/zip_listing.txt"

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Erro ao obter lista do ZIP.${NC}"
        exit 1
    fi

    # Extrai a lista corretamente limitando ao total desejado
    grep -E '\.jpg$|\.jpeg$|\.png$' "$DEST_DIR/zip_listing.txt" \
        | awk '{print $NF}' \
        | head -n "$TOTAL_IMAGES" \
        > "$LIST_FILE"

    rm -f "$DEST_DIR/zip_listing.txt"
fi

TOTAL=$(wc -l < "$LIST_FILE")

echo -e "${GREEN}Encontradas $TOTAL imagens na lista.${NC}"
echo

if [[ "$TOTAL" -eq 0 ]]; then
    echo -e "${RED}Nenhuma imagem encontrada na lista.${NC}"
    exit 1
fi

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
        # O remotezip precisa receber o caminho exato dentro do ZIP
        "$REMOTEZIP" \
            -d "$BASE_DIR" \
            "$ZIP_URL" \
            "$FILE_IN_ZIP" >/dev/null 2>&1

        STATUS=$?

        # Valida se o arquivo baixou e não está corrompido/vazio
        if [[ $STATUS -eq 0 && -f "$OUTPUT" && -s "$OUTPUT" ]]; then
            echo -e "${GREEN}[OK] [$INDEX/$TOTAL] $BASENAME${NC}"
            return 0
        fi

        echo -e "${YELLOW}[RETRY] [$INDEX/$TOTAL] tentativa $ATTEMPT/$MAX_RETRIES - $BASENAME${NC}"
        rm -f "$OUTPUT"
        sleep 1
        ((ATTEMPT++))
    done

    echo -e "${RED}[ERRO] [$INDEX/$TOTAL] Falha ao baixar $BASENAME após $MAX_RETRIES tentativas.${NC}"
    return 1
}

# ------------------------------------------------------------
# INÍCIO DO DOWNLOAD
# ------------------------------------------------------------

echo "============================================"
echo "Iniciando download em PARALELO..."
echo "============================================"
echo

START_TIME=$(date +%s)
INDEX=0

while IFS= read -r FILE_LINE; do
    ((INDEX++))
    
    BASENAME=$(basename "$FILE_LINE")
    OUTPUT="$DEST_DIR/$BASENAME"
    FILE_IN_ZIP="$GESTURE/$BASENAME"

    # [CORREÇÃO] A verificação de SKIP agora acontece no processo principal!
    if [[ -f "$OUTPUT" && -s "$OUTPUT" ]]; then
        echo -e "${NC}[SKIP] [$INDEX/$TOTAL] $BASENAME${NC}"
        continue
    fi

    # Dispara o download em background apenas para as que faltam
    download_one "$FILE_IN_ZIP" "$INDEX" "$BASENAME" "$OUTPUT" &

    # Gerencia a fila de paralelismo
    while [[ $(jobs -r -p | wc -l) -ge $MAX_PARALLEL ]]; do
        sleep 0.2
    done
done < "$LIST_FILE"

# Aguarda os últimos downloads finalizarem
wait

# ------------------------------------------------------------
# RESULTADO FINAL
# ------------------------------------------------------------

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
FINAL_COUNT=$(count_images)

echo
echo "============================================"
echo "              DOWNLOAD FINALIZADO"
echo "============================================"
echo "Gesto:                 $GESTURE"
echo "Esperadas:             $TOTAL_IMAGES"
echo "Na lista:              $TOTAL"
echo "No disco:              $FINAL_COUNT"
echo "Downloads simultâneos: $MAX_PARALLEL"
echo "Tempo:                 ${ELAPSED}s"
echo

if [[ "$FINAL_COUNT" -ge "$TOTAL_IMAGES" ]]; then
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}      TODAS AS IMAGENS ESTÃO NO DISCO${NC}"
    echo -e "${GREEN}============================================${NC}"
else
    MISSING=$((TOTAL_IMAGES - FINAL_COUNT))
    echo -e "${YELLOW}Ainda faltam $MISSING imagens.${NC}"
    echo "Execute o script novamente para tentar baixar as que falharam."
fi

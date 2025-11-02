#!/bin/bash

# Script para resetar o banco de dados do Open WebUI
# Uso: ./reset_database.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
BACKUP_DIR="$DATA_DIR/backups"

echo "🔄 Iniciando reset do banco de dados..."
echo ""

# Criar diretório de backups se não existir
mkdir -p "$BACKUP_DIR"

# Parar o backend se estiver rodando
echo "⏸️  Verificando se o backend está rodando..."
if pgrep -f "uvicorn.*open_webui.main" > /dev/null; then
    echo "❌ ATENÇÃO: O backend ainda está rodando!"
    echo "   Por favor, pare o backend antes de continuar."
    echo "   Use: pkill -f uvicorn"
    read -p "Deseja continuar mesmo assim? (s/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "❌ Operação cancelada."
        exit 1
    fi
fi

# Fazer backup do banco de dados atual
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
echo "💾 Criando backup..."

if [ -f "$DATA_DIR/webui.db" ]; then
    cp "$DATA_DIR/webui.db" "$BACKUP_DIR/webui.db.backup-$TIMESTAMP"
    echo "   ✅ Backup criado: webui.db.backup-$TIMESTAMP"
fi

if [ -f "$DATA_DIR/vector_db/chroma.sqlite3" ]; then
    mkdir -p "$BACKUP_DIR/vector_db_backup-$TIMESTAMP"
    cp "$DATA_DIR/vector_db/chroma.sqlite3" "$BACKUP_DIR/vector_db_backup-$TIMESTAMP/"
    echo "   ✅ Backup do vector DB criado"
fi

echo ""
echo "🗑️  Deletando bancos de dados..."

# Deletar banco principal
if [ -f "$DATA_DIR/webui.db" ]; then
    rm "$DATA_DIR/webui.db"
    echo "   ✅ webui.db deletado"
fi

# Deletar banco de vetores
if [ -f "$DATA_DIR/vector_db/chroma.sqlite3" ]; then
    rm "$DATA_DIR/vector_db/chroma.sqlite3"
    echo "   ✅ chroma.sqlite3 deletado"
fi

# Limpar cache
if [ -d "$DATA_DIR/cache" ]; then
    rm -rf "$DATA_DIR/cache"/*
    echo "   ✅ Cache limpo"
fi

echo ""
echo "✅ Reset completo realizado com sucesso!"
echo ""
echo "📝 Próximos passos:"
echo "   1. Inicie o backend: cd $SCRIPT_DIR && ./start.sh"
echo "   2. Acesse a interface web"
echo "   3. Crie seu primeiro usuário (será admin automaticamente)"
echo ""
echo "💡 Backups salvos em: $BACKUP_DIR"
echo ""

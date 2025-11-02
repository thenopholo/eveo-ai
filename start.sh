#!/bin/bash

# Script de início rápido do EVEO-AI
# Inicia backend e frontend em terminais separados

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║           🚀 EVEO-AI - Iniciando Ambiente                ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Função de limpeza - mata processos anteriores
cleanup_previous_session() {
    echo "🧹 Limpando processos anteriores..."
    
    # Matar sessão tmux se existir
    if tmux has-session -t eveo-ai 2>/dev/null; then
        echo "  → Matando sessão tmux 'eveo-ai'..."
        tmux kill-session -t eveo-ai
    fi
    
    # Liberar porta 8080 (Backend)
    if lsof -ti:8080 >/dev/null 2>&1; then
        echo "  → Liberando porta 8080 (Backend)..."
        lsof -ti:8080 | xargs kill -9 2>/dev/null
        sleep 1
    fi
    
    # Liberar porta 5173 (Frontend)
    if lsof -ti:5173 >/dev/null 2>&1; then
        echo "  → Liberando porta 5173 (Frontend)..."
        lsof -ti:5173 | xargs kill -9 2>/dev/null
        sleep 1
    fi
    
    echo "✅ Limpeza concluída!"
    echo ""
}

# Executar limpeza antes de iniciar
cleanup_previous_session

# Verificar se está no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Execute este script do diretório raiz do projeto!"
    exit 1
fi

# Verificar venv
if [ ! -d "backend/venv" ]; then
    echo "❌ Ambiente virtual não encontrado!"
    echo "Crie com: cd backend && python3.12 -m venv venv"
    exit 1
fi

# Verificar node_modules
if [ ! -d "node_modules" ]; then
    echo "⚠️  node_modules não encontrado. Instalando..."
    npm install --legacy-peer-deps
fi

echo "✅ Ambiente verificado!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Abrindo 2 terminais:"
echo "  Terminal 1: Backend (Python/FastAPI) - Porta 8080"
echo "  Terminal 2: Frontend (SvelteKit/Vite) - Porta 5173"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar se tmux está disponível
if command -v tmux &> /dev/null; then
    echo "🔧 Usando tmux para gerenciar terminais..."

    # Criar sessão tmux
    tmux new-session -d -s eveo-ai

    # Backend no painel esquerdo
    tmux send-keys -t eveo-ai "cd $(pwd)/backend && source venv/bin/activate && bash dev.sh" C-m

    # Split vertical
    tmux split-window -h -t eveo-ai

    # Frontend no painel direito
    tmux send-keys -t eveo-ai "cd $(pwd) && npm run dev" C-m

    # Anexar à sessão
    echo ""
    echo "✅ Sessão tmux criada!"
    echo ""
    echo "Para ver os terminais: tmux attach -t eveo-ai"
    echo "Para sair: Ctrl+B depois D"
    echo "Para matar: tmux kill-session -t eveo-ai"
    echo ""

    tmux attach -t eveo-ai

else
    echo "ℹ️  tmux não disponível. Instruções para início manual:"
    echo ""
    echo "Terminal 1 - Backend:"
    echo "  cd $(pwd)/backend"
    echo "  source venv/bin/activate"
    echo "  bash dev.sh"
    echo ""
    echo "Terminal 2 - Frontend:"
    echo "  cd $(pwd)"
    echo "  npm run dev"
    echo ""
    echo "Depois acesse: http://localhost:5173"
fi

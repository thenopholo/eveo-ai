#!/bin/bash

# Script para parar todos os processos do EVEO-AI

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║           🛑 EVEO-AI - Parando Ambiente                  ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "🧹 Parando processos do EVEO-AI..."
echo ""

# Matar sessão tmux se existir
if tmux has-session -t eveo-ai 2>/dev/null; then
    echo "  → Matando sessão tmux 'eveo-ai'..."
    tmux kill-session -t eveo-ai
    echo "    ✓ Sessão tmux encerrada"
else
    echo "  ℹ️  Nenhuma sessão tmux ativa"
fi

# Liberar porta 8080 (Backend)
if lsof -ti:8080 >/dev/null 2>&1; then
    echo "  → Liberando porta 8080 (Backend)..."
    lsof -ti:8080 | xargs kill -9 2>/dev/null
    echo "    ✓ Porta 8080 liberada"
else
    echo "  ℹ️  Porta 8080 já está livre"
fi

# Liberar porta 5173 (Frontend)
if lsof -ti:5173 >/dev/null 2>&1; then
    echo "  → Liberando porta 5173 (Frontend)..."
    lsof -ti:5173 | xargs kill -9 2>/dev/null
    echo "    ✓ Porta 5173 liberada"
else
    echo "  ℹ️  Porta 5173 já está livre"
fi

echo ""
echo "✅ Todos os processos foram encerrados!"
echo ""


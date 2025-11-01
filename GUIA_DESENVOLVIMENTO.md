# 🚀 EVEO-AI - Guia de Desenvolvimento

## 📋 Abordagem Recomendada

Para desenvolvimento no Open WebUI, a melhor abordagem é rodar **localmente SEM Docker**:

✅ **Backend** (Python) e **Frontend** (SvelteKit) rodando nativamente
✅ **Hot reload automático** em ambos (já configurado!)
✅ **Mais rápido** e **fácil de debugar**

---

## 🎯 Como Desenvolver (Método Simples e Correto)

### Terminal 1 - Backend Python

```bash
cd ~/dev/eveo-ai/backend
source venv/bin/activate
bash dev.sh
```

**O que acontece:**

- Backend inicia em `http://localhost:8080`
- **Hot reload ativo** (uvicorn --reload)
- Qualquer mudança em `.py` reinicia automaticamente

### Terminal 2 - Frontend SvelteKit

```bash
cd ~/dev/eveo-ai
npm run dev
```

**O que acontece:**

- Frontend inicia em `http://localhost:5173`
- **Hot reload ULTRA RÁPIDO** (Vite HMR)
- Mudanças aparecem **instantaneamente** no browser

---

## 🔥 Hot Reload JÁ Funciona!

### Backend (Python/FastAPI)

- ✅ uvicorn com `--reload`
- ✅ Detecta mudanças em arquivos `.py`
- ✅ Reinicia em ~1 segundo

### Frontend (SvelteKit/Vite)

- ✅ Vite Hot Module Replacement (HMR)
- ✅ Mudanças aparecem em **milissegundos**
- ✅ Preserva estado da aplicação

**Não precisa de Docker para dev!** 🎉

---

## 🐳 Docker é Para...

Docker é útil para:

- ✅ **Produção** (deploy)
- ✅ **Testes** (ambiente isolado)
- ✅ **Demos** (rodar tudo de uma vez)

**Não para desenvolvimento ativo!**

---

## ⚡ Fluxo de Trabalho

### 1. Iniciar Ambiente (Uma vez por dia)

**Terminal 1:**

```bash
cd ~/dev/eveo-ai/backend
source venv/bin/activate
bash dev.sh
```

**Terminal 2:**

```bash
cd ~/dev/eveo-ai
npm run dev
```

### 2. Desenvolver

- Edite arquivos normalmente no VS Code
- Salve (Ctrl+S)
- Mudanças aparecem automaticamente!

### 3. Testar

- Acesse: http://localhost:5173
- Backend API: http://localhost:8080/docs

### 4. Ao Final do Dia

- Ctrl+C nos dois terminais
- Pronto!

---

## 🔧 Comandos Úteis

### Backend

```bash
# Ativar venv
cd ~/dev/eveo-ai/backend && source venv/bin/activate

# Rodar em dev
bash dev.sh

# Rodar migrations
alembic upgrade head

# Instalar nova dependência
pip install nome-pacote
pip freeze > requirements.txt
```

### Frontend

```bash
# Desenvolvimento
npm run dev

# Build de produção
npm run build

# Verificar tipos
npm run check

# Instalar nova dependência
npm install nome-pacote --legacy-peer-deps
```

---

## 📦 Docker Compose (Original do Projeto)

Se quiser rodar **tudo com Docker** (não recomendado para dev):

```bash
# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar
docker-compose down
```

Acesse: http://localhost:3000

**Mas isso NÃO tem hot reload!** Você precisa rebuildar a cada mudança.

---

## 🎨 Estrutura do Projeto

```
eveo-ai/
├── backend/
│   ├── venv/                    # Ambiente virtual Python
│   ├── open_webui/              # Código Python
│   ├── dev.sh                   # Script de dev do backend
│   └── requirements.txt         # Dependências Python
│
├── src/                         # Frontend SvelteKit
│   ├── routes/                  # Páginas (auto-roteadas)
│   ├── lib/                     # Componentes e libs
│   └── app.html                 # Template HTML
│
├── .env                         # Suas configurações
├── package.json                 # Dependências npm
└── docker-compose.yaml          # Docker (para produção)
```

---

## 🔑 Configurar Groq API

Seu `.env` já está configurado com:

```env
OPENAI_API_BASE_URL='https://api.groq.com/openai/v1'
OPENAI_API_KEY='gsk_wAsM9IT7mvoVestHpsHIMGdyb3FYEsPOmoTulYvfTw8JPcBe9aG'
```

O backend lê isso automaticamente!

---

## 🐛 Troubleshooting

### "Porta já em uso"

```bash
# Ver o que está usando
lsof -i :8080  # Backend
lsof -i :5173  # Frontend

# Matar processo
kill -9 PID
```

### "Módulo não encontrado" (Python)

```bash
cd ~/dev/eveo-ai/backend
source venv/bin/activate
pip install -r requirements.txt
```

### "Cannot find module" (Node)

```bash
cd ~/dev/eveo-ai
npm install --legacy-peer-deps
```

### "venv não ativa"

```bash
# WSL/Linux
cd ~/dev/eveo-ai/backend
source venv/bin/activate

# Windows (se precisar)
cd ~/dev/eveo-ai/backend
.\venv\Scripts\activate
```

---

## 💡 Dicas Pro

### 1. Manter Terminais Organizados

No VS Code:

- Split terminal (Ctrl+Shift+5)
- Terminal 1: Backend (esquerda)
- Terminal 2: Frontend (direita)

### 2. Ver Logs em Tempo Real

Ambos os servidores mostram logs no terminal:

- Backend: Requests, erros, etc
- Frontend: Build status, erros, etc

### 3. Browser DevTools

- F12 no Chrome/Firefox
- Console: Ver erros do JavaScript
- Network: Ver requests para API

### 4. API Docs Interativa

- Acesse: http://localhost:8080/docs
- Teste endpoints diretamente
- Veja schemas e exemplos

---

## 🎯 Próximos Passos

Agora que o ambiente está rodando:

1. ✅ Teste o hot reload (edite um arquivo e veja a magia!)
2. ✅ Explore a interface em http://localhost:5173
3. ✅ Teste a API em http://localhost:8080/docs
4. ✅ Comece a implementar suas features
5. ✅ Quando estiver pronto, integre HubSpot e NetSuite

---

## 📚 Recursos

- **SvelteKit**: https://kit.svelte.dev/
- **FastAPI**: https://fastapi.tiangolo.com/
- **Vite**: https://vitejs.dev/
- **Open WebUI Docs**: https://docs.openwebui.com/

---

## ✅ Checklist Ambiente OK

- [x] Python 3.12 + venv configurado
- [x] Node.js 22 instalado
- [x] Dependências Python instaladas
- [x] Dependências npm instaladas
- [x] API Key do Groq configurada
- [x] Hot reload funcionando nativamente

---

**Ambiente pronto! Bom desenvolvimento! 🚀**

Para iniciar:

```bash
# Terminal 1
cd ~/dev/eveo-ai/backend && source venv/bin/activate && bash dev.sh

# Terminal 2
cd ~/dev/eveo-ai && npm run dev
```

# 🔄 Guia de Reset do Banco de Dados

## ✅ Reset Concluído!

O banco de dados foi resetado com sucesso. O sistema agora está no estado inicial, como se fosse a primeira instalação.

## 📋 O que foi feito:

1. ✅ **Backup criado**: `webui.db.backup-20251101-234704`
2. ✅ **Banco principal deletado**: `webui.db`
3. ✅ **Banco de vetores limpo**: `vector_db/chroma.sqlite3`
4. ✅ **Cache limpo**: `data/cache/*`

## 🚀 Próximos Passos

### 1. Iniciar o Backend

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
source venv/bin/activate
./start.sh
```

Ou se estiver usando Docker:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai
./start.sh
```

### 2. Acessar a Interface

Abra seu navegador e acesse:
- **URL**: http://localhost:5173 (desenvolvimento) ou http://localhost:8080 (produção)

### 3. Criar Primeiro Usuário

Quando acessar a interface pela primeira vez:
1. Clique em **"Sign Up"** ou **"Registrar"**
2. Preencha os dados:
   - **Nome**: Seu nome
   - **Email**: Seu email
   - **Senha**: Sua senha
3. Clique em **"Create Account"**

⚠️ **IMPORTANTE**: O primeiro usuário criado automaticamente se torna **ADMIN**!

## 🔧 Script de Reset (Para Uso Futuro)

Foi criado um script para facilitar resets futuros:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
./reset_database.sh
```

Este script fará automaticamente:
- Backup dos bancos de dados
- Limpeza completa
- Mensagens informativas

## 🗂️ Estrutura do Banco de Dados

O `webui.db` é um banco **SQLite 3** com as seguintes tabelas principais:

### Tabelas de Usuário
- `user` - Dados dos usuários
- `auth` - Autenticação
- `oauth_session` - Sessões OAuth

### Tabelas de Conteúdo
- `chat` - Conversas
- `message` - Mensagens
- `document` - Documentos
- `file` - Arquivos
- `knowledge` - Base de conhecimento

### Tabelas de Configuração
- `config` - Configurações globais
- `model` - Modelos disponíveis
- `prompt` - Prompts salvos
- `tool` - Tools/ferramentas

### Outras Tabelas
- `folder` - Organização em pastas
- `tag` - Tags/marcadores
- `feedback` - Feedbacks
- `memory` - Memórias
- `channel` - Canais
- `group` - Grupos

## 📊 Comandos SQL Úteis

### Conectar ao Banco

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend/data
sqlite3 webui.db
```

### Listar Todas as Tabelas

```sql
.tables
```

### Ver Estrutura de uma Tabela

```sql
.schema user
```

### Consultar Usuários

```sql
SELECT id, name, email, role, created_at FROM user;
```

### Deletar um Usuário Específico (alternativa ao reset completo)

```sql
-- Ver o usuário primeiro
SELECT * FROM user WHERE email = 'seu@email.com';

-- Deletar (cuidado!)
DELETE FROM user WHERE email = 'seu@email.com';

-- Deletar dados relacionados
DELETE FROM auth WHERE user_id = 'id_do_usuario';
DELETE FROM chat WHERE user_id = 'id_do_usuario';
DELETE FROM message WHERE user_id = 'id_do_usuario';
```

### Sair do SQLite

```sql
.exit
```

## 🔒 Opção 2: Deletar Apenas um Usuário Específico

Se no futuro você quiser deletar apenas um usuário sem fazer reset completo:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend/data

sqlite3 webui.db << EOF
-- Backup primeiro!
.backup backup_pre_delete.db

-- Ver usuários
SELECT id, name, email, role FROM user;

-- Deletar usuário e dados relacionados
-- SUBSTITUA o email abaixo pelo email do usuário
DELETE FROM oauth_session WHERE user_id IN (SELECT id FROM user WHERE email = 'email@deletar.com');
DELETE FROM chat WHERE user_id IN (SELECT id FROM user WHERE email = 'email@deletar.com');
DELETE FROM message WHERE user_id IN (SELECT id FROM user WHERE email = 'email@deletar.com');
DELETE FROM auth WHERE user_id IN (SELECT id FROM user WHERE email = 'email@deletar.com');
DELETE FROM user WHERE email = 'email@deletar.com';

-- Verificar
SELECT id, name, email, role FROM user;
EOF
```

## 💾 Recuperar do Backup

Se precisar restaurar o backup:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend/data

# Parar o backend primeiro!

# Restaurar
cp webui.db.backup-20251101-234704 webui.db

# Reiniciar o backend
```

## 🐛 Troubleshooting

### Backend não inicia após reset

```bash
# Verificar se o arquivo .db existe
ls -lh /home/rodrigo_thenopholo/dev/eveo-ai/backend/data/webui.db

# Se não existir, é normal! O backend criará um novo.
# Apenas inicie o backend normalmente.
```

### Erro "database is locked"

```bash
# Parar todos os processos do backend
pkill -f uvicorn

# Tentar novamente
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
./start.sh
```

### Interface pede login mas não aceita credenciais

Isso é normal após reset! Você precisa **criar uma nova conta** (Sign Up), não fazer login.

## 📚 Recursos Adicionais

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Open WebUI Documentation](https://docs.openwebui.com/)
- [Peewee ORM (usado no projeto)](http://docs.peewee-orm.com/)

---

**Criado em**: 2025-11-02
**Última atualização**: 2025-11-02
**Status**: ✅ Reset concluído com sucesso

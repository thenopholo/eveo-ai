# Guia de Desenvolvimento - Agentes LangGraph + Groq

## 🎯 Visão Geral

Este guia explica como desenvolver e integrar agentes de IA usando LangGraph com o modelo Groq para acessar dados do HubSpot e NetSuite via API.

## 📋 Pré-requisitos

- ✅ LangGraph instalado (`langgraph==0.2.70`)
- ✅ LangChain-Groq instalado (`langchain-groq==0.3.3`)
- ✅ Chave da API Groq configurada no `.env`

## 🚀 Configuração Inicial

### 1. Configurar Groq no `.env`

```bash
# API do Groq
GROQ_API_KEY='gsk_z1HNBZKyWjjkhN5zaKFxWGdyb3FzIMDvCkL4rfvT8DKxwqDy1Ho'

# Configurar como backend OpenAI (opcional)
OPENAI_API_BASE_URL='https://api.groq.com/openai/v1'
OPENAI_API_KEY='gsk_z1HNBZKyWjjkhN5zaKFxWGdyb3FzIMDvCkL4rfvT8DKxwqDy1Ho'

# APIs externas
HUBSPOT_API_KEY='sua_chave_hubspot'
NETSUITE_API_KEY='sua_chave_netsuite'
NETSUITE_ACCOUNT_ID='sua_conta_netsuite'
```

### 2. Modelos Groq Recomendados

Para desenvolvimento e prompt engineering:

- **llama-3.3-70b-versatile** (Recomendado) - Melhor custo-benefício
- **llama-3.1-70b-versatile** - Alta performance
- **mixtral-8x7b-32768** - Contexto extenso
- **gemma2-9b-it** - Mais rápido, menor custo

## 📚 Estrutura de Agentes

### Arquivo de Exemplo: `agents_example.py`

O arquivo `backend/open_webui/agents_example.py` contém dois exemplos:

1. **Agente Simples**: Conversação básica com Groq
2. **Agente com Roteamento**: Roteamento inteligente entre HubSpot e NetSuite

### Executar os Exemplos

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
source venv/bin/activate
python -m open_webui.agents_example
```

## 🔌 Integração com APIs

### HubSpot API

Instalar cliente HubSpot:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
source venv/bin/activate
uv pip install hubspot-api-client
```

Exemplo de integração:

```python
from hubspot import HubSpot
from hubspot.crm.contacts import SimplePublicObjectInput

def query_hubspot_contacts(api_key: str, search_term: str):
    """Buscar contatos no HubSpot"""
    client = HubSpot(access_token=api_key)

    try:
        # Buscar contatos
        response = client.crm.contacts.search_api.do_search(
            public_object_search_request={
                "query": search_term,
                "limit": 10
            }
        )
        return response.results
    except Exception as e:
        print(f"Erro ao buscar contatos: {e}")
        return []
```

### NetSuite API

Instalar cliente NetSuite:

```bash
cd /home/rodrigo_thenopholo/dev/eveo-ai/backend
source venv/bin/activate
uv pip install netsuitesdk
```

Exemplo de integração:

```python
from netsuitesdk import NetSuiteConnection

def query_netsuite_data(account_id: str, consumer_key: str, consumer_secret: str):
    """Conectar ao NetSuite e buscar dados"""
    ns = NetSuiteConnection(
        account=account_id,
        consumer_key=consumer_key,
        consumer_secret=consumer_secret,
        token_key='your_token_key',
        token_secret='your_token_secret'
    )

    # Exemplo: buscar clientes
    customers = ns.customers.get_all()
    return customers
```

## 🏗️ Arquitetura de Agentes

### 1. Agente de Roteamento

Responsável por determinar qual fonte de dados usar com base na query do usuário.

```python
def route_query(state: AgentState):
    """Analisa a query e decide o roteamento"""
    query = state["messages"][-1].content.lower()

    # Palavras-chave para HubSpot
    hubspot_keywords = ["cliente", "contato", "lead", "email", "marketing"]

    # Palavras-chave para NetSuite
    netsuite_keywords = ["financeiro", "pedido", "invoice", "pagamento", "estoque"]

    if any(keyword in query for keyword in hubspot_keywords):
        return {"data_source": "hubspot"}
    elif any(keyword in query for keyword in netsuite_keywords):
        return {"data_source": "netsuite"}
    else:
        return {"data_source": "general"}
```

### 2. Agente de Extração de Dados

Executa queries nas APIs externas.

```python
def query_hubspot(state: AgentState):
    """Extrai dados do HubSpot"""
    api_key = os.getenv("HUBSPOT_API_KEY")
    query = state["messages"][-1].content

    # Implementar lógica de extração
    results = query_hubspot_contacts(api_key, query)

    return {
        "query_result": {
            "source": "hubspot",
            "data": results
        }
    }
```

### 3. Agente de Síntese

Combina os dados extraídos e gera uma resposta natural.

```python
def synthesize_response(state: AgentState):
    """Gera resposta usando Groq com os dados extraídos"""
    llm = get_groq_model()
    query_result = state["query_result"]

    prompt = f"""
    Você é um assistente de análise de dados empresariais.

    Dados extraídos de {query_result['source']}:
    {query_result['data']}

    Pergunta do usuário: {state['messages'][-1].content}

    Forneça uma resposta clara e acionável baseada nos dados.
    """

    response = llm.invoke(prompt)
    return {"messages": [response]}
```

## 🎯 Casos de Uso

### Caso 1: Análise de Clientes

```python
query = "Quantos clientes novos tivemos este mês no HubSpot?"
# O agente:
# 1. Roteia para HubSpot
# 2. Busca dados de clientes criados no mês
# 3. Analisa e retorna uma resposta
```

### Caso 2: Status Financeiro

```python
query = "Qual o valor total de invoices pendentes no NetSuite?"
# O agente:
# 1. Roteia para NetSuite
# 2. Busca invoices com status pendente
# 3. Calcula o total e retorna
```

### Caso 3: Análise Cross-Platform

```python
query = "Compare o volume de vendas entre HubSpot e NetSuite"
# O agente:
# 1. Consulta ambas as plataformas
# 2. Normaliza os dados
# 3. Gera relatório comparativo
```

## 📝 Prompt Engineering

### Técnicas Recomendadas

1. **Few-Shot Learning**: Forneça exemplos no prompt
2. **Chain-of-Thought**: Peça para o modelo explicar seu raciocínio
3. **Role Prompting**: Defina o papel do assistente claramente

### Exemplo de Prompt Otimizado

```python
system_prompt = """
Você é um assistente especializado em análise de dados empresariais.

Suas responsabilidades:
1. Interpretar queries sobre dados de CRM (HubSpot) e ERP (NetSuite)
2. Fornecer insights acionáveis baseados em dados reais
3. Manter um tom profissional e objetivo

Formato de resposta:
- Sumário executivo (1-2 frases)
- Dados principais encontrados
- Recomendações (se aplicável)

Exemplo:
Query: "Quantos leads qualificados temos?"
Resposta:
Sumário: Há 47 leads qualificados no pipeline atual.
Dados:
- 23 em estágio de descoberta
- 24 em estágio de proposta
Recomendação: Focar nos 24 leads em proposta para aumentar conversão.
"""
```

## 🔄 Próximos Passos

1. **Testar os exemplos** em `agents_example.py`
2. **Configurar credenciais** do HubSpot e NetSuite
3. **Implementar integração real** com as APIs
4. **Desenvolver agentes específicos** para seus casos de uso
5. **Otimizar prompts** baseado nos resultados
6. **Preparar para migração** para o GPT-OSS-20B quando disponível

## 🚀 Roadmap para Produção

### Fase Atual: Desenvolvimento (Groq)

- ✅ Setup básico de agentes
- ✅ Integração com HubSpot/NetSuite
- ✅ Prompt engineering
- ✅ Testes e validação

### Próxima Fase: Produção (Cluster Nvidia)

- Migrar do Groq para GPT-OSS-20B
- Conectar ao data warehouse
- Escalar para 4x Nvidia T4
- Implementar monitoramento e logging

## 📚 Recursos Úteis

- [Documentação LangGraph](https://langchain-ai.github.io/langgraph/)
- [Groq API Docs](https://console.groq.com/docs)
- [HubSpot API](https://developers.hubspot.com/)
- [NetSuite SuiteScript](https://docs.oracle.com/en/cloud/saas/netsuite/ns-online-help/chapter_4387172221.html)

## 💡 Dicas

1. **Use cache de respostas** para evitar chamadas desnecessárias às APIs
2. **Implemente rate limiting** para respeitar limites das APIs
3. **Log todas as interações** para análise e melhoria contínua
4. **Teste com dados reais** mas sanitizados em desenvolvimento
5. **Documente todos os prompts** e suas variações

---

**Autor**: Equipe de Desenvolvimento IA
**Data**: Novembro 2025
**Versão**: 1.0

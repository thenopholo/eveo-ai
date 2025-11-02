"""
Exemplo de uso do LangGraph com Groq para criar agentes de IA
para integração com HubSpot e NetSuite
"""

import os
from typing import Annotated, TypedDict
from langchain_groq import ChatGroq
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages


# Configuração do modelo Groq
def get_groq_model(model_name: str = "llama-3.3-70b-versatile"):
    """
    Inicializa o modelo Groq com a chave da API

    Args:
        model_name: Nome do modelo Groq a ser usado

    Returns:
        ChatGroq: Instância do modelo configurado
    """
    groq_api_key = os.getenv("GROQ_API_KEY", "")

    if not groq_api_key:
        raise ValueError("GROQ_API_KEY não encontrada nas variáveis de ambiente")

    return ChatGroq(
        model=model_name,
        temperature=0.7,
        groq_api_key=groq_api_key
    )


# Estado do agente
class AgentState(TypedDict):
    """Estado compartilhado entre os nós do grafo"""
    messages: Annotated[list, add_messages]
    data_source: str  # 'hubspot' ou 'netsuite'
    query_result: dict


# Exemplo 1: Agente simples de conversação
def create_simple_agent():
    """
    Cria um agente simples de conversação usando LangGraph
    """
    llm = get_groq_model()

    def chatbot(state: AgentState):
        """Função que processa mensagens"""
        return {"messages": [llm.invoke(state["messages"])]}

    # Criar o grafo
    graph_builder = StateGraph(AgentState)
    graph_builder.add_node("chatbot", chatbot)
    graph_builder.add_edge(START, "chatbot")
    graph_builder.add_edge("chatbot", END)

    return graph_builder.compile()


# Exemplo 2: Agente com roteamento para HubSpot/NetSuite
def create_data_agent():
    """
    Cria um agente que pode rotear queries para HubSpot ou NetSuite
    """
    llm = get_groq_model()

    def route_query(state: AgentState):
        """Determina qual fonte de dados usar"""
        messages = state["messages"]
        last_message = messages[-1].content.lower()

        if "hubspot" in last_message or "cliente" in last_message or "contato" in last_message:
            return {"data_source": "hubspot"}
        elif "netsuite" in last_message or "financeiro" in last_message or "pedido" in last_message:
            return {"data_source": "netsuite"}
        else:
            return {"data_source": "unknown"}

    def query_hubspot(state: AgentState):
        """Simula query ao HubSpot (implementar com a API real)"""
        # TODO: Implementar integração real com HubSpot API
        return {
            "query_result": {
                "source": "hubspot",
                "data": "Dados do cliente extraídos do HubSpot"
            }
        }

    def query_netsuite(state: AgentState):
        """Simula query ao NetSuite (implementar com a API real)"""
        # TODO: Implementar integração real com NetSuite API
        return {
            "query_result": {
                "source": "netsuite",
                "data": "Dados financeiros extraídos do NetSuite"
            }
        }

    def respond(state: AgentState):
        """Gera resposta final com base nos dados"""
        query_result = state.get("query_result", {})
        messages = state["messages"]

        context = f"Dados obtidos de {query_result.get('source', 'unknown')}: {query_result.get('data', 'nenhum')}"

        prompt = f"{context}\n\nPergunta do usuário: {messages[-1].content}\n\nResposta:"
        response = llm.invoke(prompt)

        return {"messages": [response]}

    # Construir o grafo
    graph_builder = StateGraph(AgentState)

    graph_builder.add_node("route_query", route_query)
    graph_builder.add_node("query_hubspot", query_hubspot)
    graph_builder.add_node("query_netsuite", query_netsuite)
    graph_builder.add_node("respond", respond)

    # Adicionar edges
    graph_builder.add_edge(START, "route_query")

    # Roteamento condicional
    def route_logic(state: AgentState):
        if state["data_source"] == "hubspot":
            return "query_hubspot"
        elif state["data_source"] == "netsuite":
            return "query_netsuite"
        else:
            return "respond"

    graph_builder.add_conditional_edges("route_query", route_logic)
    graph_builder.add_edge("query_hubspot", "respond")
    graph_builder.add_edge("query_netsuite", "respond")
    graph_builder.add_edge("respond", END)

    return graph_builder.compile()


# Exemplo de uso
if __name__ == "__main__":
    # Teste do agente simples
    print("=== Testando Agente Simples ===")
    simple_agent = create_simple_agent()

    result = simple_agent.invoke({
        "messages": [{"role": "user", "content": "Olá! Como você pode me ajudar?"}]
    })
    print(f"Resposta: {result['messages'][-1].content}\n")

    # Teste do agente com roteamento
    print("=== Testando Agente com Roteamento ===")
    data_agent = create_data_agent()

    # Teste com HubSpot
    result = data_agent.invoke({
        "messages": [{"role": "user", "content": "Me mostre informações de clientes do HubSpot"}]
    })
    print(f"Query HubSpot - Resposta: {result['messages'][-1].content}\n")

    # Teste com NetSuite
    result = data_agent.invoke({
        "messages": [{"role": "user", "content": "Qual o status financeiro no NetSuite?"}]
    })
    print(f"Query NetSuite - Resposta: {result['messages'][-1].content}\n")

# Supplier Performance Cockpit 🚀 (SAP BTP | CAP | S/4HANA Integration (simulado))

Este projeto demonstra uma solução Full Stack robusta desenvolvida no **SAP BTP** utilizando o modelo **CAP (Cloud Application Programming)**. O foco principal é a resiliência de integração e a automação de workflows de compras.

## 🛠️ Tecnologias e Funcionalidades

- **Backend (Node.js/CAP):** Implementação de Handlers customizados para consumo de APIs externas (S/4HANA Business Partner).
- **Resiliência:** Estratégia de Try-Catch global para isolar falhas de integração e fornecer feedback amigável ao usuário.
- **Workflow de Aprovação:** Botões de ação customizados (`Aprovar` / `Reprovar`) com validação de regras de negócio no servidor.
- **Fiori Elements (UI Inteligente):**
  - **Side Effects:** Atualização em tempo real da interface sem necessidade de refresh.
  - **Dynamic Actions:** Botões que aparecem/somem conforme o status do rascunho ou do registro.
  - **Criticality Mapping:** Identificadores visuais (cores) baseados na nota de desempenho.
- **Segurança:** Bloqueio automático de edição (`UpdateHidden`) para auditoria de processos finalizados.

## 🏗️ Arquitetura do Projeto

O projeto utilizara o banco de dados **SAP HANA** porém ate o presente momento utilizei via SQLite/CSV para desenvolvimento e consome metadados de uma simulação de um  **S/4HANA** para garantir a consistência dos dados de fornecedores.

## 🚀 Como Executar
1. Instale as dependências: `npm install`
2. Inicie o projeto: `cds watch`
3. Acesse o Fiori Launchpad local em: `http://localhost:4004`
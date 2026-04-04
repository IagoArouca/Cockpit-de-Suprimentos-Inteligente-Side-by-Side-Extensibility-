# Supplier Performance Cockpit 🚀 (SAP BTP | CAP | S/4HANA Simulation)

Este projeto demonstra a construção de uma aplicação **Cloud Native** no SAP BTP, desenhada para interagir com o ecossistema SAP S/4HANA. A solução foca na gestão e avaliação de performance de fornecedores.

## 🛠️ Tecnologias e Funcionalidades


- **Integração Simulada:** O projeto foi estruturado a partir do arquivo EDMX oficial da API de Business Partner do S/4HANA, utilizando dados mockados (CSV) para validar a lógica de negócio e o comportamento da interface sem a necessidade de uma conexão ativa de rede.
- **Preparação para Erros (Resiliência):** Implementação de blocos `try/catch` nos handlers de leitura para simular o comportamento da aplicação diante de possíveis instabilidades em serviços externos.
- **Workflow de Aprovação:** Botões de ação customizados (`Aprovar` / `Reprovar`) com validação de regras de negócio no servidor.
- **Fiori Elements (UI Inteligente):**
  - **Side Effects:** Atualização em tempo real da interface sem necessidade de refresh.
  - **Dynamic Actions:** Botões que aparecem/somem conforme o status do rascunho ou do registro.
  - **Criticality Mapping:** Identificadores visuais (cores) baseados na nota de desempenho.
- **Segurança:** Bloqueio automático de edição (`UpdateHidden`) para auditoria de processos finalizados.

## 🏗️ Arquitetura do Projeto

O projeto utilizou o banco de dados **SQLite/CSV**  para desenvolvimento e consome metadados de uma simulação de um  **S/4HANA** para garantir a consistência dos dados de fornecedores.

## 🚀 Como Executar
1. Instale as dependências: `npm install`
2. Inicie o projeto: `cds watch`
3. Acesse o Fiori Launchpad local em: `http://localhost:4004`
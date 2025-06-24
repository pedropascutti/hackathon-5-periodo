
# 📚 Aplicativo Web para Correção de Gabaritos

## 🎯 Objetivo
Este projeto foi desenvolvido no Hackathon do 5º período de Sistemas para Internet da UniALFA, com o propósito de automatizar a correção de provas objetivas. A aplicação tem como foco oferecer agilidade no processo de correção, retorno rápido ao aluno e possibilidade de integração futura com o sistema acadêmico da instituição via API.

## ⚙️ Funcionalidades Implementadas

### 🔐 Autenticação
- Login por perfil (Administrador, Professor e Aluno).
- Controle de acesso para páginas específicas conforme perfil do usuário.

### 👨‍🏫 Área do Professor / Administrador
- Cadastro de turmas, disciplinas, professores e alunos.
- Associação de alunos às turmas.
- Criação de provas com vínculo à turma, disciplina e data.
- Cadastro e gerenciamento de questões por prova (com número, pontuação e alternativa correta).
- Visualização das respostas dos alunos e correção automática com base no gabarito.
- Consulta de notas por aluno e estatísticas da turma (média e acertos).
- Integração com app Flutter via API para envio das respostas dos alunos. (NÃO FINALIZADA)

### 🎓 Área do Aluno
- Visualização de suas próprias notas em um boletim simplificado.
- As provas exibidas são apenas da turma em que o aluno está matriculado.

### 🔄 Integração via API
- Endpoint POST `/api/correcao/corrigir` para receber as respostas dos alunos a partir do app Flutter.
- As respostas são processadas e armazenadas, calculando automaticamente a nota do aluno.

## 🧰 Tecnologias Utilizadas
- **Backend:** Java 21, Spring Boot, Spring Web, Spring Data JPA, Spring Security
- **Frontend:** Thymeleaf, Bootstrap 5
- **Banco de Dados:** MySQL
- **API REST:** Integração com aplicação Flutter (em desenvolvimento)
- **Segurança:** Autenticação e controle de perfis via Spring Security

## 🗃️ Estrutura do Projeto
- MVC bem definido (Controller, Service, Repository)
- Organização por pacotes funcionais (ex: `controller`, `model`, `dto`, `service`, `repository`)
- Templates responsivos e separados por perfil de usuário
- DTOs utilizados para comunicação com a API e para exibição de dados formatados

## ✅ Requisitos Mínimos Atendidos
- [x] Login por perfil
- [x] Cadastro de turmas, disciplinas, alunos
- [x] Associação aluno/turma
- [x] Criação de provas por disciplina/turma/data
- [x] Cadastro e correção de gabarito (com questões)
- [x] Envio de respostas por API
- [x] Cálculo de nota por aluno
- [x] Visualização de notas por professor e aluno
- [x] Interface limpa e intuitiva



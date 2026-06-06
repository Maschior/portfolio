# Infraestrutura do Portfólio Cloud (AWS + Terraform + Ansible)

📖 [English version here](README.md)

💻 **Nota:** Este repositório contém a IaC com Terraform e playbooks do Ansible para gerenciar a infraestrutura de deploy. O código-fonte da aplicação Next.js executada nesta infraestrutura pode ser encontrado aqui: [github.com/Maschior/portfolio-webapp](https://github.com/Maschior/portfolio-webapp).

---

Este repositório gerencia a infraestrutura na nuvem e a configuração de sistema para hospedar o meu site de portfólio pessoal, utilizando uma stack de DevOps moderna e de nível de produção para realizar deploys de forma automática e segura.

## 🏗️ Visão Geral da Arquitetura

A infraestrutura simula um ambiente de nuvem corporativo com repositórios e pipelines separados:
- **IaC com Terraform:** Provisiona rede, computação e segurança na AWS, além da integração com a Cloudflare.
- **Automação com Ansible:** Instala e configura serviços de sistema (como Nginx) e gerencia as configurações do host na instância EC2.
- **Túnel Seguro da Cloudflare:** Conecta a instância EC2 à web pública através de um túnel de saída seguro (sem a necessidade de expor portas de entrada públicas para a internet).
- **Integração com GitHub Actions:** Utiliza autenticação segura via OpenID Connect (OIDC) da AWS para deploys IAM sem o uso de senhas ou chaves estáticas.

## 🛠️ Stack Tecnológica
- **Infraestrutura como Código:** [Terraform](https://www.terraform.io/)
- **Gerenciamento de Configuração:** [Ansible](https://www.ansible.com/)
- **Provedor de Nuvem:** [Amazon Web Services (AWS)](https://aws.amazon.com/)
- **DNS & Segurança:** [Cloudflare](https://www.cloudflare.com/) (Tunnels + roteamento DNS)
- **CI/CD:** GitHub Actions (com integração de role IAM OIDC)

## 📁 Estrutura de Diretórios
```bash
portfolio-infra/
├── terraform/                # Configurações do Terraform
│   ├── modules/              # Módulos reutilizáveis de IaC
│   │   ├── bootstrap/        # Bucket S3 Backend e tabela DynamoDB para lock de estado
│   │   ├── github_oidc/      # Role de OpenID Connect para GitHub Actions
│   │   ├── network/          # Configurações de VPC, Subnet e Tabela de Rotas
│   │   ├── iam/              # Políticas e Roles IAM para o SSM
│   │   ├── security/         # Security Groups (Grupos de Segurança)
│   │   ├── cloudflare/       # Recursos de Túnel Cloudflare e registros DNS
│   │   └── compute/          # Instância EC2 e script de inicialização
│   ├── main.tf               # Orquestrador do módulo raiz
│   └── variables.tf          # Declarações de variáveis de entrada
└── ansible/                  # Configurações de provisionamento do Ansible
    ├── playbook.yml          # Tarefas de configuração do servidor (Nginx, etc.)
    └── hosts                 # Definições de inventário
```

## 🚀 Guia de Implantação (Deployment)

Siga as instruções abaixo para configurar e provisionar a infraestrutura:

### 1. Pré-requisitos
Certifique-se de ter instalado:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [Ansible CLI](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais.

### 2. Provisionamento da Infraestrutura
Navegue até o diretório do terraform:
```bash
cd terraform
```

Inicialize o Terraform (baixa provedores e requisitos de módulo):
```bash
terraform init
```

Revise as alterações planejadas:
```bash
terraform plan
```

Implante a infraestrutura:
```bash
terraform apply
```

### 3. Configuração do Servidor (Ansible)
Após provisionar a instância EC2, navegue até o diretório do ansible para configurá-la:
```bash
cd ../ansible
ansible-playbook playbook.yml
```
Isso instalará o Nginx, configurará os diretórios e preparará o host para o deploy da aplicação web.

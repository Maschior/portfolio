# Infraestrutura do Portfólio Cloud (AWS + Terraform + Ansible)

📖 [English version here](README.md)

💻 **Nota:** Este repositório contém a IaC com Terraform e playbooks do Ansible para gerenciar a infraestrutura de deploy. O código-fonte da aplicação Next.js executada nesta infraestrutura pode ser encontrado aqui: [github.com/Maschior/portfolio-webapp](https://github.com/Maschior/portfolio-webapp).

---

Este repositório gerencia a infraestrutura na nuvem e a configuração de sistema para hospedar o meu site de portfólio pessoal, utilizando uma stack de DevOps moderna e de nível de produção para realizar deploys de forma automática e segura.

## 🏗️ Visão Geral da Arquitetura

A infraestrutura simula um ambiente de nuvem corporativo com repositórios e pipelines separados:
- **IaC com Terraform:** Provisiona rede, computação e segurança na AWS. Ele utiliza uma estratégia de **Tagging Global (default_tags)** no nível do provedor para garantir que todos os recursos sejam etiquetados de forma consistente.
- **Automação com Ansible:** Execução local de configurações. Os playbooks do Ansible são injetados dinamicamente no processo de inicialização da EC2 via Cloud-Init/User Data, instalando e configurando automaticamente serviços essenciais (Nginx, Node.js, PM2) sem intervenção manual externa.
- **Túnel Seguro da Cloudflare:** Desacoplado do ciclo de vida da instância de computação para evitar conflitos de DNS. Um túnel estático é criado uma única vez na Cloudflare, e a instância EC2 se associa com segurança a ele usando o token do túnel na inicialização.
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
│   │   └── compute/          # Instância EC2 e script de inicialização (injeta arquivos do Ansible)
│   ├── main.tf               # Orquestrador do módulo raiz
│   ├── providers.tf          # Configurações de provedores e default_tags globais
│   └── variables.tf          # Declarações de variáveis de entrada
└── ansible/                  # Configurações de provisionamento do Ansible
    ├── playbook.yml          # Tarefas de configuração do servidor (Nginx, Node.js, PM2)
    ├── ansible.cfg           # Configurações locais do Ansible
    └── hosts                 # Inventário local
```

## 🚀 Guia de Implantação (Deployment)

Siga as instruções abaixo para configurar e provisionar a infraestrutura:

### 1. Pré-requisitos
Certifique-se de ter instalado:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais.

### 2. Configuração Manual do Cloudflare (Uma única vez)
Como o túnel da Cloudflare foi desacoplado para evitar recriações e falhas de DNS:
1. Crie um Cloudflare Tunnel manualmente no console do **Cloudflare Zero Trust**.
2. Roteie o tráfego do seu domínio (ex: `seu-dominio.com` e `www.seu-dominio.com`) para `http://localhost:80`.
3. Crie os registros CNAME apontando para o seu túnel (`<id-do-tunel>.cfargotunnel.com`).
4. Copie o **Tunnel Token**.

### 3. Provisionamento da Infraestrutura
Navegue até o diretório do terraform:
```bash
cd terraform
```

Crie um arquivo `terraform.tfvars` ou configure suas variáveis de ambiente:
```hcl
aws_region              = "sa-east-1"
domain_name             = "seu-dominio.com"
project_name            = "portfolio"
cloudflare_tunnel_token = "SEU_CLOUDFLARE_TUNNEL_TOKEN"
```
*(Ao rodar via GitHub Actions, adicione `CLOUDFLARE_TUNNEL_TOKEN` como secret do repositório e injete-o no pipeline como `TF_VAR_cloudflare_tunnel_token`).*

Inicialize o Terraform (baixa provedores e requisitos de módulo):
```bash
terraform init
```

Revise e implante as alterações:
```bash
terraform plan
terraform apply
```

### 4. Configuração do Servidor
Não é necessário executar o Ansible manualmente do seu computador! A instância EC2 instalará o Ansible e executará localmente o playbook na inicialização (boot) usando as configurações passadas via Cloud-Init. Quando o boot terminar, o Nginx estará no ar e pronto para responder.

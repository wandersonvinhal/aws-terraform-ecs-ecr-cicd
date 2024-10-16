AWS Infrastructure Automation with Terraform and CI/CD using Azure DevOps

Este repositório contém a configuração de infraestrutura como código (IaC) usando Terraform para provisionamento de recursos na AWS. A automação de CI/CD é realizada via Azure DevOps, garantindo a criação, manutenção e atualização contínua da infraestrutura.
Arquivos Terraform

    security.tf: Define regras de grupos de segurança para permitir tráfego HTTP, HTTPS e SSH.
    providers.tf: Configura o provedor AWS para interagir com a infraestrutura.
    output.tf: Contém outputs para expor valores importantes após o provisionamento.
    acm.tf: Gerencia certificados SSL usando o AWS Certificate Manager (ACM).
    datasources.tf: Utiliza dados da AWS, como AMIs e Zonas Route53 existentes.
    ecs.tf: Configura um cluster ECS com tarefas Fargate, IAM Roles e políticas associadas.
    lb.tf: Cria um Load Balancer para rotear tráfego HTTP e HTTPS para serviços ECS.
    main.tf: Contém o arquivo principal que conecta os diferentes recursos definidos.
    network.tf: Configura a rede, incluindo VPC, subnets públicas e privadas, e gateways.
    variables.tf: Define variáveis usadas em vários pontos da configuração.

Arquitetura
Principais componentes:

    VPC: Rede privada virtual que isola os recursos da AWS.
    ECS Cluster: Hospeda containers usando AWS Fargate.
    Load Balancer (ALB): Equilibra o tráfego de rede entre as instâncias do ECS.
    Rota via Route 53: Configuração de DNS para o domínio wandersonvinhal.com.br.
    Segurança: Grupos de segurança e políticas IAM gerenciam permissões de acesso.

Certificado SSL

O certificado SSL é gerado automaticamente para o domínio wandersonvinhal.com.br usando o AWS Certificate Manager (ACM), sendo utilizado pelo Application Load Balancer para tráfego HTTPS.
Pipeline CI/CD

A automação da integração e entrega contínua (CI/CD) foi configurada no Azure DevOps:

    Build Pipeline: Cria imagens Docker e armazena no Amazon Elastic Container Registry (ECR).
    Release Pipeline: Provisiona a infraestrutura usando os arquivos Terraform e implanta a aplicação no ECS.

Azure DevOps Libraries

As Libraries do Azure DevOps foram usadas para armazenar variáveis e segredos de forma segura, como chaves de acesso e IDs de recursos, facilitando a gestão de variáveis reutilizáveis entre diferentes pipelines e ambientes.
Replace Tokens

Durante o processo de Release, a task Replace Tokens foi utilizada para substituir tokens placeholders (_minha_variavel_) em arquivos de configuração por valores reais, definidos nas Libraries do Azure DevOps. Isso permite que o pipeline injete variáveis de ambiente e credenciais nos arquivos do Terraform ou outros scripts.

Como Usar

    Instale as dependências:
        Terraform
        AWS CLI configurado com credenciais apropriadas.

    Configuração:
        Altere as variáveis necessárias em variables.tf para ajustar à sua configuração.

    Execução:
        Execute terraform init para inicializar o ambiente.
        Execute terraform apply para provisionar a infraestrutura.

Requisitos

    Terraform >= 1.0
    AWS Account
    Azure DevOps configurado com acesso ao repositório

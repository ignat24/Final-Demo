# Final-Demo
<h1 align="center">Infrastructure for Telegram Bot</h1>
<h3><b>Objective:</b> using terraform and terragrunt create CI/CD infrastructure on AWS which telegram will use like server</h3>
<hr>
<h1>About project</h1>

- Video presentation on [YouTube](https://youtu.be/44yNo4tiB7E)

- <h3><b>Tools:</b></h3>

    - Terraform
    - Terragrant
    - AWS
    - Docker

<img align="middle" src="https://www.digiseller.ru/preview/749315/p1_3095929_6f6ca7f8.png" width="250" height="200">    <img align="middle" src="https://s.dou.ua/CACHE/images/img/announces/og-image-8b3e4f7d/8044baf16ab50f3584c67fbb3c52b09a.jpg" width="250" height="200">       <img align="middle" src="https://i1.wp.com/dotsandbrackets.com/wp-content/uploads/2016/09/docker.jpg?fit=524%2C447&ssl=1" width="250" height="200">


<hr>

<h1>Infrastructure</h1>

<h2>Cluster</h2>

- ECS cluster with 2 services
- Application Load Balancer with target groups
- Route 53 with domain name

<h2>CodeBuild</h2>

- Project in AWS CodeBuild
- WebHook for GitHub repository
- Source credential

<h2>ECR</h2>

- 2 AWS ECR repository

<h2>Init-Build</h2>

- Null resource (which make first build when we start apply)

<h2>Network</h2>

- VPC
- Public and Private subnets
- NAT and Internet gateway
 
<hr>

<h1>Files structure:</h1>

 - app
    - /bot
        - main.py, text.txt - bot
    - /page
        - index.html, style.css - page

- modules
    - /cluster - create ECS, ALB, IAM, Route53
    - /network - create VPC, Subnets
    - /ecr - create ECR repository
    - /init-build - create first build application
    - /codebuild - create AWS resourse Codebuild with webhook
- providers
    - /dev - create modules structure for terragrunt in environment "Development"
        - terragrunt.hcl - main terragrunt file
        - buildspec.yml - file which contain build configuration for Codebuild
    - /prod - create modules structure for terragrunt in environment "Production"
        - terragrunt.hcl - main terragrunt file
        - buildspec.yml - file which contain build configuration for Codebuild
        
   <hr> 
<h1>Quick start</h1>

<h2>Requirements</h2>

- AWS account and user for terraform with credentials
- Install AWS CLI
    - aws configure
- Terraform (1.0.9)
- Terragrunt (0.35.6)
- Docker
- Domain name
- Route 53 zone with your domain name

<h2>Apply</h2>

- git clone this repo
- cd /providers/dev
"Change main veriables in main terragrunt file(Region, AWS Account, Profile)"
- terragrunt run-all plan (check that always ready to start)
- terragrunt run-all apply

<h2>Check bot</h2>

- Open telegram
- Search @aws_danil_bot
- Write a message "/start"

<hr>
<h1 align="center">Danil Ignatushkin</h1>
<h2 align="center">SoftServe IT Academy 2021</h2>
<h3 align="center">If you have any questions - please write me TG:@ignat244</h3>
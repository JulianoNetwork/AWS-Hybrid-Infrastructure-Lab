# AWS Hybrid Infrastructure Lab

Projeto de infraestrutura em nuvem desenvolvido com AWS e Terraform, com foco em networking, segurança, automação e boas práticas de arquitetura.

## Objetivo

Simular uma infraestrutura corporativa híbrida, utilizando Infrastructure as Code para provisionar e gerenciar recursos AWS.

## Arquitetura atual

- VPC: 10.10.0.0/16
- Public Subnet: 10.10.1.0/24
- Private Subnet: 10.10.10.0/24
- Internet Gateway
- Public Route Table
- Security Groups segmentados
- IAM Identity Center / SSO
- AWS Budget para controle de custos

## Segurança

O projeto utiliza autenticação via IAM Identity Center (SSO), evitando o uso de Access Keys permanentes no código.

A EC2 não será exposta diretamente à Internet.

O Security Group da aplicação permite tráfego HTTP apenas originado pelo Application Load Balancer.

## Status

- [x] Configuração do Terraform
- [x] Autenticação AWS via SSO
- [x] VPC
- [x] Public Subnet
- [x] Private Subnet
- [x] Internet Gateway
- [x] Public Route Table
- [x] Security Groups
- [x] AWS Budget
- [ ] EC2 Linux
- [ ] AWS Systems Manager
- [ ] Nginx
- [ ] Application Load Balancer
- [ ] CloudWatch
- [ ] RDS
- [ ] Auto Scaling
- [ ] Integração híbrida / VPN

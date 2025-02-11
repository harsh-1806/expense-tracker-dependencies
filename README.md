# Infrastructure Deployment and Microservices Setup

This repository contains the infrastructure setup and microservices configuration for deploying a scalable system using AWS CloudFormation, Docker Compose, Kafka, Kong, and PostgreSQL.

## Repository Structure
```
.
├── cloudformation-template-init-infra.yml  # CloudFormation template for infrastructure setup
├── config                                  # Configuration files
├── custom-plugins                          # Custom plugins for Kong
├── kafka                                   # Kafka service configuration
│   └── kafka-compose.yml                   # Docker Compose file for Kafka
├── kong                                    # Kong API Gateway configuration
│   ├── config                              # Kong configuration files
│   │   └── kong.yml                        # Kong configuration file
│   ├── custom-plugins                      # Custom Kong authentication plugin
│   │   └── custom-auth                      
│   │       ├── handler.lua                 # Plugin handler
│   │       └── schema.lua                  # Plugin schema
│   └── kong-compose.yml                     # Docker Compose file for Kong
├── postgres                                # PostgreSQL database setup
│   └── postgres-compose.yml                # Docker Compose file for PostgreSQL
├── services.yml                            # Service definitions
└── user-auth-kafka-postgres                # Microservices configuration
    └── services.yml                        # Service definitions for authentication, Kafka, and PostgreSQL
```

## Deployment Steps

### 1. AWS CloudFormation Deployment
Use the CloudFormation template to deploy the necessary infrastructure on AWS:
```sh
aws cloudformation deploy \
  --template-file cloudformation-template-init-infra.yml \
  --stack-name infra-stack \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2. Docker Compose Setup
Start all necessary services using Docker Compose:
```sh
docker-compose -f kafka/kafka-compose.yml up -d
docker-compose -f kong/kong-compose.yml up -d
docker-compose -f postgres/postgres-compose.yml up -d
```

### 3. API Gateway Configuration
Ensure that Kong is properly configured:
```sh
curl -i -X POST --url http://localhost:8001/services/ \
  --data 'name=user-auth-service' \
  --data 'url=http://user-auth-service:8000'
```

### 4. Running GitHub Actions
This repository includes a GitHub Actions workflow to automate infrastructure deployment. To trigger the deployment, push changes to the `main` branch:
```sh
git push origin main
```

## Features
- **Infrastructure as Code (IaC)** using AWS CloudFormation
- **Microservices-based Architecture** with Kafka, PostgreSQL, and API Gateway (Kong)
- **Custom Authentication Plugin** for Kong API Gateway
- **Automated Deployment** using GitHub Actions

## Contribution
Contributions are welcome! Feel free to open an issue or submit a pull request.

## License
This project is licensed under the MIT License.


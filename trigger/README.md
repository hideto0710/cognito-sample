Cognito Trigger
===

```bash
.
├── README.md                   <-- This instructions file
├── cognito-trigger             <-- Source code for a lambda function
│   ├── app.js                  <-- Lambda function code
│   ├── package.json            <-- NodeJS dependencies
│   └── tests                   <-- Unit tests
│       └── unit
│           └── test_handler.js
└── template.yaml               <-- SAM template for local development
```

## Requirements

* AWS CLI already configured with Administrator permission
* [NodeJS 8.10+ installed](https://nodejs.org/en/download/)
* [Docker installed](https://www.docker.com/community-edition)

## Setup process

### Building the project

[AWS Lambda requires a flat folder](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-create-deployment-pkg.html) with the application as well as its dependencies in a node_modules folder. When you make changes to your source code or dependency manifest,
run the following command to build your project local testing and deployment:
 
```bash
sam build
```

By default, this command writes built artifacts to `.aws-sam/build` folder.

### Local development

**Invoking function locally through local API Gateway**

```bash
sam local start-api
```

```bash
# API
curl -X POST http://127.0.0.1:3000/ -d '{"userName":"h.inamura0710@gmail.com","password":"password"}'

# Trigger
sam local invoke TriggerFunction --event event/cognito.json
```

## Testing

We use `mocha` for testing our code and it is already added in `package.json` under `scripts`, so that we can simply run the following command to run our tests:

```bash
cd hello-world
npm install
npm run test
```

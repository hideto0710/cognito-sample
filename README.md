cognito-sample
===

```
cd trigger
sam build
cd ../tf
terraform init
terraform apply
```

```
cd app
npm install
npm start
```

open
https://hideto0710-sample.auth.ap-northeast-1.amazoncognito.com/login?response_type=code&client_id=<APP_ID>r&redirect_uri=https://localhost:3001/

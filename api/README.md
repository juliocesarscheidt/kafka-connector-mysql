# Golang API

```bash
go mod init github.com/juliocesarscheidt/api
go mod tidy

docker image build --tag api:latest -f Dockerfile .
docker container run --name api -p 5000:5000 api:latest

curl -X POST \
  -H 'Content-type: application/json' \
  --data '{"id": 4000, "name": "teste", "email": "teste@mail.com", "password": "password", "created_at": "2021-08-01 00:00:00", "updated_at": "", "deleted_at": ""}' \
  --url 'http://localhost:5000/v1/users'

curl -X GET --url 'http://localhost:5000/v1/users'
```

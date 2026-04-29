aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 316336724953.dkr.ecr.eu-north-1.amazonaws.com

docker build -t 316336724953.dkr.ecr.eu-north-1.amazonaws.com/log-reader:latest ../docker/log-reader-app/
docker build -t 316336724953.dkr.ecr.eu-north-1.amazonaws.com/log-writer:latest ../docker/log-writer-app/

docker push 316336724953.dkr.ecr.eu-north-1.amazonaws.com/log-reader:latest
docker push 316336724953.dkr.ecr.eu-north-1.amazonaws.com/log-writer:latest
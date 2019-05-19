install-deps:
	sudo apt install -y git curl jq

install-docker:
	curl -s https://test.docker.com | sh

docker-gitlab-run:
	docker run -d \
        -h gitlab.example.com \
        -p 443:443 -p 80:80 -p 22:22 \
        --name gitlab \
        --restart always \
    gitlab/gitlab-ce:latest

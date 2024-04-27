all: $(ENV_FILE) $(DATA) up update-hosts

up:
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

fclean:
	rm -rf $(HOME)/data/wordpress_db
	rm -rf $(HOME)/data/wordpress_files
	docker stop $(docker ps -qa); \
    docker rm $(docker ps -qa); \
    docker rmi -f $(docker images -qa); \
    docker volume rm $(docker volume ls -q); \
    docker network rm $(docker network ls -q) 2>/dev/null
	docker system prune --all --force --volumes
	docker volume prune --force
	docker network prune --force

$(ENV_FILE):
	@echo "Please create the .env file at $(ENV_FILE) with the required environment variables:"
	@echo "# MySQL/MariaDB"
	@echo "DB_DATABASE="
	@echo "DB_HOSTNAME="
	@echo "DB_USER="
	@echo "DB_PASSWORD="
	@echo "# WP Admin"
	@echo "WP_ADMIN_USR="
	@echo "WP_ADMIN_EMAIL="
	@echo "WP_ADMIN_PWD="
	@echo "# WP User"
	@echo "WP_USER_NAME="
	@echo "WP_USER_EMAIL="
	@echo "WP_USER_PASSWORD="
	@exit 1
	
$(DATA):
	mkdir -p $(HOME)/data/wordpress_db
	mkdir -p $(HOME)/data/wordpress_files

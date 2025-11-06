.PHONY: help db-create sh sh-gebib sh-reza sh-projects docker-up docker-down

help: ## Show this help message
	@echo 'Available commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

docker-up: ## Start Docker containers
	docker-compose up -d

docker-down: ## Stop Docker containers
	docker-compose down

db-create: ## Create a database (usage: make db-create DB=mydb)
	@if [ -z "$(DB)" ]; then \
		echo "Error: Please specify database name with DB=name"; \
		echo "Example: make db-create DB=mydb"; \
		exit 1; \
	fi
	@echo "Creating database: $(DB)"
	@docker-compose exec mysql mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS $(DB) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1 | grep -v "Using a password" || true
	@echo "Database '$(DB)' created successfully!"

sh-gebib: ## Open shell in PHP container at gebib directory
	@docker-compose exec -w /var/www/gebib php bash

sh-reza: ## Open shell in PHP container at reza directory
	@docker-compose exec -w /var/www/reza php bash

sh-projects: ## Open shell in PHP container at projects directory
	@docker-compose exec -w /var/www php bash

sh: ## with projects directory selected
	@if [ -z "$(PROJECT)" ]; then \
		echo "Error: Please specify project name with PROJECT=name"; \
		echo "Example: make sh PROJECT=myproject"; \
		exit 1; \
	fi
	@docker-compose exec -w /var/www/$(PROJECT) php bash
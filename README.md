
## Repository Structure

This is a **monorepo** containing multiple Laravel(but can adapt to other project) applications for managing multiple projects 
## Docker Environment

### Architecture
The repository uses a shared Docker Compose setup for development:

```yaml
Services:
  - php: PHP 8.3-FPM container (winkler-php)
  - nginx: Nginx web server on port 80 (winkler-nginx)
  - db: MySQL 8.0 on port 3306 (winkler-mysql)
    - Root password: root
    - Default database: (configured per project)
```

All services share the `winkler-net` bridge network and mount `./projects` to `/var/www`.

### Docker Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Access PHP container
docker-compose exec php bash

# View logs
docker-compose logs -f [service-name]

# Restart services
docker-compose restart
```

### Project-Specific Setup

After starting Docker, set up individual projects:

```bash
# For myproject
make sh PROJECT=myproject
composer install
php artisan migrate --seed

```

### Database Access

**Via MySQL Client:**
```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot
```

### Running Commands in Containers

```bash
# Artisan commands
docker-compose exec php php artisan [command] --path=/var/www/[project]/

# Composer
docker-compose exec php composer install --working-dir=/var/www/[project]/

# Database migrations (per project)
docker-compose exec php php artisan migrate --path=/var/www/[project]/database/migrations
```

## Environment Configuration

Each project requires its own `.env` file with project-specific settings:

## Access url

you can access each app from http://[project-name].localhost 
exemple http://demo.localhost

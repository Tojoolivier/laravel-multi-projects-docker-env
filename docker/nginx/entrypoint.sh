#!/bin/bash
set -e

CONF_DIR="/etc/nginx/conf.d"
CONF_FILE="$CONF_DIR/default.conf"
WATCH_DIR="/var/www"

generate_config() {
  echo "🔄 Generating Nginx config..."
  echo "" > "$CONF_FILE"

  for dir in "$WATCH_DIR"/*; do
    if [ -d "$dir/public" ]; then
      name=$(basename "$dir")
      echo "⚙️  Adding site: $name.localhost"
      cat <<EOF >> "$CONF_FILE"
server {
    listen 80;
    server_name $name.localhost;
    root /var/www/$name/public;

    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}

EOF
    fi
  done
  nginx -s reload || nginx
  echo "✅ Config updated."
}

generate_config
nginx &

echo "👀 Watching for new projects..."
inotifywait -m -e create,delete,move "$WATCH_DIR" | while read -r path action file; do
  echo "📁 Change detected: $file ($action)"
  sleep 1
  generate_config
done

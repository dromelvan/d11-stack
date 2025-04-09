chmod +x ./postgres/init_database.sh

read -sp "Stack password: " PASSWORD
echo

export PASSWORD

docker compose up -d

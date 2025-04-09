if [ -d "d11-boot" ]; then
    rm -rf d11-boot
fi

git clone https://github.com/dromelvan/d11-boot.git d11-boot
cp -r secrets/* d11-boot

cd d11-boot
./gradlew bootJar
cd ..

# We don't need password when building the image. Set it to empty string to avoid warning
PASSWORD=""
export PASSWORD

docker compose build

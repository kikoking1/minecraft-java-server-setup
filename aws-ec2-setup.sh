#!/bin/bash

# For minecrafter java edition, version 1.21.10

MINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/95495a7f485eedd84ce928cef5e223b757d2f764/server.jar

# Download Java
sudo yum install -y java-21-amazon-corretto-headless
# Install MC Java server in a directory we create
sudo mkdir /opt/minecraft/
sudo mkdir /opt/minecraft/server/
cd /opt/minecraft/server

# Download server jar file from Minecraft official website
wget $MINECRAFTSERVERURL

# Generate Minecraft server files and create script
chown -R ec2-user:ec2-user /opt/minecraft/
java -Xmx1024M -Xms1024M -jar server.jar nogui
sed -i 's/false/true/p' eula.txt
sed -i -e 's/pvp=true/pvp=false/g' server.properties
touch start
printf '#!/bin/bash\njava -Xmx1024M -Xms1024M -jar server.jar nogui \n' >> start
chmod +x start
touch stop
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")' >> stop
chmod +x stop

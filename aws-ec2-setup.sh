#!/bin/bash

# For minecrafter java edition, version 1.20.1

MINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar

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
java -Xmx1300M -Xms1300M -jar server.jar nogui
sed -i 's/false/true/p' eula.txt
sed -i -e 's/pvp=true/pvp=false/g' server.properties
touch start
printf '#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n' >> start
chmod +x start
touch stop
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")' >> stop
chmod +x stop

# Create SystemD Script to run Minecraft server jar on reboot
cd /etc/systemd/system/
sudo bash -c 'printf "[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=ec2-user\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target" >> minecraft.service'
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

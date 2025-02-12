function minecraft_backup {
ssh -i ~/.ssh/my_aws/kiko_minecraft_aws_key.pem ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com -t '\
cd /opt/minecraft/server && \
sudo ./stop && \
zip -r world world'

scp -i ~/.ssh/my_aws/kiko_minecraft_aws_key.pem ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com:/opt/minecraft/server/world.zip ~/projects/minecraft-java-server-setup/backups/world.zip

ssh -i ~/.ssh/my_aws/kiko_minecraft_aws_key.pem ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com -t '\
sudo reboot'
}

function minecraft_restore {
scp -i ~/.ssh/my_aws/my_minecraft_aws_key.pem ~/projects/minecraft-java-server-setup/backups/world.zip ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com:/opt/minecraft/server/world.zip

ssh -i ~/.ssh/my_aws/my_minecraft_aws_key.pem ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com -t '\
cd /opt/minecraft/server && \
sudo ./stop && \
sudo rm -rf ./world && \
unzip ./world.zip && \
sudo rm -f ./world.zip && \
sudo reboot'
}

function minecraft_connect {
ssh -i ~/.ssh/id_ed25519_kikomc root@mc.mediabot.ca
}

function minecraft_changeworld_from_to {

if [[ "$#" -ne 2 ]]; then
  echo "Incorrect number of arguments. Please provide first param as {new-filename-of-world-changing-from} and 2nd as {existing-filename-of-world-changing-to}"
elif [[ "$1" == "$2" ]]; then
  echo "inputs cannot match"
else
  echo "happy path"

# backs up world on server, to local
ssh -i ~/.ssh/id_ed25519_kikomc root@mc.mediabot.ca -t '\
cd /opt/minecraft/server && \
(sudo ./stop || echo "minecraft server is not currently running")
(killall screen || echo "no screens to kill") && \
zip -r world world'

scp -i ~/.ssh/id_ed25519_kikomc root@mc.mediabot.ca:/opt/minecraft/server/world.zip ~/projects/minecraft-java-server-setup/backups/world.zip

ssh -i ~/.ssh/id_ed25519_kikomc root@mc.mediabot.ca -t '
cd /opt/minecraft/server && \
unzip ./world.zip && \
sudo rm -rf ./world.zip'

# rename files
from=$1
to=$2

mv world.zip ${from}.zip
mv ${to}.zip world.zip

# make newly loaded local world.zip to be what's on the server
minecraft_restore
fi

}


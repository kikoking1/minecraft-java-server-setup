function minecraft_backup {
ssh -i ~/.ssh/my_aws/my_minecraft_aws_key.pem ec2-user@ec2-11-11-11-111.us-west-2.compute.amazonaws.com -t '\
cd /opt/minecraft/server && \
sudo ./stop && \
zip -r world world && \
sudo reboot'

scp -i ~/.ssh/my_aws/my_minecraft_aws_key.pem ec2-user@ec2-11-11-l1-111.us-west-2.compute.amazonaws.com:/opt/minecraft/server/world.zip ~/projects/minecraft-java-server-setup/backups/world.zip
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

# How to Setup a Minecraft Java Edition Server on AWS

## Create an EC2 Instance on AWS
- Chose Amazon Linux
- Choose ARM architecture
- Choose Security Group with port 22 open to your ip address, and port 25565 open to the world
- Choose t4g.medium server size
- Choose Key Pair
- Expand Advanced Options, go to user script setion, paste in contents of `aws-ec2-setup.sh`
- Launch instance
- Allocate Elastic IP if you want

## Backup and Restore
- See `utility-commands.sh` for example functions you can put into local machine ~/.zshrc, or ~/.bashrc

## Keeping it Cheap
- Stopping the instance when not in use, then restarting, makes it cheaper
    - You don't have to do backup and restore of world/ if you Stop and Start the instance, but it does force ip address change unless you use Elastic IP

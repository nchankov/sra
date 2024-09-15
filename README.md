# Server Resource Alert Script

This is a bash script used to monitoring and reporting problems in the server resources.

Currently the script monitors the server load and disk usage parameters

## Requirements:

1. curl - used to post data. Usually it's installed already
```
apt install curl
```

2. mail - used to send emails
```
sudo apt install mailutils
```

2. install who - used to identify the logged in user's ip
```
apt install who
```

## Instalation:

1. clone the repository on the server which you would like to monitor
```
git clone https://github.com/nchankov/sra.git
```

2. copy .env.sample to .env and modify the variables if needed. Usually 
   you have to set the email address (check Requirements point 2) and
   pushbullet token (check Requirements point 1)

3. if you want to allow certain IPs to be skipped when the user is logged 
   in, then create .ip file (or copy the .ip.sample) and enter the allowed
   IPs one at a row. You can use partial IPs e.g. 192.168 and it would 
   match all ip starting with that

2. Run activate.sh in the sra directory
```
./activate.sh
```
This will add a file sra into /etc/cron.d directory which will report
the resources as well as it will add a file into /etc/profile.d which
will report if a loggin happened on the machine

3. Run deactivate.sh if you want to stop reporting
```
./deactivate.sh
```
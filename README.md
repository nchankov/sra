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

3. 

Then add this script into your crontab

```
crontab -e
```

Add the following line in the crontab

```
*/15 * * * * /path/to/the/script/sra.sh -e=email@server.com
```

This will run the script on every 15 minutes and will check the server load and disk 
usage and if there are problems, it will send a notification email to the specified email

## Options:

-e= or --email=EMAIL          - email which will be notified. If no email is specified the message will be printed on the screen.

-p, --processors=DECIMAL      decimal value where 1 represent full load. Defailt value is 0.8

-u, --usage=NUMBER            percentage of the disk usage. where 100 is no space left. Default value is 90

-s, --subject=STRING          subject sent to the email. Default Value is: "Alert the server experience troubles"

-?, -h, --help                command explanation


## Default tresholds are:

### Processors
0.8 for each processor (it automatically multiply that number by number of cores so if
your server has 4 cores it will send email if the load is more than 3.2.
Note that this will monitor the long term load (15 min) of the processors, so short spikes
won't be reported. You can adjust the treshold by editing the file

### Disk usage
90% of the disk capacity is full - it will check all of the disks and will send a combined report
for disks matching that criteria

If you run the script on the terminal without specifying the email as parameter,
it will print the warnings on the terminal (useful for checking/debuging purposes)

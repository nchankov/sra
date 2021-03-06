# Server Resource Alert Script

This is a bash script used to monitoring and reporting problems in the server resources.

Currently the script monitors the server load and disk usage parameters

## Instalation:

clone the repository on the server which you would like to monitor

```
git clone https://github.com/nchankov/sra.git
```

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

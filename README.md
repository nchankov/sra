# Server Resource Alert

This is a bash script used to monitoring and reporting problems in the server resources.

Currently the script monitors the server load and disk usage parameters

## Instalation:

clone the repository on the server which you would like to monitor

```
git clone git@github.com:nchankov/sra.git
```

Then add this script into your crontab

```
crontab -e
```

Add the following line in the crontab

```
*/15 * * * * /path/to/the/script/sra.sh email@server.com
```

This will run the script on every 15 minutes and will check the server load and disk 
usage and if there are problems, it will send a notification email to the specified email

The tresholds are:

### Processors
0.8 for each processor (it automatically multiply that number by number of cores so if
your server has 4 cores it will send email if the load is more than 3.2

### Disk usage
90% of the disk capacity is full - it will check all of the disks and will send a combined report
for disks matching that criteria

If you run the script on the terminal without specifying the email as parameter,
it will print the warnings on the terminal (useful for checking/debuging purposes)


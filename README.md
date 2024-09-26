# Server Resource Alert Script

This is a bash script used for monitoring and reporting problems in the server resources.
The script report on 3 activities:

1. Resources exceed a threshould. Resources reported are: 
   processor utilization, memory utilization and disk capacity

   Use this to get notification if the server experience troubles. So you can act accordingly

2. report if some login into the server

   Use this for early notification if your server is hacked

3. report of changed files in specific locations. 

   Use this to monitor "hackable" locations such as Wordpress or other OpenSource projects which 
   contain risk of hacking


## Requirements:

1. curl - used to post data. Usually it's installed already
```
apt install curl
```

2. mail - used to send emails. Bear in mind you have to configure it properly
   otherwise the emails could land in the spam folder
```
sudo apt install mailutils
```

2. who - used to identify the logged in user's ip
```
apt install who
```

3. install bc if it's not installed
```
apt install bc
```
it helps calculating the memory usage

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
This will add 2 sra.* files into /etc/cron.d directory which will report
the resources and location scan as well as it will add a file into /etc/profile.d which
will report if a loggin happened on the machine

3. Run deactivate.sh if you want to stop reporting
```
./deactivate.sh
```

## Locations

1. Use the following script to add location for scan:
```
./add.location.sh [location_directory extensions]
```
you can skip the parameters and the script will promptly ask about them and follow the
instructions on the screen.

2. If you want to list the existing locations use
```
./list.locations.sh
```
it will show you the list of all locations and extensions and exeptions

3. If you want to remove location from scanning use
```
./remove.location.sh [location_directory]
```
it will remove all occurances of that location.

N.B. The locations are stored in ./locations directorywith extension *.loc. You can also remove a location by deleting the file

## monitor.sh - script which will print the resources of the server in a json file format
it's useful if you need to build a web reporting tool

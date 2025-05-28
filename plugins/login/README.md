# SRA Login plugin

Plugin which monitor logins into the server. If there is an ssh login, the plugin would report the entry. It's usefult 
for early detection of unauthorized access to the server.

In case you want to prevent reporting for login from a specific IP or part of an IP, you can set it in the .ip file.

Create an .ip (use the .ip.example) and set an ip or part of an IP which would be known so won't be reported e.g.

```
192.168.0.10 #this would prevent reporting from a specific ip
```
or 
```
192.168 # this would prevent reporting from any ip starting with 192.168
```
N.B. Make sure there is a last line in the .ip file as otherwise the last rule wouldn't be applied.
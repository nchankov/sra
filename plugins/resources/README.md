# SRA Resources plugin

Plugin which monitor server resources of the server. The following resources would be monitored:

1. Processor load
2. Memory used
3. Disk capacity

Set .env in the plugin directory in order the plugin to be used. Use the .env.sample as a template. By default the 
values in the .env.sample are sufficient

If the resource exceed the threshould it would report it only once, once the resource is back to normal and go 
again the above the threshold it would report it again. This would prevent overloading the channels with messages.
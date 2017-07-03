# basher
simple bash program to easy run and add new shell scripts 


install 

```
sudo mkdir /var/lib/basher && \
sudo curl -o /var/lib/basher/basher https://raw.githubusercontent.com/dalibor91/basher/master/basher.sh && \
sudo chmod +x /var/lib/basher/basher && \
sudo ln -s /var/lib/basher/basher /usr/bin/basher
```

You can easy manage and download thousands of bash scripts and use them easily 

Example of use 
Download test shell script 
```
root@vg# basher add 'https://raw.githubusercontent.com/dalibor91/basher/master/basher_test.sh'
Description:
basher test script
--2017-06-30 17:38:12--  https://raw.githubusercontent.com/dalibor91/basher/master/basher_test.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.0.133, 151.101.64.133, 151.101.128.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.0.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 98 [text/plain]
Saving to: `/root/.basher/scripts/2017_06_30_17_38_07.sh'

100%[====================================================================================================================================================================================================================================================================================>] 98          --.-K/s   in 0s

2017-06-30 17:38:12 (15.4 MB/s) - `/root/.basher/scripts/2017_06_30_17_38_07.sh' saved [98/98]

Enter command name to run like:
basher laskjd this is not valid 
Enter command name to run like:
basher_test
```

To see all installed scripts run:
```
root@vg# basher list
Alias: basher_test
```

To see details of some specific script run
```
root@vg# basher explain basher_test
Downlaoded from
https://raw.githubusercontent.com/dalibor91/basher/master/basher_test.sh
--------------------------
basher test script
```

To run script run 
```
root@vg# basher run basher_test 123 456 6789 000
Argument 0 /root/.basher/scripts/2017_06_30_17_38_07.sh
Argument 1 123
Argument 2 456
Argument 3 6789
```

To remove script run
```
root@vg# basher remove basher_test
Removed!
```

To see all options run 
```
root@vg# basher
basher list
	lists all availible options
basher add url
	downloads script from url and saves it
basher run <alias> [arguments]
	runs some script
basher explain <alias>
	prints description and url we used to download this script
basher remove <alias>
	removes some script
```

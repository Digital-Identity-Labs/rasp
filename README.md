

```apacheconfig
 LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" combined
 +  CustomLog /proc/self/fd/1 combined
 +  ErrorLog /proc/self/fd/2
```
 
 
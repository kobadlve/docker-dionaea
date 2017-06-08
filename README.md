# dionaea-docker

Dockerfile for dionaea.

## Build
`$ docker build -t dionaea .`

## Run

```
$ docker run -u dionaea -it -p 21:21 -p 42:42 -p 69:69/udp -p 80:80 -p 135:135 -p 443:443 -p 445:445 -p 1433:1433 -p 1723:1723 -p 1883:1883 -p 1900:1900/udp -p 3306:3306 -p 5060:5060 -p 5060:5060/udp -p 5061:5061 -p 11211:11211 dionaea
```

## Start Dionaea
```
container$ /opt/dionaea/bin/dionaea -D
Ctrl-p, q (detach)
```

Check

```
$ nmap localhost

Starting Nmap 7.40 ( https://nmap.org ) at 2017-06-07 15:49 JST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00023s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 987 closed ports
PORT      STATE SERVICE
21/tcp    open  ftp
42/tcp    open  nameserver
80/tcp    open  http
135/tcp   open  msrpc
443/tcp   open  https
445/tcp   open  microsoft-ds
1433/tcp  open  ms-sql-s
1723/tcp  open  pptp
3306/tcp  open  mysql
5060/tcp  open  sip
5061/tcp  open  sip-tls
49152/tcp open  unknown
49153/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 9.25 seconds
```

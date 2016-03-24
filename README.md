# Docker PHPMyAdmin running running using PHP 7 + NGINX

* NGINX stable
* PHP 7
* PHPMyAdmin 4.6.0 (configurable with Environment Variable)

## Installation
```
$ docker build -t ahirmayur/phpmyadmin . # If building from source 
$ docker run -d --link my-mysql-container:mysql -e MYSQL_USERNAME=root --name phpmyadmin -p 22 -p 80 ahirmayur/phpmyadmin
5f1b7a6404c8

$ docker port 5f1b7a6404c8 22
0.0.0.0:32771

$ ssh root@localhost -p 32771 # when promoted for password enter 'root' (without quotes)
```
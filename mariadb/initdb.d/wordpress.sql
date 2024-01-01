create database if not exists wordpress;
use wordpress;
create user if not exists 'wpadmin' identified by 'wppasswd';
grant all privileges on wordpress.* to 'wpadmin'@'%';

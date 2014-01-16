#!/usr/bin/expect

set home "/home/ccarp001/"
set prompt "(\\$|:|#|%) $"

spawn scp /home/ccarp001/.ssh/id_dsa.pub $argv:$home
expect {
  "yes/no"
   { send "yes\r";exp_continue }
 
  "password:"
   { send "\r" }
}
expect {
  "password:"
  { send "today01\r" }
}
 
spawn ssh -t $argv "mkdir .ssh; chmod 750 .ssh;mv id_dsa.pub .ssh/;cd .ssh;ln -s id_dsa.pub authorized_keys;ln -s id_dsa.pub authorized_keys2;"

expect {
   "password:"
   { send "\r" }
}
expect {
   "password:"
   { send "today01\r" }
}
expect {
   $prompt { send "hostname" } 
}

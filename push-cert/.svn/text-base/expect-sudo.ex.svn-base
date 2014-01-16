#!/usr/bin/expect

set home "/home/curt/"
set uid "curt"

spawn ssh -t [lindex $argv 0]
expect "$ "
send "sudo su\r"
expect "$ "
send "echo '$uid  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers\r"
expect "$ "
send "exit\r"
send "exit\r"

#!/bin/bash

#
#setup profile for server
#

UNAME=`uname`
PROFILEVER='profile-1.1.txt'

if [ -d /home/curt ]; then
cd /home/curt
elif [ -d /users/curt ]; then
cd /users/curt
elif [-d /home/auto/curt ]; then
cd /home/auto/curt
else
echo "cannot find home dir, exiting."; exit;
fi

if [ -x "$PROFILEVER" ]; then
exit
else
rm -f profile-1.*.txt
touch $PROFILEVER
fi

#work area mtr01s2eap
#LINUX CONFIG
if [ "$UNAME" == 'Linux' ]; then
  echo -e "# .bashrc\n# Source global definitions\n if [ -f /etc/bashrc ]; then\n . /etc/bashrc\n fi\n\n#PATH\nexport PATH=$PATH:/sbin:/usr/sbin\n#SHELL\nif [ -f /bin/bash ]; then\nexport SHELL=/bin/bash\nfi\n\n# User specific aliases and functions\nalias ll=\"ls -la\"\nalias df=\"df -h\"\nalias topmem='ps aux | awk \"{print \\$2, \\$4, \\$11}\" | sort -k2rn | head'\nalias topcpu='ps aux | awk \"{print \\$2, \\$3, \\$11}\" | sort -k2rn | head'\nalias topio='iostat -d | gawk \"{print \\$1, \\$2, \\$3, \\$4}\" | sort -k2nr | head' " > .bashrc
  echo -e "if [ -f ~/.bashrc ]; then\n. ~/.bashrc\nfi\n" > .bash_profile
  echo -e "colorscheme desert\nsyntax on\n" > .virc
  echo -e "colorscheme desert\nsyntax on\n" > .vimrc
  if [ ! -d scripts ]; then
    mkdir scripts
  fi
  if [ ! -d .ssh ]; then
    mkdir .ssh
    chmod 750 .ssh
    chown curt .ssh scripts .virc .vimrc .bash_profile
  fi
#AIX CONFIG
elif [ "$UNAME" == 'AIX' ]; then
  if [ -e /bin/bash ]; then
    echo "# .bashrc\n# Source global definitions\nif [ -f /etc/bashrc ]; then\n . /etc/bashrc\nfi\n\n#PATH\nexport PATH=$PATH:/sbin:/usr/sbin\n#SHELL\nif [ -f /bin/bash ]; then\nexport SHELL=/bin/bash\nfi\n\n# User specific aliases and functions\nalias ll=\"ls -la\"\nalias df=\"df -h\"\nalias topmem=\"ps aux | awk '{print \$2, \$4, \$11}' | sort -k2rn | head\"\n alias topcpu=\"ps aux | awk '{print \$2, \$3, \$11}' | sort -k2rn | head\"\nalias topio=\"iostat -d | gawk '{print \$1, \$2, \$3, \$4}' | sort -k2nr | head\" " > .bashrc
    echo "if [ -f ~/.bashrc ]; then\n. ~/.bashrc\nfi\n" > .bash_profile
  elif [ "$SHELL" == '/usr/bin/ksh' ]; then
  echo "# PATH\nset PATH=$PATH:/sbin:/usr/sbin\n#alias\nalias ll='ls -la';\nalias topmem='ps -eo \"%u %c %p %z\" | sort -k4nr | head';\nalias topcpu='ps -eo \"%u %c %p %C\" | sort -k4nr | head';\n" > .profile
  fi
  echo "colorscheme desert\nsyntax on\n" > .virc
  echo "colorscheme desert\nsyntax on\n" > .vimrc
  if [ ! -d scripts ]; then
    mkdir scripts
  fi
  if [ ! -d .ssh ]; then
    mkdir .ssh
    chmod 750 .ssh
    chown curt .ssh scripts .virc .vimrc .profile .bash_profile
  fi
#HP-UX CONFIG
elif [ "$UNAME" == 'HP-UX' ]; then
  echo "#PATH\n set PATH=$PATH:/sbin:/usr/sbin\n  #alias alias ll='ls -la';\n alias topmem='ps -eo \"%u %c %p %z\" | sort -k4nr | head';\n alias topcpu='ps -eo \"%u %c %p %C\" | sort -k4nr | head';\n" > .profile
  echo "colorscheme desert\nsyntax on\n" > .virc
  echo "colorscheme desert\nsyntax on\n" > .vimrc
  if [ ! -d scripts ]; then
    mkdir scripts
  fi
  if [ ! -d .ssh ]; then
    mkdir .ssh
    chmod 750 .ssh
    chown curt .ssh .virc .vimrc .profile scripts

  fi
else
  echo "$UNAME shell not found"
fi

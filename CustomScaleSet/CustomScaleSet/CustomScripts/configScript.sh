# Custom Script for Linux
#!/bin/bash

# exit on any error
set -e

echo "Welcome to configuressl.sh"
echo "Number of parameters was: " $#

if [ $# -ne 3 ]; then
    echo usage: $0 {sasuri}      
	exit 1
fi

update_nodeapp(){

curl $1 /nodeserver

}


update_nodeapp


echo "restarting node"

systemctl restart mainsite.service
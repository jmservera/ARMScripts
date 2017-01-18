# Custom Script for Linux
#!/bin/bash

# exit on any error
set -e

echo "Welcome to configuressl.sh"
echo "Number of parameters was: " $#

if [ $# -ne 1 ]; then
    echo usage: $0 {sasuri}
        exit 1
fi

echo "url" $1

update_nodeapp(){

curl -o /nodeserver/hello.js $1

}


update_nodeapp $1


echo "restarting node"

systemctl restart mainsite.service

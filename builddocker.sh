#!/bin/bash
echo -n "Type app version to build: "
read ver
docker build -t greeter:$ver .
echo -n "Do you want to run the app Y/N: "
read ans
case $ans in
Y | y) echo "Launch the app by opening the URL: http://localhost:8080"; docker run -p 8080:8080 greeter:$ver;; 
esac

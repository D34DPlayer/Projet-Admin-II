#!/bin/bash

while true
do
    sleep 10
    for f in $(ls ./testScripts); do
        bash "./testScripts/$f"
    done
done

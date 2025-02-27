#!/bin/bash

while true
do
    find lib/ -name '*.dart' | \
        entr -d -p scripts/hotreloader.sh /_
done

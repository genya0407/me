#!/bin/bash

./update.sh
busybox crond -L /dev/stderr -f

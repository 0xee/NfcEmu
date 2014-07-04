#!/bin/bash

./apdu_echo.py &

sleep 1

./cmd_query.py 1 quick_cmd.txt #apdu_test.txt

killall apdu_echo.py



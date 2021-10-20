#!/bin/bash

while true
do
    current_date=$(date)
    echo $current_date
    echo "L6pKnrJnoVV5" | /home/validator/go/bin/<deamon-name> tx distribution withdraw-rewards <...valoper...> --from <key-name> --commission --gas auto --chain-id <chain-ID> -y
    sleep 5s
    available_coin=$(/home/validator/go/bin/evmosd q bank balances <validator-address> | awk '/amount:/{print $NF}' | tr -d '"')
    echo "L6pKnrJnoVV5" | /home/validator/go/bin/evmosd tx staking delegate <...valoper...> ${available_coin}<coin-name> --chain-id=<chain-ID> --from <key-name> --gas auto -y
    echo "$current_date : Delegating $available_coin"
    sleep 10m
done

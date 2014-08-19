#!/bin/bash

fqdn=$1
aa=$(shipyard-agent -url http://$fqdn:8000 -register 2>&1 )
key=`echo ${aa##* }`
shipyard-agent -url http://$fqdn:8000 -key $key &

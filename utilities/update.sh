#!/usr/bin/bash 
helm upgrade --namespace worstpress wordpress -f application/values.yml stable/wordpress

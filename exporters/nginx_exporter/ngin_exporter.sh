#!/bin/bash
nohup nginx-prometheus-exporter -nginx.scrape-uri http://127.0.0.1:8080/nginx_status &>/var/log/nginx-exporter.log
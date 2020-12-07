#!/bin/bash

set -e
set -x


python -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < prometheus.yml

exec $cmd
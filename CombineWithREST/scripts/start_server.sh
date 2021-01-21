#!/bin/bash

mkdir -p "tmp"

pact-mock-service start --pact-specification-version 2.0.0 --log "tmp/pact.log" --pact-dir "tmp/pacts" -p 1234

#!/bin/bash

for x in $(ls ../kubernetes/*.yml); do
	kubectl create -f $x
done

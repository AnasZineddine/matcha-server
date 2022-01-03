#!/bin/bash
set -B
for i in {1..50}; do
	curl -o $i-woman.jpg https://randomuser.me/api/portraits/women/$i.jpg
done

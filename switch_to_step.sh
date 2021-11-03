#!/bin/bash

pattern="s/step[0-9]*/step${1}/"
sed -i.bak $pattern .rubocop.yml
rm .rubocop.yml.bak

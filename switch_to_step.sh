#!/bin/bash

pattern="s/step[0-9]/step${1}/"
sed -i $pattern .rubocop.yml
#!/bin/bash

rm -rf public
mkdir public
cp -r site/assets public/assets
cp -r docs public/docs
java -jar lib/saxon-he-10.6.jar  -xsl:xsl/main.xsl -it:main

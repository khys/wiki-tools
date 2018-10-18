#!/bin/bash

for file in $(ls wiki/*); do
    ginstall -p -D $file wiki_mod/`./lswiki.pl -f euc-jp -s $file`
done

for file in $(find wiki_mod/wiki -type f); do
    iconv -f EUCJP -t UTF8 $file > $file.utf8;
    mv $file.utf8 $file;
done

find wiki_mod/wiki -type f | xargs gsed -i -e 's/ \[#[0-9a-z]\+\]$//g' -e 's/^\*\*\*/###/g' -e 's/^\*\*/##/g' -e 's/^\*/#/g' -e 's/^.*----.*$/___/g' -e 's/^---/    -/g' -e 's/^--/  -/g' -e 's/^\(\s*\)-\([^ ]\)/\1- \2/g' -e 's/^\(\s*\)+\([^ ]\)/\1+ \2/g' -e 's/&br;/<br>/g' -e 's/#br//g' -e 's/^#pre{*/```/g' -e 's/^}}*/```/g' -e 's/~/  /g' -e 's/%%/~~/g' -e "s/^\/\/.*$//" -e "s/^\#lsx/`echo -ne '\u0024'`lsx()/g"

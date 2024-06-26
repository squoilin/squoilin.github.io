#!/bin/bash

# get report

wget -O temp.html "https://orbi.uliege.be/reports?action=1&conjunction_1=AND&field_1=author_authority&value_1_authority=&value_1=u203754&year_start=&year_end=&references=&model=none&format=apa&abstract_length=&sort_1=issued_dt%3Adesc&sort_1=author_sort%3Aasc&sort_1=title_sort%3Aasc&output=html&lang_report=en&title=Publications+and+communications+of+Sylvain+Quoilin" 
head -n -1 temp.html > temp2.html
tail -n +1 temp2.html > temp3.html

# Remove the first characters until the "</h1>" tag is detected. Write the other lines as such.
while IFS= read -r line; do
  if [[ "$line" == *"</h1>"* ]]; then
    echo "${line##*</h1>}" > temp3.html
  else
    echo $line >> temp3.html
  fi
done < temp2.html

#lynx -dump temp3.html    

cat publ_header.md | cat - temp3.html | cat - publ_footer.md > ../_pages/publications.md             # change scripts by _pages

git commit -a -m"Updating publications"
git push

rm -f temp.html temp2.html temp3.html wget-log

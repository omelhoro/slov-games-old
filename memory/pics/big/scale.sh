for i in $( ls *.jpg); do  convert -resize 300 $i ../$i; done

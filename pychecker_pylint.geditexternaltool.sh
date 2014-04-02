#!/bin/bash
#echo "gEdit fait appel a l'outil exterieur (PyChecker & PyLint) avec le fichier suivant : $GEDIT_CURRENT_DOCUMENT_PATH"

file="$GEDIT_CURRENT_DOCUMENT_PATH"
if [ "X$file" = "X" ]
then
 file="$1"
fi
if [ "X$file" = "X" ]
then
 echo "Error: No file given." > /dev/stderr
 exit 2
fi
title="gEdit (Interpreteur)"
tmpfile_xml="/tmp/"$file".annotation.xml"
tmpfile_annot="/tmp/"$file".annoted"

crdir="$GEDIT_CURRENT_DOCUMENT_DIR"
if [ "X$crdir" = "X" ]
then
 crdir="`pwd -P`"
fi
cd "$crdir"

echo "### 1 PyLint ###"
/usr/bin/pylint -f text --files-output=n "$file"
echo "################"

#echo "### 2 PyChecker ###"
#pychecker -# 100 -t -9 -v -g -n -a -I -1 -A --changetypes "$file"
#echo "###################"

echo "### 3 Pyntch ###"
tchecker.py "$file" 2> /dev/null
echo "################"

echo "### 4 Pyntch Annotation ###"
tchecker.py -o "$tmpfile_xml" "$file" 2> /dev/null && \
 annot.py "$tmpfile_xml" "$file" > "$tmpfile_annot" && \
 colordiff "$file" "$tmpfile_annot"
echo "###########################"

echo "### 5 PyFlakes ###"
pyflakes "$file"
echo "##################"

echo -e "\n\n ==> An annoted file has been produced :"
echo -e "$tmpfile_annot:1"

# DONE
# Made by Lilian BESSON
#  https:sites.google.com/site/naereencorp/

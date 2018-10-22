#!/usr/bin/env bash

function pdfinfo (){
    for i in "$@"; do
        echo -e "\n${green}# For '${red}${u}$i${U}${white}':";
        /usr/bin/pdfinfo "$i";
    done
}

nbOfPDF=$(ls -larth **/*.pdf | wc -l)
nbOfPages=$(pdfinfo **/*.pdf | grep 'Pages:' | awk '{print $2}' | paste -sd+ | bc)
echo -e "For ${nbOfPDF} PDF documents, the total number of pages is = ${nbOfPages}..."

#!/usr/bin/env bash
# By: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 06-11-2014
#
# autonomize.sh, a small tool to be used with autonomize.sh to produce autonomous latex document from autotex-powered document (it adds all the necessary headers)
#
# Online: https://bitbucket.org/lbesson/bin/src/master/autonomize.sh
#
# More informations on autotex here: https://bitbucket.org/lbesson/bin/src/master/autotex
#
# Example of a LaTeX2e template to use with autonomize.sh :
# (http://besson.qc.to/publis/latex/template_minimalist.tex)
#
# Licence: [GPLv3](http://besson.qc.to/LICENCE.html)
#
version='0.1'
clear

template="${HOME}/template_minimalist.tex"
arg="${1}"

name="${arg%.en.tex}"
# name="${name%.fr.tex}"
# name="${name%.tex}"

out="${name}__autonomize.en.tex"
mv -vf "${out}" /tmp/

## First n lines of the template
# firstNlines=$(grep -n 'input{MyFileNameToChangeWithAutonomizeSh.tex}' "${template}" | grep -o "^[0-9]*")
# firstNlines=$(( firstNlines - 2 ))
# echo -e "${yellow}Using the first ${firstNlines} lines of the template ${template}."
# head -n ${firstNlines} "${template}" > "${out}"
# # cat "${template}" > "${out}"

echo -e "${yellow}From the file ${arg}, we change it a little bit, to make it more standard and more autonomous"
## Edit the input file
## From autotex, change title, police size, scale
## From naereen.sty, slowly change every macros, clean up macro and non conventional files
cat "${arg}" \
    | sed s/'\\inv{\(.*\)}'/'\\frac{1}{\1}'/g \
    | sed s/'\\e^'/'\\mathrm{e}^'/g \
    | sed s/'\\dx'/'\\mathrm{d}x'/g \
    | sed s/'\\dy'/'\\mathrm{d}y'/g \
    | sed s/'\\dz'/'\\mathrm{d}z'/g \
    | sed s/'\\dt'/'\\mathrm{d}t'/g \
    | sed s/'\\arccosh'/'\\mathop{\\mathrm{arccosh}}'/g \
    | sed s/'\\arcsinh'/'\\mathop{\\mathrm{arcsinh}}'/g \
    | sed s/'\\arctanh'/'\\mathop{\\mathrm{arctanh}}'/g \
    >> "${out}"
    # | sed s/'\\cosh'/'\\mathop{\\mathrm{cosh}}'/g \
    # | sed s/'\\sinh'/'\\mathop{\\mathrm{sinh}}'/g \
    # | sed s/'\\tanh'/'\\mathop{\\mathrm{tanh}}'/g \

## Closing documents
# echo -e "\n\\\\end{document}" >> "${out}"

echo -e "${green}Done: new file is ${out}.${white}"
colordiff "${arg}" "${out}"
subl "${out}"

## End of autonomize.sh

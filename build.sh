#!/bin/bash

start=`date +%s.%N`
built=false
while getopts "fql" opt; do
	case $opt in
		f)
			echo "full compilation"
			echo "----------------"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			echo "done"
			echo -n "biber...        "
			biber main > /dev/null 2>&1
			echo "done"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			echo "done"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			echo "done"
			built=true
			;;
		q)
			echo "quick compilation"
			echo "-----------------"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			echo "done"
			built=true
			;;
		k)
			echo "keeping output files"
			remove_intermediate_files=false
			;;
		\?)
			echo "invalid option: -$opt"
			exit 1
			;;
	esac
done

if [ "$built" ==  false ] ; then
	echo "nothing was done"
	echo "flags:"
	echo "-q for quick compilaton"
	echo "-f for full compilation"
	echo "-k to keep intermediate files"
	exit 0
fi

if $remove_intermediate_files ; then
	echo -n "cleaning up...  "
	rm main.aux main.bbl main.bcf main.blg main.out main.run.xml main.synctex.gz > /dev/null 2>&1
	echo "done"
fi

end=`date +%s.%N`
echo -n "runtime: "
echo $( echo "$end - $start" | bc -l )
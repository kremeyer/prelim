#!/bin/bash

start=`date +%s.%N`

built=false
open_pdf=false

while getopts "fqkoc" opt; do
	case $opt in
		c)
			echo -n "cleaning up...  "
			rm main.aux main.bbl main.bcf main.blg main.out main.run.xml main.synctex.gz > /dev/null 2>&1
			echo "done"
			;;
		f)
			echo "full compilation"
			echo "----------------"
			echo -n "pdflatex...     "
			pdflatex -draftmode -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			if [ "$?" != 0 ] ; then
				echo "pdflatex encountered an error"
				exit 1
			fi
			echo "done"
			echo -n "biber...        "
			biber main > /dev/null 2>&1
			echo "done"
			echo -n "pdflatex...     "
			pdflatex -draftmode -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			if [ "$?" != 0 ] ; then
				echo "pdflatex encountered an error"
				exit 1
			fi
			echo "done"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			if [ "$?" != 0 ] ; then
				echo "pdflatex encountered an error"
				exit 1
			fi
			echo "done"
			built=true
			;;
		q)
			echo "quick compilation"
			echo "-----------------"
			echo -n "pdflatex...     "
			pdflatex -synctex=1 -interaction=nonstopmode main.tex > /dev/null 2>&1
			if [ "$?" != 0 ] ; then
				echo "pdflatex encountered an error"
				exit 1
			fi
			echo "done"
			built=true
			;;
		k)
			remove_intermediate_files=false
			;;
		o)
			open_pdf=true
			;;
		\?)
			echo "invalid option: -$opt"
			exit 1
			;;
	esac
done

if [ "$built" ==  false ] ; then
	echo "nothing was built"
	echo "flags:"
	echo "-c for cleanup before build"
	echo "-q for quick compilaton"
	echo "-f for full compilation"
	echo "-k to keep intermediate files"
	echo "-o to open pdf after build"
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

if $open_pdf ; then
	evince main.pdf
fi

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Name			: function settings
# Licence		: MIT
# Author		: S.Nakano(https://github.com/sumeshi)
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#

# - utils -
function removeDS(){ find $1 -name ".DS_Store" -print -exec rm {} ";" }
function grepstring(){ grep -rnw ./ -e "$1" }
function notify() { osascript -e 'display notification "command completed." with title "notify"' }

function gitset(){
	git config user.name $1
	git config user.email $2
}

function ranger() {
  if [ -z "$RANGER_LEVEL" ]; then
	/usr/local/bin/ranger $@
  else
	exit
  fi
}

function mdtolatex() {
  echo "watch $1"
  INTERVAL=1
  last=`ls -l -T $1 | awk '{print $8}'`
  while true; do
	sleep $INTERVAL
	current=`ls -l -T $1 | awk '{print $8}'`
	if [ $last != $current ] ; then
	  echo ""
	  echo "updated: $current"
	  last=$current
	  outfile="`basename $1 .md`.tex"
	  pandoc $1 -o $outfile
	fi
  done
}

#-----memory directory-----#
memdir=()

function memd(){
	if [ "$1" = "" ]
	then
		memnum=1
	else
		memnum=$1
	fi

	memdir[$memnum]=("$memnum: `pwd`")
	echo "$memdir[$memnum] is saved in memdir[$memnum]"
}

function cdmemd(){
	if [ "$1" = "" ]
	then
		memnum=1
	else
		memnum=$1
	fi

	cd `echo ${=memdir[$memnum]#*: }`
}

function lsmemd(){
	for i in "${memdir[@]}"
	do
		if [ "$i" != "" ]
		then
			echo "$i"
		fi
	done
}
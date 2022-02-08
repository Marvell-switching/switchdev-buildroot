if [ "`id -u`" -eq 0 ]; then
	export PS1='\h# '
else
	export PS1='\h$ '
fi

# ln


#default to symbolic link (s), prompt before overwrite (i), print verbose
# output (v), [and on FreeBSD warn if the source doesn't exist (w)] for ln
alias oln='$(which ln)'
if [ "$(uname)" = "Linux" ]; then
    alias ln="ln -siv"
elif [ "$(uname)" = "Darwin" ]; then
    alias ln="ln -siv"
else
    alias ln="ln -siwv"
fi

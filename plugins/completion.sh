#  bash completion, cd completion, etc

#  programmable completion is enabled
shopt -s progcomp
#  use bash completion!
if [ -f ~/.bash_completion ]; then
    source  ~/.bash_completion
fi
etc_completion_path=/usr/local/etc/bash_completion.d
if [ -d $etc_completion_path ]; then
    for completer in $etc_completion_path/*; do
        #log-rc "    Loading tab-completions from " $completer
        source $completer
    done
fi
#  allow cd to autocorrect small errors
shopt -s cdspell
#  allow dir names to be autocorrected for small erors
shopt -s dirspell
#  complete @<text> with hostnames if possible
shopt -s hostcomplete


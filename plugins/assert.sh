# create an assert API

function assert()
{
    # Assert condition true, else fail with message
    local condition=$1
    local message=$2

    # Actually check
    if [ ! $condition ]; then
        printf "ASSERTION FAILURE: '%s'.  %s\n" "$condition" "$message"
        if [[ $SHLVL > 1 ]]; then
            exit 1;
        fi
        printf "WARNING: Refusing to exit early due to SHLVL==1.  Will not kill login shell.\n"
        return 1
    fi
    return 0
}

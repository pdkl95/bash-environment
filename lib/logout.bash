#!$SHELL

exit_status=$?
echo "SAVING HISTORY..."

HC="${HISTFILEMASTER_C}"
H="${HISTFILEMASTER}"
if [[ -w "$HC" ]] && [[ -w "H" ]] ; then
    history "${HISTCMD:-5000}" | sed -e 's/^[ 0-9]*\(.*\)/\1/g' | tee -a "$HC" >> "$H"
    cat "${HISTFILE}" | tee -a "$HC" >> "$H"
fi
history -w
{ echo -e "--- [$exit_status $?] LINENO:$LINENO $SECONDS seconds" >&2; }

exit $exit_status

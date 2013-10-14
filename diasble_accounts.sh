#!/bin/bash
#
# Run this script after account creation to disable accounts that weren't renewed
#

IN_FILE="users.csv"

while IFS=, read PASSWORD STUDENT_NUMBER USERNAME
do
    USER_EXISTS=$(grep -c "^${USERNAME}:" /etc/passwd)

    if [ "$USER_EXISTS" -ne "1" ] ; then
        # USER EXISTS, CHANGE PASSWORD
        usermod --lock --expiredate 1970-01-01 $USERNAME
    fi
    
    echo
done < $IN_FILE

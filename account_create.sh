#!/bin/bash

MAIL_POSTFIX="@ucdconnect.ie"
IN_FILE="test.csv"
LINE="sOmeeEPasW0rD,09442961,jacktrick"

while read LINE
do
    PASSWORD="$(echo $LINE | awk -F "," '{
        print $1
    }')"

    STUDENT_NUMBER="$(echo $LINE | awk -F "," '{
    print $2
    }')"

    USERNAME="$(echo $LINE | awk -F "," '{
        print $3
    }')"

    USER_EXISTS=$(grep -c "^${USERNAME}:" /etc/passwd)

    if [ "$USER_EXISTS" -ne "0" ] ; then
        # USER EXISTS, CHANGE PASSWORD
        echo "$USERNAME:$PASSWORD" | chpasswd
    else
        # USER DOES NOT EXIST, CREATE USER
        echo "Creating user $USERNAME"
        sudo useradd -m -p "$PASSWORD" "$USERNAME"
    fi
    echo
done < $IN_FILE

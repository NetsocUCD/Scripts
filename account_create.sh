#!/bin/bash

MAIL_POSTFIX="@ucdconnect.ie"
IN_FILE="users.csv"

function email () {
    SUBJECT="NETSOC ACCOUNT CREATED"
    EMAIL=$STUDENT_NUMBER$MAIL_POSTFIX
    EMAILMESSAGE="email.txt"

    echo "Your account was created"> $EMAILMESSAGE
    echo "" >> $EMAILMESSAGE
    echo "Username: $USERNAME" >>$EMAILMESSAGE
    echo "Password: $PASSWORD" >>$EMAILMESSAGE
    echo "" >> $EMAILMESSAGE
    echo "Login at $USERNAME@netsoc.com via SSH" >> $EMAILMESSAGE
    echo "Access your webpage at $USERNAME.netsoc.com" >> $EMAILMESSAGE
    echo "" >> $EMAILMESSAGE
    echo "NETSOC Team" >> $EMAILMESSAGE

    /usr/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
}

while IFS=, read PASSWORD STUDENT_NUMBER USERNAME
do
    USER_EXISTS=$(grep -c "^${USERNAME}:" /etc/passwd)

    if [ "$USER_EXISTS" -ne "0" ] ; then
        # USER EXISTS, CHANGE PASSWORD
        echo "$USERNAME:$PASSWORD" | chpasswd
    else
        # USER DOES NOT EXIST, CREATE USER
        echo "Creating user $USERNAME"
        useradd -m -p $PASSWORD -s /bin/bash $USERNAME
        #echo "$USERNAME:$PASSWORD" | chpasswd
        mkdir /home/$USERNAME/public_html
        echo "$USERNAME" > /home/$USERNAME/public_html/index.html
        chown -R $USERNAME:$USERNAME /home/$USERNAME
    fi
    email $USERNAME $STUDENT_NUMBER $PASSWORD
    echo
done < $IN_FILE

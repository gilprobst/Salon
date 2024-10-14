#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"



MENU () {



SERVICE_IDS=$($PSQL "SELECT service_id FROM services")
SERVICES=$($PSQL "SELECT * FROM services")

echo -e "\n Services:"
echo -e $SERVICES | sed 's/|/) /g'

read SERVICE_ID_SELECTED
SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE_AVAILABILITY ]]
then 
  echo "Requested service not available."
  MENU
else
  echo "Please enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then 
    echo "Please enter your name:"
    read CUSTOMER_NAME
    echo $($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "Hello $CUSTOMER_NAME! Please enter your desired appointment time:"
  read SERVICE_TIME
  echo $($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi
}

MENU

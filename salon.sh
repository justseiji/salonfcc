#!/bin/bash

echo "~~~~~ MY SALON ~~~~~"
echo "Welcome to My Salon, how can I help you?"


psql --username=freecodecamp --dbname=salon -c "SELECT service_id, name FROM services;" | tail -n +3 | head -n -2 | while read SERVICE_ID SERVICE_NAME
do
    echo "$SERVICE_ID) $SERVICE_NAME"
done


while true; do
    echo "What service would you like today? (Please enter the number)"
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    if [[ -z "$SERVICE_NAME" ]]; then
        echo "I could not find that service. What would you like today?"
        # Re-display the list of services
        psql --username=freecodecamp --dbname=salon -c "SELECT service_id, name FROM services;" | tail -n +3 | head -n -2 | while read SERVICE_ID SERVICE_NAME
        do
            echo "$SERVICE_ID) $SERVICE_NAME"
        done
    else
        break
    fi
done


echo "What's your phone number?"
read CUSTOMER_PHONE


CUSTOMER_EXISTS=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [[ -z "$CUSTOMER_EXISTS" ]]; then
  
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
    CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
else
 
    CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    echo "Welcome back, $CUSTOMER_NAME!"
fi

echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"


echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

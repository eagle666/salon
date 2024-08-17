#! /bin/bash

# Function to display services
DISPLAY_SERVICES() {
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
}

# Function to prompt for service selection and handle invalid entries
SERVICE_PROMPT() {
  echo -e "\nWelcome to My Salon, how can I help you?"
  DISPLAY_SERVICES
  read SERVICE_ID_SELECTED

  SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;" | xargs)

  # If the service doesn't exist
  if [[ -z $SERVICE_NAME ]]; then
    echo -e "\nI could not find that service. What would you like today?"
    SERVICE_PROMPT
  fi
}

# Start the service selection process
echo -e "\n~~~~~ MY SALON ~~~~~"
SERVICE_PROMPT

# Prompt for customer's phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';" | xargs)

# If the customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
fi

# Prompt for appointment time
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';" | xargs)
psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# Display confirmation message
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

# Uncomment the next line if you want to use services from Firebase/Google Cloud while running locally (and update the path)
# For more info, see https://firebase.google.com/docs/functions/local-emulator#set_up_admin_credentials_optional
# set GOOGLE_APPLICATION_CREDENTIALS="C:\Users\Andrei\Documents\service-accounts\<example.json>"

# Start the firebase emulators with data import/export enabled (so it's persisted between restarts)
firebase emulators:start --export-on-exit=./emulators-data --import=./emulators-data
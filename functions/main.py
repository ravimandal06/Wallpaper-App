import firebase_admin
from firebase_admin import credentials, firestore, messaging
import firebase_functions as functions
from datetime import datetime

# Initialize the Firebase Admin SDK
cred = credentials.Certificate('path/to/serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

def send_birthday_notification(user):
    message = messaging.Message(
        notification=messaging.Notification(
            title='Happy Birthday!',
            body=f'Wishing you a wonderful day, {user["name"]}!'
        ),
        token=user['deviceToken']
    )

    response = messaging.send(message)
    print('Successfully sent message:', response)

@functions.pubsub.schedule('every day 00:00').on_run
def check_birthdays(event):
    today = datetime.today()
    today_month = today.month
    today_date = today.day

    users_ref = db.collection(u'users')
    docs = users_ref.stream()

    for doc in docs:
        user = doc.to_dict()
        birthdate = user['birthdate'].to_date()

        if birthdate.month == today_month and birthdate.day == today_date:
            send_birthday_notification(user)

    return 'Checked all birthdays'

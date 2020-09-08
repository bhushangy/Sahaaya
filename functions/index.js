const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const userEmail = '';

// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
const gmailEmail = 'sahaayaapp@gmail.com';
const gmailPassword = 'asdfghjkl6969';
const mailTransport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

// Your company name to include in the emails
// TODO: Change this to your app or company name to customize the email sent.
const APP_NAME = 'Sahaaya';

// [START sendWelcomeEmail]
/**
 * Sends a welcome email to new user.
 */
// [START onCreateTrigger]
exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
// [END onCreateTrigger]
  // [START eventAttributes]
  const email = user.email; // The email of the user.
  const displayName = user.displayName; // The display name of the user.
  userEmail = user.email;
  // [END eventAttributes]

  return sendWelcomeEmail(email, displayName);
});
// [END sendWelcomeEmail]

// Sends a welcome email to the given user.
async function sendWelcomeEmail(email, displayName) {
  const mailOptions = {
    from: `${APP_NAME} <noreply@firebase.com>`,
    to: email,
  };

  // The user subscribed to the newsletter.
  mailOptions.subject = `Welcome to ${APP_NAME}!!`;
  mailOptions.text = `Hey ${email || ''}! Welcome to ${APP_NAME}. We hope you will enjoy our service.Please drop a feedback later.
  Thank You`;
  await mailTransport.sendMail(mailOptions);
  console.log('New welcome email sent to:', email);
  return null;
}

  // [START trigger_document_updated]
  exports.updateUser = functions.firestore
      .document('path to each bbmpgriev,bwssb griev etc')
      .onUpdate((change, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const newValue = change.after.data();

        // ...or the previous value before this update
        const previousValue = change.before.data();

        // access a particular field as you would any JS property
        const name = newValue.status;

        // perform desired operations ...
      });
  // [END trigger_document_updated]}
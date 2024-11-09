import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendNotificationOnNewMessage = functions.firestore
  .document("messages/{messageId}")
  .onCreate(async (snapshot, _context) => {
    const messageData = snapshot.data();

    // Get the recipient's FCM token
    const userSnapshot = await admin.firestore().collection("users")
      .where("email", "==", messageData.email)
      .get();

    if (!userSnapshot.empty) {
      const userToken = userSnapshot.docs[0].data().fcmToken;

      if (userToken) {
        const payload = {
          notification: {
            title: "New Message",
            body: messageData.message,
          },
        };

        // Send a notification to the recipient
        await admin.messaging().sendToDevice(userToken, payload);
        console.log("Notification sent to", messageData.email);
      }
    }
  });

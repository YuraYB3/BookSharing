const functions = require("firebase-functions");
const ad = require("firebase-admin");
const path = require("path");
const sA = require(path.resolve(__dirname, "keys", "serviceAccountKey.json"));
ad.initializeApp(
    {credential: ad.credential.cert(sA)},
);

exports.onNewMessage = functions.firestore
    .document("message/{friendshipID}/dialogue/{messageID}")
    .onCreate(async (snapshot, context) => {
      const mes = snapshot.data();
      const fID = context.params.friendshipID;

      console.log(`New message  ${fID}`);
      console.log(`Message details: ${JSON.stringify(mes)}`);

      try {
        const fRef =
        ad.firestore().collection("friendship").doc(fID);
        const friendshipDoc = await fRef.get();
        const fsh = friendshipDoc.data();

        if (!fsh) {
          console.log(`Friendship with ID ${fID} does not exist`);
          return;
        }
        const rID = fsh.user1_ID === mes.senderID ? fsh.user2_ID : fsh.user1_ID;
        console.log(`Recipient ID: ${rID}`);
        const sRef = ad.firestore().collection("users").doc(mes.senderID);
        const senderDoc = await sRef.get();
        const sendData = senderDoc.data();
        const rRef = ad.firestore().collection("users").doc(rID);
        const recipientDoc = await rRef.get();
        const recp = recipientDoc.data();

        if (!recp) {
          console.log(`Recipient with ID ${rID} does not exist`);
          return;
        }

        const payload = {
          notification: {
            title: `Нове повідомлення від ${sendData.name}`,
            body: mes.message,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            screen: "messages",
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            message_id: snapshot.id,
            friend_id: fID,
          },
        };

        const resp = await ad.messaging().sendToDevice(recp.userToken, payload);

        console.log(`Message sent to device with token ${recp["userToken"]}`);
        console.log(`Messaging API response: ${JSON.stringify(resp)}`);
      } catch (error) {
        console.log(`Error sending notification: ${error}`);
      }
    });
exports.onNewNotify = functions.firestore
    .document("notification/{notificationID}")
    .onCreate(async (snapshot, context) => {
      const notify = snapshot.data();

      console.log(`New notify `);
      console.log(`Message details: ${JSON.stringify(notify)}`);

      try {
        console.log(`Recipient ID: ${notify.receiverID}`);
        const rRef = ad.firestore().collection("users").doc(notify.receiverID);
        const recipientDoc = await rRef.get();
        const recp = recipientDoc.data();

        if (!recp) {
          console.log(`Recipient with ID does not exist`);
          return;
        }

        if (notify["notificationType"]=="Swap") {
          const payload = {
            notification: {
              title: `Обмін!`,
              body: "У вас новий запит на обмін книгами!",
              clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
            data: {
              screen: "messages",
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              message_id: snapshot.id,
            },
          };
          const re = await ad.messaging().sendToDevice(recp.userToken, payload);
          console.log(`Message sent to device with token ${recp["userToken"]}`);
          console.log(`Messaging API response: ${JSON.stringify(re)}`);
        }
        if (notify["notificationType"]=="Friendship") {
          const payload = {
            notification: {
              title: `Хммм`,
              body: "Хтось хоче додати вас у друзі!",
              clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
            data: {
              screen: "messages",
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              message_id: snapshot.id,
            },
          };
          const re = await ad.messaging().sendToDevice(recp.userToken, payload);
          console.log(`Message sent to device with token ${recp["userToken"]}`);
          console.log(`Messaging API response: ${JSON.stringify(re)}`);
        }
      } catch (error) {
        console.log(`Error sending notification: ${error}`);
      }
    });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { firestore, auth } = require("firebase-admin");
const { user } = require("firebase-functions/v1/auth");
const { event } = require("firebase-functions/v1/analytics");
var serviceAccount = require("/Users/apple/StudioProjects/tutor_app/functions/sdk.json");


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://test-f312b-default-rtdb.firebaseio.com"
});


const database = admin.firestore();

exports.pushNotification = functions.firestore.document('groups/{groupsId}/chats/{chatId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().message;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.receiverId)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });



        const payload = {
            notification: {
          title:  `${data.sendBy} ${data.secondName}`,
          body:  message,
      },
      data: {
        title: `${data.sendBy} ${data.secondName}`,
        body:  message,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  `${data.sendBy} ${data.secondName}`,
      body: ` ${message}`,
      receiverId : data.receiverId,

    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);

exports.pushNotification1 = functions.firestore.document('groups/{groupsId}/chats/{chatId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().message;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.receiverId1)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });



        const payload = {
            notification: {
          title: `${data.sendBy} ${data.secondName}`,
          body:  message,
      },
      data: {
        title: `${data.sendBy} ${data.secondName}`,
        body:  message,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  `${data.sendBy} ${data.secondName}`,
      body: ` ${message}`,
      receiverId : data.receiverId1,

    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);


exports.announcement = functions.firestore.document('announcement/{announcementId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().announcement;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.uid)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });



        const payload = {
            notification: {
          title: 'Announcement',
          body:  message,
      },
      data: {
        title: 'Announcement',
        body:  message,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  'Announcement',
      body: ` ${message}`,
      receiverId : data.uid,

    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);


exports.studentAttendeesAdmin = functions.firestore.document('attendees/{attendeesId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().attendees;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.adminId)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });

        const payload = {
            notification: {
          title: 'Attendees',
          body:  `${data.name} Marked ${message}`,
      },
      data: {
        title: 'Attendees',
        body:  `${data.name} Marked ${message}`,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  'Attendees',
      body:  `${data.name} Marked ${message}`,
      receiverId : data.adminId,

    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);


exports.studentAttendeesFaculty = functions.firestore.document('attendees/{attendeesId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().attendees;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.fId)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });

        const payload = {
            notification: {
          title: 'Attendees',
          body:  `${data.name} Marked ${message}`,
      },
      data: {
        title: 'Attendees',
        body:  `${data.name} Marked ${message}`,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  'Attendees',
      body:  `${data.name} Marked ${message}`,
      receiverId : data.fId,
    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);


exports.joinSession = functions.firestore.document('join/{joinId}').onCreate(
   async (snapshot, context) => {

        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.id)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });

        const payload = {
            notification: {
          title: 'Session',
          body:  `${data.name} Start Your Session`,
      },
      data: {
        title: 'Session',
        body:  `${data.name} Start Your Session`,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  'Session',
      body:  `${data.name} Start Your Session`,
      receiverId : data.id,
    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);

exports.pushNotificationTasks = functions.firestore.document('task/{taskId}/tasks/{tasksId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().task;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.id)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });



        const payload = {
            notification: {
          title: 'Instructor Assign Your Task',
          body:  message,
      },
      data: {
        title:  'Instructor Assign Your Task',
        body:  message,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:   'Instructor Assign Your Task',
      body: ` ${message}`,
      receiverId : data.id,

    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);

exports.custom = functions.firestore.document('customNotification/{customNotificationId}').onCreate(
   async (snapshot, context) => {
        const message = snapshot.data().message;
        const data = snapshot.data();

        const query =  await database
                  .collection("users")
                  .doc(data.uid)
                  .collection("tokens");

        var tokenList = [];
        //const tokens = query.docs.map((snap) => snap.id);
       const token =await query.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(token) {
            tokenList.push(token.data()['token']);
        });
    });

        const payload = {
            notification: {
          title: data.title,
          body:  message,
      },
      data: {
                 title: data.title,
                 body:  message,
      }
  };
  admin.messaging().sendToDevice(tokenList, payload).then((response) =>{
    database.collection('notifications').doc().set({
      title:  data.title,
      body:  `${message}`,
      receiverId : data.uid,
    })


    console.log('Successfully sent message:', response);
     print('success');
  }).catch((error)=>{
    return console.log(error);
  });
    }
);
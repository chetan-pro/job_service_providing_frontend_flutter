importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

/*Update with yours config*/
const firebaseConfig = {
    apiKey: "AIzaSyD1_30MYfwSrg8GgOt_ZLD9RJLcX9xaIIM",
    authDomain: "hindustaan-job-new.firebaseapp.com",
    projectId: "hindustaan-job-new",
    storageBucket: "hindustaan-job-new.appspot.com",
    messagingSenderId: "920416438534",
    appId: "1:920416438534:web:0a0ffca59b1f5401fdf687",
    measurementId: "G-25XZW8C0T3"
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

/*messaging.onMessage((payload) => {
console.log('Message received. ', payload);*/
messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);

});
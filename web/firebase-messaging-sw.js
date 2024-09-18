// Import the Firebase scripts that you need
importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in the messagingSenderId
firebase.initializeApp({
    apiKey: 'AIzaSyA1rc5NbcB71pMTMRryQVQyimKbsn1XFHs',
    appId: '1:855278908118:web:7a1297ac468e5257090f77',
    messagingSenderId: '855278908118',
    projectId: 'safify-7973d',
    authDomain: 'safify-7973d.firebaseapp.com',
    storageBucket: 'safify-7973d.appspot.com',
    measurementId: 'G-1GY38EZPN5',
      
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});

const admin = require('firebase-admin');
const fs = require('fs');

// Initialize the Firebase Admin SDK
const serviceAccount = require('./service-account.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function migrateData() {
  // 1. Read your exported Realtime Database JSON file
  const rawData = fs.readFileSync('rtdb-export.json');
  const rtdbData = JSON.parse(rawData);

  // Assuming your RTDB has a "/users" node
  const users = rtdbData.users || {};
  
  let batch = db.batch();
  let operationCount = 0;

  console.log('Starting migration...');

  for (const [uid, userData] of Object.entries(users)) {
    // 2. Map JSON data into Firestore document references
    const docRef = db.collection('users').doc(uid);
    
    // Structure the data how you want it in Firestore
    batch.set(docRef, {
      displayName: userData.name,
      emailAddress: userData.email,
      migratedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    operationCount++;

    // 3. Commit in batches (Firestore limit is 500 writes per batch)
    if (operationCount === 500) {
      await batch.commit();
      console.log('Successfully committed a batch of 500 users.');
      batch = db.batch(); // Reset the batch
      operationCount = 0;
    }
  }

  // Commit any remaining records
  if (operationCount > 0) {
    await batch.commit();
    console.log(`Successfully committed the final ${operationCount} users.`);
  }

  console.log('Migration successfully completed!');
}

migrateData().catch((err) => {
  console.error('Migration failed:', err);
});

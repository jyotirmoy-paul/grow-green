const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// time
const timeDocId = "date";

// money
const moneyDocId = "money";
const initialMoney = 10000000;

// farms
const farmPrefixId = "farm-";
const farms = ["farm-1", "farm-2", "farm-3", "farm-4", "farm-5", "farm-6"];

// soil health
const initialFarmSoilHealthPercentage = 1.0;

// farm state
const initialFarmState = "notBought";


exports.onUserCreation = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const collectionRef = admin.firestore().collection(uid);

  const batch = admin.firestore().batch();

  // write game world time
  const timeDocRef = collectionRef.doc(timeDocId);
  batch.set(timeDocRef, {
    dateTime: new Date().toISOString(),
  });

  // write farm states for all farms
  farms.forEach((farmId) => {
    const farmDocRef = collectionRef.doc(`${farmPrefixId}${farmId}`);
    batch.set(farmDocRef, {
      farmId: farmId,
      soilHealthPercentage: initialFarmSoilHealthPercentage,
      farmState: initialFarmState,
    });
  });

  // write money
  const moneyDocRef = collectionRef.doc(moneyDocId);
  batch.set(moneyDocRef, {
    rupees: initialMoney,
  });

  // write
  return batch.commit();
});

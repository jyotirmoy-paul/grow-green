/* eslint-disable require-jsdoc */
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

// achievements
const achievementsDocId = "achievements";
const AchievementType = {
  lands: "lands",
  soilHealth: "soilHealth",
};


function moneyModel(value) {
  return {
    value: value,
  };
}

function moneyOffer(value) {
  return {
    money: moneyModel(value),
  };
}

function checkPointModel(achievementType, isClaimed, isAchieved, value, offer) {
  return {
    achievementType: achievementType,
    isClaimed: isClaimed,
    isAchieved: isAchieved,
    value: value,
    offer: offer,
  };
}

function getInitalSoilHealthCheckpoints() {
  const soilHealthCheckPoints = [];

  const firstCheckPoint = checkPointModel(
      AchievementType.soilHealth,
      false,
      false,
      1.5,
      moneyOffer(1.5 * 100000),
  );

  soilHealthCheckPoints.push(firstCheckPoint);

  for (let i = 2; i <= 10; i++) {
    const checkPoint = checkPointModel(
        AchievementType.soilHealth,
        false,
        false,
        i,
        moneyOffer(i * 100000),
    );

    soilHealthCheckPoints.push(checkPoint);
  }
  return soilHealthCheckPoints;
}


function getInitalLandCheckpoints() {
  const landCheckPoints = [];

  for (let i = 1; i <= 6; i++) {
    const checkPoint = checkPointModel(
        AchievementType.lands,
        false,
        false,
        i,
        moneyOffer(i * 100000),
    );

    landCheckPoints.push(checkPoint);
  }

  return landCheckPoints;
}

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
    value: initialMoney,
  });

  // write achievements
  const achievementsDocRef = collectionRef.doc(achievementsDocId);
  const soilHealthCheckPoints = getInitalSoilHealthCheckpoints();
  const landCheckPoints = getInitalLandCheckpoints();

  console.log(soilHealthCheckPoints);
  console.log(landCheckPoints);

  const initialAchievements = {
    lands: landCheckPoints,
    soilHealth: soilHealthCheckPoints,
  };

  batch.set(achievementsDocRef, initialAchievements);

  // write
  return batch.commit();
});

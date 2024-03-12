/* eslint-disable require-jsdoc */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({origin: true});

admin.initializeApp();

// time
const timeDocId = "date";
const startTimeId = "startDate";

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

// challenges
const challengesDocId = "challenges";
const _redeemCodesId = "redeemCodes";


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

function generateRandomCode() {
  const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let result = "";
  for (let i = 0; i < 6; i++) {
    result += chars[Math.floor(Math.random() * chars.length)];
  }
  return result;
}

function gwalletOffer(value) {
  return {
    code: generateRandomCode(),
    value: moneyModel(value),
  };
}

function challengeModel(
    avgSoilHealth,
    bankBalance,
    landsBought,
    timePassedInYears,
    offerMoney,
    label,
) {
  return {
    avgSoilHealth: avgSoilHealth,
    bankBalance: bankBalance,
    landsBought: landsBought,
    timePassedInYears: timePassedInYears,
    isAchieved: false,
    isClaimed: false,
    offer: gwalletOffer(offerMoney),
    label: label,
  };
}

function challengesModel(challengeList) {
  return {
    challenges: challengeList,
  };
}

function generateInitialChallenges() {
  const oneCr = 10000000;
  const oneMillion = 1000000;
  const ultra = challengeModel(3, oneCr, 2, 3, oneMillion, "Ultra");
  const pro = challengeModel(5, 2 * oneCr, 3, 5, 3 * oneMillion, "Pro");
  const max = challengeModel(5, 3 * oneCr, 4, 10, 5 * oneMillion, "Max");
  const legend = challengeModel(7, 5 * oneCr, 5, 15, 10 * oneMillion, "Legend");
  const overPowered = challengeModel(
      8, 10 * oneCr, 6, 20, 20 * oneMillion, "OverPowered",
  );

  return challengesModel([ultra, pro, max, legend, overPowered]);
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
  const currentTime = {
    dateTime: new Date().toISOString(),
  };
  const timeDocRef = collectionRef.doc(timeDocId);
  batch.set(timeDocRef, currentTime);

  const startTimeDocRef = collectionRef.doc(startTimeId);
  batch.set(startTimeDocRef, currentTime);

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

  const initialAchievements = {
    lands: landCheckPoints,
    soilHealth: soilHealthCheckPoints,
  };

  batch.set(achievementsDocRef, initialAchievements);


  // write challenges
  const challengesDocRef = collectionRef.doc(challengesDocId);
  const initialChallenges = generateInitialChallenges();
  batch.set(challengesDocRef, initialChallenges);

  // add all redeem codes in reedemCodes collection
  const redeemCodesCollectionRef = admin.firestore().collection(_redeemCodesId);
  const redeemOffers = initialChallenges.challenges
      .map((challenge) => challenge.offer);

  redeemOffers.forEach((offer) => {
    const redeemCodeDocRef = redeemCodesCollectionRef.doc(offer.code);
    batch.set(redeemCodeDocRef, offer);
  });

  // write
  return batch.commit();
});

// social functionalities
// const {GoogleAuth} = require("google-auth-library");
const jwt = require("jsonwebtoken");

const {
  // geRedeemMoneyClassId,
  // reedemMoneyOfferclass,
  redeemMoneyOfferObject,
} = require("./pass_classes/redeem_offer.js");

const {
  // getViewFarmClassId,
  // viewFarmOfferClass,
  viewFarmOfferObject,
} = require("./pass_classes/view_farm.js");


const issuerId = "3388000000022317399";

// const classId = `${issuerId}.codelab_class`;

// const baseUrl = "https://walletobjects.googleapis.com/walletobjects/v1";

const credentials = require("./key.json");

// const httpClient = new GoogleAuth({
//   credentials: credentials,
//   scopes: "https://www.googleapis.com/auth/wallet_object.issuer",
// });

// async function createRedeemMoneyClass(req, res) {
//   const genericClass = reedemMoneyOfferclass(issuerId);
//   const classId = geRedeemMoneyClassId(issuerId);
//   await createClass(req, res, genericClass, classId);
// }

// async function createViewFarmClass(req, res) {
//   const genericClass = viewFarmOfferClass(issuerId);
//   const classId = getViewFarmClassId(issuerId);
//   await createClass(req, res, genericClass, classId);
// }

// async function createClass(req, res, genericClass, classId) {
//   let response;
//   try {
//     // Check if the class exists already
//     response = await httpClient.request({
//       url: `${baseUrl}/genericClass/${classId}`,
//       method: "GET",
//     });

//     console.log("Class already exists");
//     console.log(response);
//   } catch (err) {
//     if (err.response && err.response.status === 404) {
//       // Class does not exist
//       // Create it now
//       response = await httpClient.request({
//         url: `${baseUrl}/genericClass`,
//         method: "POST",
//         data: genericClass,
//       });

//       console.log("Class insert response");
//       console.log(response);
//     } else {
//       // Something else went wrong
//       console.log(err);
//       res.send("Something went wrong...check the console logs!");
//     }
//   }
// }

async function createRedeemMoneyObject(req, res) {
  const amount = req.query.amount;
  const code = req.query.code;
  // TODO: Create a new Generic pass for the user
  const genericObject = redeemMoneyOfferObject(issuerId, amount, code);
  await createObject(req, res, genericObject);
}

async function createViewFarmObject(req, res) {
  const farmLink = req.body.farmlink;
  const genericObject = viewFarmOfferObject(issuerId, farmLink);
  await createObject(req, res, genericObject);
}


async function createObject(req, res, genericObject) {
  // TODO: Create the signed JWT and link
  const claims = {
    iss: credentials.client_email,
    aud: "google",
    origins: [],
    typ: "savetowallet",
    payload: {
      genericObjects: [
        genericObject,
      ],
    },
  };


  const token = jwt.sign(claims, credentials.private_key, {algorithm: "RS256"});
  const saveUrl = `https://pay.google.com/gp/v/save/${token}`;

  res.send(saveUrl);
}


exports.token = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    createRedeemMoneyObject(request, response);
  });
});

exports.viewFarmToken = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    createViewFarmObject(request, response);
  });
});

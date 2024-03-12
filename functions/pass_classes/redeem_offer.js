/* eslint-disable require-jsdoc */
function geRedeemMoneyClassId(issuerId) {
  return `${issuerId}.REDEEM_MONEY_OFFER`;
}

function reedemMoneyOfferclass(issuerId) {
  const classId = geRedeemMoneyClassId(issuerId);
  return {
    "id": classId,
    "classId": classId,
    "classTemplateInfo": {
      "cardTemplateOverride": {
        "cardRowTemplateInfos": [
          {
            "twoItems": {
              "startItem": {
                "firstValue": {
                  "fields": [
                    {
                      "fieldPath": "object.textModulesData['code']",
                    },
                  ],
                },
              },
              "endItem": {
                "firstValue": {
                  "fields": [
                    {
                      "fieldPath": "object.textModulesData['amount']",
                    },
                  ],
                },
              },
            },
          },
        ],
      },
    },
  };
}

function redeemMoneyOfferObject(issuerId, amount, code) {
  const classId = geRedeemMoneyClassId(issuerId);

  return {
    "id": `${issuerId}.${amount}`,
    "classId": classId,
    "genericType": "GENERIC_TYPE_UNSPECIFIED",
    "cardTitle": {
      "defaultValue": {
        "language": "en-US",
        "value": "Grow Green",
      },
    },
    "header": {
      "defaultValue": {
        "language": "en-US",
        "value": "Redeem Coins",
      },
    },
    "textModulesData": [
      {
        "id": "code",
        "header": "Code",
        "body": code,
      },
      {
        "id": "amount",
        "header": "Amount",
        "body": amount,
      },
    ],
    "barcode": {
      "type": "QR_CODE",
      "value": `${code}`,
    },
    "hexBackgroundColor": "#000000",
  };
}

module.exports = {
  geRedeemMoneyClassId,
  redeemMoneyOfferObject,
  reedemMoneyOfferclass,
};

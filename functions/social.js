const functions = require("firebase-functions");
const cors = require("cors")({origin: true});

exports.token = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    const data = request.body;

    console.log(data);

    // Send a response back to the caller
    response.send("Data received");
  });
});

exports.viewFarmToken = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    const data = request.body;

    console.log(data);

    // Send a response back to the caller
    response.send("Data received");
  });
});

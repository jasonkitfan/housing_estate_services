const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
const admin = require("firebase-admin");
admin.initializeApp();

// cloud function for stripe payment
exports.stripePaymentIntentRequest = functions.region("asia-east2").https.onRequest(async (req, res) => {
    try {
        let customerId;
        //Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });

        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.data.id;
        }

        //Creates a temporary secret key linked with the customer
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2020-08-27' }
        );

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'hkd',
            customer: customerId,
        })

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })

    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});

//// read current database
//exports.testing = functions.https.onRequest(async (req, res) => {
//    try{
//        const promise = admin.firestore().doc('/shape_cw/facility_booking').get();
//        const p2 = promise.then(snapshot => {
//            const data = snapshot.data()
//            res.send(data);
//            console.log(data);
//        })
//    }
//    catch(e){
//        console.log("error on reading: " + e);
//    }
//    console.log("testing completed");
////    res.send("testing cloud functions");
//});
//
//

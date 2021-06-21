import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const app = admin.initializeApp();

import camelcaseKeys = require('camelcase-keys');
import { stripe } from './stripe';
import { CustomClaims } from './constants';

// You would ideally run the functions in the same region as Firestore (you select it in the Firebase console)
// https://firebase.google.com/docs/functions/locations (notice that Tier 2 is more expensive)
const region = process.env.FIREBASE_REGION || 'europe-west2';

const func = () => functions.region(region);

/**
 * Create the corresponding stripe customer when a new user is created
 */
export const createStripeCustomer = func()
  .auth.user()
  .onCreate(async (user, context) => {
    try {
      const customer = await stripe.customers.create(
        {
          email: user.email,
          name: user.displayName,
          metadata: {
            uid: user.uid,
          },
        },
        { idempotencyKey: context.eventId }
      );

      await app.auth().setCustomUserClaims(user.uid, {
        [CustomClaims.STRIPE_CUSTOMER_ID]: customer.id,
      });
    } catch (error) {
      console.log(error.message);
      return;
    }
  });

/**
 * Create a payment method based on the token received from
 * the native payment methods
 */
export const createPaymentMethod = func().https.onCall(
  async (data, context) => {
    if (!context.auth?.uid) return;

    const token = data['token'];
    let paymentMethod;
    try {
      paymentMethod = await stripe.paymentMethods.create({
        card: {
          token: token['tokenId'],
          exp_month: token['expMonth'],
          exp_year: token['expYear'],
          cvc: token['cvc'],
        },
        type: 'card',
      });
    } catch (error) {
      console.log(error.message);
      return {
        success: false,
        message: error.message,
      };
    }

    return camelcaseKeys(paymentMethod, { deep: true });
  }
);

/**
 * Create and confirm a stripe payment intent for card payment.
 */
export const createPaymentIntent = func().https.onCall(
  async (data, context) => {
    if (!context.auth?.uid) {
      return {
        success: false,
        message: 'Unauthenticated',
      };
    }

    try {
      const user = await app.auth().getUser(context.auth.uid);

      const result = await stripe.paymentIntents.create({
        amount: data.amount,
        currency: data.currency,
        customer: user.customClaims?.[CustomClaims.STRIPE_CUSTOMER_ID],
        confirm: true,
        metadata: {
          uid: context.auth.uid,
        },
      });

      return {
        status: result.status,
        customerId: result.customer,
        clientSecret: result.client_secret,
      };
    } catch (error) {
      console.log(error.message);
      return {
        success: false,
        message: error.message,
      };
    }
  }
);

import Stripe from 'stripe';
import { config } from 'firebase-functions';

export const stripeConfig = {
  get secret(): string {
    return config().stripe.secret;
  },
  // Here you could add other keys such as webhook secrets
  // in case you want to listen for events such as payments
};

export const stripe = new Stripe(stripeConfig.secret, {
  apiVersion: '2020-08-27',
  typescript: true,
});

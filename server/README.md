## Getting Started

The backend part is built on top of Firebase (Firebase Functions for the most part). This greatly reduces the operational overhead.

You will need to create a [Firebase project](https://firebase.google.com/), upgrade to the Blaze plan (so your functions can reach Stripe), and install the Firebase CLI (`npm i -g firebase-tools`). Then, you can add the project here using the Firebase CLI with `firebase use --add` (use the alias `default` when prompted).

Alternatively, you can initialize a new Firebase project from the CLI using `firebase init`.

Now, assuming you have already configured your Stripe account, you have to setup the secrets - the Stripe secret key in this case.

A good option to store secrets for Firebase is the environment config (do not confuse with Remote Config - there is no easy way to consume it from functions). When running locally (using the emulators), the config values will be retrieved from `functions/.runtimeconfig.json`. Rename/copy the provided template and fill in your Stripe secret key.

You should be ready to run the Firebase project locally:

- `cd functions`
- `npm i`
- `npm run build:watch` (`build` is also enough if you don't plan to change the code)

In another terminal from the `server` directory run the script [`run_emulators.ps1`](./run_emulators.ps1) (it's not really a script. Feel free to take a look at it).

If everything is fine, you should be able to open the [Emulator UI](http://localhost:4000).

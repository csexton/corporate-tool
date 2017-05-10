![Travis Status](https://travis-ci.org/csexton/corporate-tool.svg?branch=master)

![image](https://raw.githubusercontent.com/csexton/corporate-tool/master/graphics/github-readme.png)

Self Hosted Wiki and Pastebin

- Github Flavored Markdown
- Emoji support
- Drag and Drop (and Paste) support for image attachments
- Google Apps authentication

# Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

# Manual Deploy

Clone the code, Create an app, Push the code, and set a few configuration variables.

## Config Variables

- `GOOGLE_CLIENT_ID` - Google OAuth Client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth Client Secret Key
- `GOOGLE_HOME_DOMAIN` - Optional. Restrict access to only this Google apps domain

## Obtaining OAuth Credentials

Corporate Tool uses OmniAuth to authenticate users with Google App's OAuth, those setting must be set an environment variables. See [`.env-example`](https://github.com/csexton/corporate-tool/blob/master/.env-example) for examples.

### Step 1: Create a new Google Developer Project

https://console.developers.google.com/

### Step 2: Add OAuth 2.0 Credentials to that Project

Create new Project -> APIs and Auth -> Credentials -> Create new Client ID -> Web Application

In `AUTHORIZED REDIRECT URI` add the following

```
http://localhost:3000/
http://my-corporate-tool-domain.com/
```

In `AUTHORIZED JAVASCRIPT ORIGINS` add the following:

```
http://localhost:3000/auth/google/callback
http://my-corporate-tool-domain.com/auth/google/callback
```

Make sure you enable the API for "Google+" for that app as well, or you will get a "Access Not Configured. Please use Google Developers Console to activate the API for your project" error when doing the oauth handshake.

### Step 3: Set the Enviroment Variables for Your App

It might look like this:

```
GOOGLE_CLIENT_ID="000000000000-00000000000000000000000000000000.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="000000000000000000000000"
```

Optionally you can restrict to a specific Google Apps domain by setting the `GOOGLE_HOME_DOMAIN`:

```
GOOGLE_HOME_DOMAIN="my-company-domain.com"
```


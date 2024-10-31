![CorporateTool Logo](/graphics/github-readme.png?raw=true "Project Logo")

Self Hosted Wiki and Pastebin

- Github Flavored Markdown
- Emoji support
- Drag and Drop (and Paste) support for image attachments
- Google Apps authentication

# Screenshots

![Wiki Screenshot](/graphics/screenshot-wiki-show.png?raw=true "Screen Shot")

![Wiki Screenshot](/graphics/screenshot-wiki-edit.png?raw=true "Screen Shot")

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Local Development

```
cp .env-example .env
./bin/bundle
./bin/rails db:setup
./bin/rails serve
```

Before you can run the local server you will need to configure the app to use your google credentials. See [Configuration](#configuration) below for details.

## Configuration

All configuration is done through environment variables. Authentication settings are required, the other options are, um, optional.

Corporate Tool uses [OmniAuth](https://github.com/omniauth/omniauth) to authenticate users with Google App's OAuth, the following credentials must be set on environment variables.

- `GOOGLE_CLIENT_ID` - Google OAuth Client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth Client Secret Key
- `GOOGLE_HOME_DOMAIN` - Optional: Restrict access to only this Google apps domain

See [`.env-example`](/.env-example) for instructions for setting up the credentials, and examples and, a full list of settings.

# License

MIT License. See [LICENSE](/LICENSE) for details.



{
  "name": "Corporate Tool",
  "description": "Simple wiki and code gists for your orgnization.",
  "keywords": [
    "wiki",
    "gist",
    "paste",
    "oauth",
    "productivity"
  ],
  "website": "http://github.com/csexton/corporate-tool",
  "repository": "http://github.com/csexton/corporate-tool",
  "logo": "https://raw.githubusercontent.com/csexton/corporate-tool/master/graphics/github-readme.png",
  "success_url": "/setup",
  "scripts": {},
  "env": {
    "SITE_NAME": {
      "description": "Display Name of the site.",
      "value": "Coprorate Tool",
    },
    "GOOGLE_CLIENT_ID": {
      "description": "Google OAuth Client ID",
      "value": "",
      "required": true
    },
    "GOOGLE_CLIENT_SECRET": {
      "description": "Google OAuth Client Secret Key",
      "value": "",
      "required": true
    },
    "GOOGLE_HOME_DOMAIN": {
      "description": "Optional. If you want to restrict access to only one Google apps domain, specify that domain here. Otherwise anyone with a Google account will be able to login",
      "value": ""
    }
  },
  "addons": []
}

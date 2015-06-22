# Dependencies
## Ruby

```
  (rbenv) rbenv install
  bundle install 2.0.0-p481
```

## External

> Things we'll need to do within Salesforce:
> Setting up an Application Integration
> - http://feedback.uservoice.com/knowledgebase/articles/235661-get-your-key-and-secret-from-salesforce
> Creating an Integration User
> - https://help.salesforce.com/apex/HTViewSolution?urlname=User-Permission-for-API-Integration-User&language=en_US
> Setting up (Resetting) a user token
> - https://help.salesforce.com/apex/HTViewHelpDoc?id=user_security_token.htm

## Setup

create `/.env`
```
  SECRET=alongstring
  SALESFORCE_KEY=
  SALESFORCE_SECRET=
  SALESFORCE_USERNAME="app-user@example.com"
  SALESFORCE_PASSWORD="password"
  SALESFORCE_SECURITY_TOKEN=
```

# Starting the Service

```
  foreman start
```

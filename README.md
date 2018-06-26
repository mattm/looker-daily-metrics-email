# Daily Metrics Email

## Installation

```
bundle install
```

## Sending the Email

You'll need to provide several environment variables before executing `run.rb`:

```
$ env LOOKER_CLIENT_ID="..." LOOKER_CLIENT_SECRET="..." LOOKER_API="https://example.looker.com:19999/api/3.0"  EMAIL_USER_NAME="..." EMAIL_PASSWORD="..." EMAIL_TO="..." EMAIL_FROM="..." EMAIL_SMTP="..." EMAIL_DOMAIN="..." ruby run.rb
```

You'll want to customize the script according to your business's needs.

## Contact

If you have any suggestions, find a bug, or just want to say hey drop me a note at [@mhmazur](https://twitter.com/mhmazur) on Twitter or by email at matthew.h.mazur@gmail.com.

## License

MIT © [Matt Mazur](https://mattmazur.com)

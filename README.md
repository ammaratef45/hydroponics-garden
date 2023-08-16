# hydroponic_garden

A flutter app that can be used to track important dates and service your hydroponically grown plants.

Deployed at: https://free-hydroponic-garden.web.app/

# How to build locally

You can use unit tests to test your changes or submit a PR and let the CI/CD build and deploy a preview of your changes.

But, If your changes require local testing for faster development, you can follow these instructions.

1. After cloning the project, create a firebase app.
1. Add the following information to `lib/secrets.dart` file:
```
class Secrets {
  static const String apiKey = 'REPLACE_WITH_API_KEY';
  static const String appId = 'REPLACE_WITH_APP_ID';
  static const String messagingSenderId = 'REPLACE_WITH_MESSAGING_SENDER_ID';
  static const String projectId = 'REPLACE_WITH_PROJECT_ID';
  static const String authDomain = 'REPLACE_WITH_AUTH_DOMAIN';
  static const String storageBucket = 'REPLACE_WITH_STORAGE_BUCKET';
}
```
  - you can aslo run `flutterfire configure` to automate getting all these information (follow the instructions of the command output)

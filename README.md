# Internationalization plugin for Flutter

This plugin provides:

1. i18n widgets already prepare to hold internationalized string.
2. API to fetch internationalized strings.
3. Command line interface that does everything for you, just need to take care of translating your app.

## Getting Started

### Enable CLI

In order to use the provided cli tool, you need to enable first, therefore, run the following command:

`flutter pub global activate native_i18n`

### Generate Flutter language files

You can either generate the files manually following the naming convention `strings_<locale>.json` where locale 
is the [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language code or execute the following command:

`flutter pub global run native_i18n generateLangFiles -o <folder_for_language_files>`

### Generate native language files

In order to have it ready, you need to generate the language files for each platform, 
therefore, you need to run the following command:

`flutter pub global run native_i18n generateNative -i <folder_for_flutter_language_files>`

The command above will generate the necessary files for each platform (check Supported Platforms) although there are extra steps you
need to follow you can use it.

#### Android

No extra steps needed, it works out-of-the-box
   
#### iOS

If you have included a new language in your app, you need to add the localize file into the building process, therefore, you have to
do the following:

1. Open `Runner.xcworkspace` file with XCode

2. In the project overview, you need to right click on the Runner folder and then click on _Add files to "Runner"_ option

3. Inside of the Runner folder, there are one folder per language with the following format `<locale>.lproj` so you need 
to add each file inside of that folder so when Flutter builds your app, those file will be included as well.

## TODO

1. Generate classes for each languages so can be used with IDE autocompletion.
2. Formatted strings.
3. Strings pluralization.  
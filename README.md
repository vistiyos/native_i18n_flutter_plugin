# Internationalization plugin for Flutter

This plugin provides:

1. i18n widgets already prepare to hold internationalized string.
2. API to fetch internationalized strings.
3. Command line interface that does everything for you, just need to take care of translating your app.

## Getting Started

### Generate Flutter language files

You can either generate the files manually following the naming convention `strings_<locale>.json` where locale 
is the [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language code or execute the following command:

`flutter pub run native_i18n_flutter_plugin generateLangFiles -o <folder_for_language_files> -i <language_code_comma_separated`

The first language specified will be set to be the default.

#### Example

`flutter pub run native_i18n_flutter_plugin generateLangFiles -o lang -i en,es,de`

### Generate native language files

In order to have it ready, you need to generate the language files for each platform, 
therefore, you need to run the following command:

`flutter pub run native_i18n_flutter_plugin generateNative -i <folder_for_flutter_language_files> [--watch]`

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

### Generate Dart class with keys as static properties

Sometimes is hard to remember all the keys, so what if the IDE you are using to create your app can remind you those keys. That's what
this command is for, so just run the following command and enjoy the magic:

`flutter pub run native_i18n_flutter_plugin generateClass -i <folder_for_flutter_language_files> -o <location_for_your_class> [--watch]`

### Generate Dart class and Native files with only one command

If you want to generate everything just with one command, here it is:

`flutter pub run native_i18n_flutter_plugin generate -i <folder_for_flutter_language_files> -o <location_for_your_class> [--watch]`


## TODO

1. Generate class containing the language strings keys so can be used with IDE autocompletion. ✅
2. Formatted strings. ✅
3. Added watch flag so the command line will run whenever a file is change. ✅ 
4. Strings pluralization.

## Known issues

### App crashes as soon as tries to load a translation on Android

There is a problem deserializing the data sent to the native language API due to `shrinkResources` feature, therefore, until a solution is found you need to disable when you generate a release.

# LEP (Language Exchange Program) App

The LEP App is a powerful language translation and communication tool available for both iPad and mobile devices. It leverages advanced speech recognition, translation, and synthesis capabilities to facilitate seamless communication across different languages.

## Acknowledgments

This project is supported by:

- The National Center for Advancing Translational Sciences of the National Institutes of Health under Award Number UL1TR002378. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.

- Johnson & Johnson QuickFire Challenge Award

## Features

- **Speech Recognition**: Accurately captures spoken words in multiple languages using Azure Speech Service APIs
- **Real-time Translation**: Translates speech between supported language pairs
- **Speech Synthesis**: Converts translated text to natural-sounding speech using either:
  - Apple's Text-to-Speech (TTS) engine
  - Azure Speech Service synthesis

## Technical Architecture

The app is built using the following key technologies:

- **Azure Speech Services**: Powers the core speech recognition and translation functionality
- **Apple TTS**: Provides alternative speech synthesis capabilities
- **iOS Platform**: Native development for iPad and iPhone devices

## Requirements

- Azure Speech Service subscription key and region
- iOS device running iOS [minimum supported version]
- Internet connection for Azure services

## Setup

1. Clone the repository
2. Configure Azure credentials in the appropriate configuration file
3. Install any necessary dependencies
4. Build and run the project in Xcode

## Azure Speech Service Configuration

The app requires valid Azure Speech Service credentials:

1. Create an Azure account if you don't have one
2. Set up an Azure Speech Service resource
3. Obtain the subscription key and region
4. Configure these credentials in the app

## Usage

1. Launch the app
2. Select source and target languages
3. Tap to speak in the source language
4. The app will:
   - Recognize the speech
   - Translate it to the target language
   - Synthesize the translation as speech

## Privacy & Data Handling

- Speech data is processed in real-time
- No conversation data is stored permanently
- All communication with Azure services is encrypted

## Support

For issues, questions, or contributions, please:
1. Open an issue in this repository
2. Provide detailed information about the problem
3. Include steps to reproduce if applicable

## License

[Specify the license under which this project is released]

# CareVoice AI - Healthcare Chatbot Application

A professional Flutter application that provides an AI-powered healthcare chatbot with voice input capabilities, built using Gemini AI and SQLite for local data storage.

## Features

### 🚀 Core Functionality
- **AI-Powered Chatbot**: Integrated with Google Gemini AI for intelligent healthcare responses
- **Voice Input**: Speech-to-text functionality with animated microphone interface
- **Text Chat**: Traditional text-based chat interface
- **Local Database**: SQLite storage for chat history and user data
- **User Authentication**: Secure login and signup system

### 🎨 User Interface
- **Modern Design**: Professional, healthcare-focused UI with dark theme
- **Responsive Layout**: Optimized for all screen sizes using Sizer
- **Smooth Animations**: Flutter Animate for enhanced user experience
- **Voice Assistant**: Animated microphone button with listening states

### 🔒 Security & Privacy
- **Local Data Storage**: All chat data stored locally on device
- **User Authentication**: Secure user registration and login
- **API Key Management**: Secure storage of Gemini API keys

## Setup Instructions

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd carevoice_ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Update the `env.json` file with your API keys:
   ```json
   {
     "GEMINI_API_KEY": "your_actual_gemini_api_key_here",
     "SPEECH_TO_TEXT_API_KEY": "your_speech_to_text_api_key_here",
     "APP_NAME": "CareVoice AI",
     "APP_VERSION": "1.0.0",
     "DATABASE_NAME": "carevoice_chatbot.db",
     "DATABASE_VERSION": 1
   }
   ```

   **To get a Gemini API key:**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy and paste it into the env.json file

4. **Run the application**
   ```bash
   flutter run
   ```

## Usage Guide

### First Time Setup
1. **Launch the app** - You'll see the login screen
2. **Create an account** - Tap "Sign Up" to register
3. **Fill in details** - Enter your name, email, and password
4. **Start chatting** - After login, you'll be taken to the chatbot interface

### Using the Chatbot
1. **Text Input**: Type your health questions in the text field
2. **Voice Input**: Tap the microphone button to speak your question
3. **AI Responses**: The chatbot will provide helpful, healthcare-focused responses
4. **Chat History**: All conversations are automatically saved locally

### Voice Features
- **Tap to Start**: Tap the microphone button to begin recording
- **Visual Feedback**: The button shows recording state with animations
- **Automatic Processing**: Speech is converted to text and sent to the chatbot
- **Error Handling**: Friendly error messages for voice recognition issues

## Architecture

### Project Structure
```
lib/
├── core/
│   └── app_export.dart          # Central exports
├── presentation/
│   ├── login_screen/           # User authentication
│   ├── signup_screen/          # User registration
│   ├── chatbot_screen/         # Main chatbot interface
│   └── widgets/                # Reusable UI components
├── services/
│   ├── database_service.dart   # SQLite operations
│   ├── gemini_service.dart     # Gemini AI integration
│   └── voice_service.dart      # Speech recognition
├── routes/
│   └── app_routes.dart         # Navigation routing
└── main.dart                   # Application entry point
```

### Key Components

#### Database Service
- **SQLite Integration**: Local data storage for users and chat history
- **User Management**: Create, authenticate, and manage user accounts
- **Chat Sessions**: Organize conversations into manageable sessions
- **Message Storage**: Persistent storage of all chat interactions

#### Gemini AI Service
- **Healthcare Focus**: Specialized prompts for medical and wellness queries
- **Conversation Context**: Maintains chat history for better responses
- **Error Handling**: Graceful fallbacks for API failures
- **Multiple Modes**: Different AI personalities for various use cases

#### Voice Service
- **Speech Recognition**: Convert audio to text
- **Real-time Processing**: Live transcription feedback
- **Permission Management**: Handle microphone access
- **Cross-platform**: Works on both Android and iOS

## Configuration

### Environment Variables
The application uses environment variables for configuration:

- `GEMINI_API_KEY`: Your Google Gemini AI API key
- `SPEECH_TO_TEXT_API_KEY`: Speech recognition API key
- `DATABASE_NAME`: Local database filename
- `DATABASE_VERSION`: Database schema version

### Theme Customization
The app uses a dark theme optimized for healthcare applications:
- **Primary Colors**: Medical blue and green tones
- **Typography**: Google Fonts for consistent text rendering
- **Responsive Design**: Sizer package for adaptive layouts

## Troubleshooting

### Common Issues

1. **API Key Errors**
   - Ensure your Gemini API key is valid and active
   - Check that the key has proper permissions
   - Verify the key is correctly formatted in env.json

2. **Voice Recognition Issues**
   - Grant microphone permissions when prompted
   - Check device microphone settings
   - Ensure stable internet connection for API calls

3. **Database Errors**
   - Clear app data if database corruption occurs
   - Check device storage space
   - Verify SQLite permissions

4. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter and Dart SDK versions
   - Verify all dependencies are compatible

### Performance Optimization
- **Chat History**: Limit stored messages to prevent memory issues
- **Voice Processing**: Optimize audio quality for better recognition
- **Database Queries**: Efficient indexing for large chat histories

## Development

### Adding New Features
1. **Create new screens** in the `presentation/` directory
2. **Add services** in the `services/` directory
3. **Update routes** in `app_routes.dart`
4. **Export components** in `app_export.dart`

### Testing
- **Unit Tests**: Test individual services and components
- **Integration Tests**: Test complete user workflows
- **UI Tests**: Test user interface interactions

### Code Style
- Follow Flutter best practices
- Use consistent naming conventions
- Add proper error handling
- Include comprehensive documentation

## Support

### Getting Help
- Check the troubleshooting section above
- Review Flutter and Dart documentation
- Consult Gemini AI API documentation
- Check device-specific requirements

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **Google Gemini AI** for intelligent conversation capabilities
- **Flutter Team** for the excellent framework
- **SQLite** for reliable local data storage
- **Flutter Community** for helpful packages and resources

---

**Note**: This application is designed for educational and demonstration purposes. For actual medical advice, always consult qualified healthcare professionals.
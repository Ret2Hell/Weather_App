# Weather App

A simple weather application built with Flutter that displays current weather and a 1-day forecast for a selected city.

## Features

- Display current weather information including temperature, sky condition, and weather icon.
- Display a 1-day forecast with hourly weather details.
- Additional information such as humidity, wind speed, and pressure.
- Pull-to-refresh to update weather data.
  

## Getting Started

To get started with this project, follow these steps:

1. Clone this repository to your local machine.
2. Ensure you have Flutter installed. If not, follow the installation instructions [here](https://flutter.dev/docs/get-started/install).
3. Run `flutter pub get` to install dependencies.
4. Add your OpenWeatherMap API key to the `.env` file.
5. Run the app using `flutter run`.

## Dependencies

- Flutter: [Link](https://flutter.dev/)
- Weather package: [Link](https://pub.dev/packages/weather)
- Flutter Dotenv: [Link](https://pub.dev/packages/flutter_dotenv)

## Configuration

You need to set up an API key from OpenWeatherMap to fetch weather data. Follow these steps:

1. Sign up for an account on [OpenWeatherMap](https://home.openweathermap.org/users/sign_up).
2. Once logged in, navigate to the API keys section and generate a new API key.
3. Create a `.env` file in the root directory of your project.
4. Add your API key to the `.env` file like this: `OpenWeatherMap_API_key=YOUR_API_KEY`.

## Contributing

Contributions are welcome! If you find any bugs or have ideas for improvements, please create an issue or submit a pull request.
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          cityWeather.when(
              data: (data) => Text(
                    data!,
                    style: const TextStyle(fontSize: 40),
                  ),
              error: (error, _) => const Text('Error'),
              loading: () => const CircularProgressIndicator()),
          Expanded(
            child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (context, index) {
                  final curCity = City.values[index];
                  final isSelected = curCity == ref.watch(currentCityProvider);
                  return ListTile(
                    onTap: () {
                      ref.read(currentCityProvider.notifier).state = curCity;
                    },
                    leading: Text(curCity.toString()),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

//  type of weather
typedef WeatherEmoji = String;
const unKnownWeatherEmoji = '🤷‍♂️';
// get weather method
Future<WeatherEmoji> getWeather(City city) async {
  return Future.delayed(
    const Duration(seconds: 2),
    () =>
        {
          City.abuja: '🤑',
          City.ibadan: '😎',
          City.ife: '😎',
          City.ilesa: '😎',
          City.ilorin: '😎',
          City.kano: '😎',
          City.lagos: '😎',
          City.ogbomoso: '😎',
          City.osogbo: '😎',
          City.oyo: '😎',
          City.sokoto: '😎',
        }[city] ??
        '?',
  );
}

// creating a state provider to input data into the ui
final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji?>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unKnownWeatherEmoji;
  }
});

enum City {
  sokoto,
  kano,
  lagos,
  abuja,
  ife,
  ibadan,
  oyo,
  ogbomoso,
  osogbo,
  ilesa,
  ilorin
}

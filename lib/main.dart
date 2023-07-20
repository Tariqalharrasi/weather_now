import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:weather/weather.dart';
import 'weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        country: '',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({super.key, required this.country});

  String country;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? temp;
  List<Weather> cast = [];
  Color backColor = const Color(0xffE5ECF4);
  final TextEditingController _searchBar = TextEditingController();

  String searchValue = '';

  @override
  void dispose() {
    _searchBar.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchTemp();
    getforcast();
  }

  Future<void> fetchTemp() async {
    print('Fetching temperature for: ${widget.country}');
    var tempV = await WeatherService.getTemp(widget.country);
    print('Temperature fetched: $tempV');
    setState(() {
      temp = tempV;
    });
  }

  Future<void> getforcast() async {
    print('Forcast for: ${widget.country}');
    final castV = await WeatherService.getCast(widget.country);
    print('The Forcast: $castV');
    setState(() {
      cast = castV;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: SearchBar(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor: MaterialStateProperty.all(backColor),
                    shape: MaterialStateProperty.all(const LinearBorder()),
                    hintText: "Write the name of country",
                    hintStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.grey)),
                    controller: _searchBar,
                    onChanged: (value) {
                      setState(() {
                        widget.country = value;
                        fetchTemp();
                        getforcast();
                      });
                    },
                    overlayColor: MaterialStateProperty.all(backColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    temp != null
                        ? '${temp!.toStringAsFixed(1)}°C'
                        : 'Loading...',
                    style: const TextStyle(fontSize: 64),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.country,
                    style: const TextStyle(fontSize: 45),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cast.length,
                itemBuilder: (context, index) {
                  final weather = cast[index];
                  final dateTime = weather.date;
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(5),
                      leading: Text(
                          "${dateTime!.month}/${dateTime.day} ${dateTime.hour}:00"),
                      title: Text(
                          "${weather.temperature!.celsius!.toStringAsFixed(1)}°C"),
                      subtitle: Text("${weather.weatherDescription}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

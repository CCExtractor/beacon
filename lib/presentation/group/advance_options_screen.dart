import 'package:auto_route/annotations.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/hike/services/geoapify_service.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beacon/data/models/landmark/location_suggestion.dart';

@RoutePage()
class AdvancedOptionsScreen extends StatefulWidget {
  TextEditingController durationController;
  String title;
  bool isScheduled;
  DateTime? startDate;
  TimeOfDay? startTime;
  String groupId;

  AdvancedOptionsScreen({
    super.key,
    required this.durationController,
    required this.title,
    required this.isScheduled,
    this.startDate,
    this.startTime,
    required this.groupId,
  });

  @override
  State<AdvancedOptionsScreen> createState() => _AdvancedOptionsScreenState();
}

class _AdvancedOptionsScreenState extends State<AdvancedOptionsScreen> {
  Duration? duration = Duration(minutes: 5);
  Map<String, dynamic>? weatherData;
  bool isLoadingWeather = false;
  String? weatherError;
  final GeoapifyService _geoapifyService = GeoapifyService();
  final TextEditingController _locationController = TextEditingController();
  List<LocationSuggestion> _locationSuggestions = [];
  bool _showLocationSuggestions = false;
  LocationSuggestion? _selectedLocation;
  DateTime? startDate = DateTime.now();
  TimeOfDay? startTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);

  @override
  void initState() {
    super.initState();
    _fetchWeatherForCurrentLocation();
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return Future.error(
          'Location permissions are permanently denied. Cannot request permissions.');
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchWeatherForCurrentLocation() async {
    Position? position = await getCurrentLocation();

    await _fetchWeatherData(
      position?.latitude ?? 0.0, // Default to 0.0 if position is null
      position?.longitude ?? 0.0, // Default to 0.0 if position is null
    ); // Default to 0.0 if parsing fails
  }

  Future<void> _fetchWeatherData(double lat, double lon) async {
    setState(() {
      isLoadingWeather = true;
      weatherError = null;
    });

    try {
      const String apiKey = '03fe30be078c0bfb823d954404de6a6b';

      String apiUrl;
      if (widget.isScheduled && widget.startDate != null) {
        // Use forecast API for scheduled hikes
        apiUrl =
            'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      } else {
        // Use current weather API for immediate hikes
        apiUrl =
            'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (widget.isScheduled && widget.startDate != null) {
          // Process forecast data to find weather for the scheduled date
          final forecastWeather = _extractWeatherForScheduledDate(data);
          setState(() {
            weatherData = forecastWeather;
            isLoadingWeather = false;
          });
        } else {
          // Use current weather data
          setState(() {
            weatherData = data;
            isLoadingWeather = false;
          });
        }
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather fetch error: $e');
      // Fallback to mock data if API fails
      //await _loadMockWeatherData();
    }
  }

  Map<String, dynamic> _extractWeatherForScheduledDate(
      Map<String, dynamic> forecastData) {
    final scheduledDate = widget.startDate!;
    final scheduledTime = widget.startTime;

    // Convert scheduled date to timestamp
    DateTime targetDateTime;
    if (scheduledTime != null) {
      targetDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
    } else {
      targetDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        12, // Default to noon if no time specified
        0,
      );
    }

    final List<dynamic> forecasts = forecastData['list'];
    Map<String, dynamic>? closestForecast;
    Duration smallestDifference = Duration(days: 365);

    // Find the forecast closest to the scheduled time
    for (var forecast in forecasts) {
      final forecastTime = DateTime.fromMillisecondsSinceEpoch(
        forecast['dt'] * 1000,
        isUtc: true,
      ).toLocal();

      final difference = (forecastTime.difference(targetDateTime)).abs();
      if (difference < smallestDifference) {
        smallestDifference = difference;
        closestForecast = forecast;
      }
    }

    if (closestForecast != null) {
      // Transform forecast data to match current weather API format
      return {
        'main': closestForecast['main'],
        'weather': closestForecast['weather'],
        'wind': closestForecast['wind'],
        'visibility': closestForecast['visibility'] ?? 10000,
        'name': _selectedLocation?.name ??
            forecastData['city']['name'] ??
            'Selected Location',
        'dt': closestForecast['dt'],
        'isScheduled': true,
        'scheduledDate': targetDateTime.toIso8601String(),
      };
    }

    // Fallback to first forecast if no suitable match found
    return {
      'main': forecasts[0]['main'],
      'weather': forecasts[0]['weather'],
      'wind': forecasts[0]['wind'],
      'visibility': forecasts[0]['visibility'] ?? 10000,
      'name': _selectedLocation?.name ??
          forecastData['city']['name'] ??
          'Selected Location',
      'dt': forecasts[0]['dt'],
      'isScheduled': true,
      'scheduledDate': targetDateTime.toIso8601String(),
    };
  }

  Future<void> _loadMockWeatherData() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      weatherData = {
        'main': {
          'temp': 22.5,
          'feels_like': 24.0,
          'humidity': 65,
        },
        'weather': [
          {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
        ],
        'wind': {
          'speed': 3.2,
        },
        'visibility': 10000,
        'name': _selectedLocation?.name ?? 'Your Location',
        'isScheduled': widget.isScheduled,
        'scheduledDate': widget.isScheduled && widget.startDate != null
            ? widget.startDate!.toIso8601String()
            : null,
      };
      isLoadingWeather = false;
    });
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) {
      setState(() {
        _locationSuggestions = [];
        _showLocationSuggestions = false;
      });
      return;
    }

    try {
      final suggestions = await _geoapifyService.getLocationSuggestions(query);
      setState(() {
        _locationSuggestions = suggestions;
        _showLocationSuggestions = true;
      });
    } catch (e) {
      print('Location search error: $e');
      setState(() {
        _locationSuggestions = [];
        _showLocationSuggestions = false;
      });
    }
  }

  void _selectLocation(LocationSuggestion location) {
    setState(() {
      _selectedLocation = location;
      _locationController.text = location.name;
      _showLocationSuggestions = false;
    });

    // Fetch weather for selected location
    _fetchWeatherData(location.latitude, location.longitude);
  }

  String _getWeatherTitle() {
    if (weatherData == null) return 'Weather';

    if (widget.isScheduled && widget.startDate != null) {
      final scheduledDate = widget.startDate!;
      final now = DateTime.now();
      final difference = scheduledDate.difference(now).inDays;

      if (difference == 0) {
        return 'Today\'s Weather';
      } else if (difference == 1) {
        return 'Tomorrow\'s Weather';
      } else {
        return 'Weather Forecast \n (${difference} days from now)';
      }
    }

    return 'Current Weather';
  }

  Widget _buildAppBar(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => context.router.maybePop(),
        ),
        Image.asset('images/beacon_logo.png', height: 4.h),
        IconButton(
          icon: const Icon(Icons.power_settings_new, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    if (isLoadingWeather) {
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircularProgressIndicator(),
              // SizedBox(width: 16),
              Text(widget.isScheduled
                  ? 'Loading weather forecast...'
                  : 'Loading weather conditions...'),
            ],
          ),
        ),
      );
    }

    if (weatherError != null) {
      return Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 16),
              Expanded(child: Text(weatherError!)),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  if (_selectedLocation != null) {
                    _fetchWeatherData(_selectedLocation!.latitude,
                        _selectedLocation!.longitude);
                  } else {
                    _fetchWeatherForCurrentLocation();
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    if (weatherData == null) return SizedBox.shrink();

    final temp = weatherData!['main']['temp'];
    final feelsLike = weatherData!['main']['feels_like'];
    final humidity = weatherData!['main']['humidity'];
    final windSpeed = weatherData!['wind']['speed'];
    final description = weatherData!['weather'][0]['description'];
    final location = weatherData!['name'];

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getWeatherTitle(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    if (_selectedLocation != null) {
                      _fetchWeatherData(_selectedLocation!.latitude,
                          _selectedLocation!.longitude);
                    } else {
                      _fetchWeatherForCurrentLocation();
                    }
                  },
                ),
              ],
            ),
            // SizedBox(height: 8),
            Text(
              location,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (widget.isScheduled && widget.startDate != null) ...[
              // SizedBox(height: 4),
              Text(
                'Scheduled for: ${widget.startDate!.day}/${widget.startDate!.month}/${widget.startDate!.year}' +
                    (widget.startTime != null
                        ? ' at ${widget.startTime!.format(context)}'
                        : ''),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            //      SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${temp.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Feels like ${feelsLike.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      description.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(Icons.water_drop, 'Humidity', '$humidity%'),
                _buildWeatherInfo(
                    Icons.air, 'Wind', '${windSpeed.toStringAsFixed(1)} m/s'),
                _buildWeatherInfo(Icons.visibility, 'Visibility',
                    '${(weatherData!['visibility'] / 1000).toStringAsFixed(1)} km'),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getWeatherRecommendationColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getWeatherRecommendationIcon(),
                    color: _getWeatherRecommendationColor(),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getWeatherRecommendation(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getWeatherRecommendationColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getWeatherRecommendationColor() {
    if (weatherData == null) return Colors.grey;

    final temp = weatherData!['main']['temp'];
    final windSpeed = weatherData!['wind']['speed'];
    final description = weatherData!['weather'][0]['main'].toLowerCase();

    if (description.contains('rain') || description.contains('storm')) {
      return Colors.red;
    } else if (temp < 10 || temp > 35 || windSpeed > 10) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  IconData _getWeatherRecommendationIcon() {
    Color color = _getWeatherRecommendationColor();
    if (color == Colors.red) return Icons.warning;
    if (color == Colors.orange) return Icons.info;
    return Icons.check_circle;
  }

  String _getWeatherRecommendation() {
    if (weatherData == null) return 'Weather data unavailable';

    final temp = weatherData!['main']['temp'];
    final windSpeed = weatherData!['wind']['speed'];
    final description = weatherData!['weather'][0]['main'].toLowerCase();

    String baseRecommendation;
    if (description.contains('rain') || description.contains('storm')) {
      baseRecommendation = 'Not recommended for hiking due to rain/storms';
    } else if (temp < 10) {
      baseRecommendation =
          'Cold weather - dress warmly and check trail conditions';
    } else if (temp > 35) {
      baseRecommendation =
          'Very hot - bring extra water and consider early morning hikes';
    } else if (windSpeed > 10) {
      baseRecommendation = 'Strong winds - be cautious on exposed trails';
    } else {
      baseRecommendation = 'Good conditions for hiking - enjoy your adventure!';
    }

    if (widget.isScheduled && widget.startDate != null) {
      final difference = widget.startDate!.difference(DateTime.now()).inDays;
      if (difference > 3) {
        baseRecommendation += ' (Forecast may change - check closer to date)';
      }
    }

    return baseRecommendation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 2.h),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Location',
                            labelStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'Search for a location to get weather',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                            suffixIcon: _locationController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _locationController.clear();
                                      setState(() {
                                        _showLocationSuggestions = false;
                                        _selectedLocation = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            _searchLocations(value);
                          },
                        ),
                        if (_showLocationSuggestions &&
                            _locationSuggestions.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _locationSuggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _locationSuggestions[index];
                                return ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: Theme.of(context).primaryColor),
                                  title: Text(suggestion.name),
                                  onTap: () => _selectLocation(suggestion),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Weather Card
                  _buildWeatherCard(),

                  // Form Fields
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      child: Column(
                        children: [
                          // Title Field
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              onChanged: (name) {
                                widget.title = name;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                hintText: 'Enter your hike title',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),

                          // Duration Field
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () async {
                                final selectedDuration =
                                    await showDurationPicker(
                                  context: context,
                                  initialTime: duration ?? Duration(minutes: 5),
                                );
                                if (selectedDuration == null) return;

                                setState(() {
                                  duration = selectedDuration;
                                });

                                // Format duration text
                                if (duration!.inHours != 0 &&
                                    duration!.inMinutes != 0) {
                                  widget.durationController.text =
                                      '${duration!.inHours} hour ${(duration!.inMinutes % 60)} minutes';
                                } else if (duration!.inMinutes != 0) {
                                  widget.durationController.text =
                                      '${duration!.inMinutes} minutes';
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: widget.durationController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Duration',
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  hintText: 'Tap to select duration',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.timer,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var groupCubit = locator<GroupCubit>();
                if (widget.isScheduled) {
                  DateTime start = DateTime(startDate!.year, startDate!.month,
                      startDate!.day, startTime!.hour, startTime!.minute);

                  final startsAt = start.millisecondsSinceEpoch;
                  final expiresAt = start.add(duration!).millisecondsSinceEpoch;

                  groupCubit.createHike(
                      widget.title, startsAt, expiresAt, widget.groupId, false);

                  widget.durationController.clear();

                  appRouter.maybePop();
                } else {
                  int startsAt = DateTime.now().millisecondsSinceEpoch;
                  int expiresAt =
                      DateTime.now().add(duration!).millisecondsSinceEpoch;

                  groupCubit.createHike(
                      widget.title, startsAt, expiresAt, widget.groupId, true);

                  widget.durationController.clear();
                  appRouter.maybePop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                !widget.isScheduled ? 'Start' : 'Create',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

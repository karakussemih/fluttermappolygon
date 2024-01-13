import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<List<LatLng>> savedPolygons = [];
  List<LatLng> currentPolygon = [];
  Color polygonColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map Uygulaması'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(38.330112142934375, 38.4399655),
          zoom: 13.0,
          onTap: (TapPosition tapPosition, LatLng latLng) {
            _handleTap(latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              for (var polygonPoints in savedPolygons)
                Polygon(
                  points: polygonPoints,
                  color: polygonColor.withOpacity(0.5),
                  borderColor: polygonColor,
                  borderStrokeWidth: 2,
                ),
              if (currentPolygon.isNotEmpty)
                Polygon(
                  points: currentPolygon,
                  color: polygonColor.withOpacity(0.5),
                  borderColor: polygonColor,
                  borderStrokeWidth: 2,
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _savePolygon();
              _startNewPolygon();
            },
            child: Icon(Icons.save),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _showColorDialog();
            },
            child: Icon(Icons.color_lens),
          ),
        ],
      ),
    );
  }

  void _handleTap(LatLng point) {
    setState(() {
      currentPolygon.add(point);
    });
  }

  void _showColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hasar Durumunu Seçin'),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _setColor(Colors.red);
                  Navigator.pop(context);
                },
                child: Text('Ağır Hasarlı'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
              ElevatedButton(
                onPressed: () {
                  _setColor(Colors.orange);
                  Navigator.pop(context);
                },
                child: Text('Orta Hasarlı'),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
              ),
              ElevatedButton(
                onPressed: () {
                  _setColor(Colors.green);
                  Navigator.pop(context);
                },
                child: Text('Az Hasarlı'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setColor(Color color) {
    setState(() {
      polygonColor = color;
    });
  }

  void _savePolygon() {
    if (currentPolygon.isNotEmpty) {
      setState(() {
        savedPolygons.add(List.from(currentPolygon));
      });
    }
  }

  void _startNewPolygon() {
    setState(() {
      currentPolygon = [];
    });
  }
}

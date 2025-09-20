import 'package:centris/navigation/Accueil/widgets/header.dart';
import 'package:centris/navigation/Accueil/widgets/property_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GoogleMapController _mapController;
  LatLng? _userPosition;
  BitmapDescriptor? _propertyMarkerIcon;
  final Set<Marker> _markers = {};
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMarkerIcons();
    
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // Charger les icônes de marqueurs personnalisés bleus
  Future<void> _loadMarkerIcons() async {
    final propertyMarker = await _createBlueMarkerBitmap();
    
    setState(() {
      _propertyMarkerIcon = BitmapDescriptor.fromBytes(propertyMarker);
    });
  }

  // Créer un marqueur bleu avec bordure et opacité
  Future<Uint8List> _createBlueMarkerBitmap() async {
    const double markerSize = 120.0;
    const double iconSize = 50.0;
    
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
   
    // Position du cercle principal
    const double circleRadius = markerSize / 3;
    const double circleX = markerSize / 2;
    const double circleY = circleRadius;
    
    // Dessiner l'ombre du cercle principal
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
      const Offset(circleX, circleY + 2), 
      circleRadius, 
      shadowPaint
    );
    
    // Dessiner le cercle principal avec opacité
   
    
    // Dessiner la bordure bleue
    final borderPaint = Paint()
      ..color = const Color(0xFF3B82F6) // Bleu vif pour la bordure
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(circleX, circleY), circleRadius, borderPaint);
    
    // Dessiner l'icône de maison
    final TextPainter iconPainter = TextPainter(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        text: String.fromCharCode(Icons.home.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: Icons.home.fontFamily,
          color: Colors.white, // Icône blanche pour contraste
        ),
      ),
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas, 
      Offset(
        circleX - iconPainter.width / 2, 
        circleY - iconPainter.height / 2
      )
    );
    
    // Convertir en image
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(markerSize.toInt(), markerSize.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }

  // Obtenir la position de l'utilisateur
 

  // Ajouter des marqueurs de propriétés autour de la position utilisateur
  void _addPropertyMarkers() {
    if (_userPosition == null || _propertyMarkerIcon == null) return;
    
    final markers = <Marker>{};
    
    // Ajouter 5 marqueurs de propriétés autour de la position utilisateur
    for (int i = 0; i < 5; i++) {
      final offsetLat = 0.01 * (i - 2); // Décalage en latitude
      final offsetLng = 0.01 * (i - 2); // Décalage en longitude
      
      final propertyPosition = LatLng(
        _userPosition!.latitude + offsetLat,
        _userPosition!.longitude + offsetLng,
      );
      
      markers.add(Marker(
        markerId: MarkerId('property_$i'),
        position: propertyPosition,
        icon: _propertyMarkerIcon!,
        infoWindow: InfoWindow(
          title: 'Propriété ${i + 1}',
          snippet: 'À partir de 795 000 \$',
        ),
        onTap: () {
          // Action lorsqu'on clique sur un marqueur
          print('Propriété ${i + 1} cliquée');
        },
      ));
    }
    
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfessionalHeader(
              tabController: _tabController,
              onTabChanged: (index) {
                // Gestion du changement d'onglet si nécessaire
              },
            ),
            
            // Contenu principal (carte)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Vue Carte
                  Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(45.5017, -73.5673), // Montreal coordinates
                          zoom: 10,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          setState(() {
                            _isMapReady = true;
                          });
                          
                          // Appliquer un style personnalisé à la carte
                          controller.setMapStyle('''
                            [
                              {
                                "featureType": "poi",
                                "stylers": [{ "visibility": "off" }]
                              },
                              {
                                "featureType": "transit",
                                "elementType": "labels.icon",
                                "stylers": [{ "visibility": "off" }]
                              }
                            ]
                          ''');
                        },
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                      ),
                      
                      // Boutons flottants sur la droite
                      Positioned(
                        right: 16,
                        top: 25,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(28, 0, 0, 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildCircleButton(Icons.edit_outlined),
                              const SizedBox(height: 10),
                              _buildCircleButton(Icons.layers_outlined),
                              const SizedBox(height: 10),
                              _buildCircleButton(Icons.navigation_outlined),
                              const SizedBox(height: 10),
                              _buildCircleButton(Icons.compass_calibration_outlined),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bouton pour centrer sur la position utilisateur
                      if (_isMapReady && _userPosition != null)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: () {
                              _mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(_userPosition!, 14),
                              );
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(
                              Icons.my_location,
                              color: Color(0xFF3B82F6), // Bleu pour correspondre au thème
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Vue Liste
                  ListView.builder(
                    itemCount: 5, 
                    itemBuilder: (context, index) {
                      return const PropertyCard(
                        imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
                        price: '795 000 \$',
                        title: 'Quadruplex à vendre',
                        address: '2630, Rue Cartier, Saint-Hyacinthe, Quartier Bourg-Joli/Bois-Joli',
                        monthlyPayment: '40 812 \$',
                        imageCount: 27,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Barre de navigation inférieure
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavBarItem(Icons.search, 'Rechercher', isActive: true),
                  _buildNavBarItem(Icons.favorite_border, 'Favoris'),
                  _buildNavBarItem(Icons.explore_outlined, 'Explorer'),
                  _buildNavBarItem(Icons.account_circle_outlined, 'Compte'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: const Color(0xFF0B1340),
        onPressed: () {},
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      color: isActive ? const Color.fromARGB(52, 33, 149, 243) : Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF0B1340) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF0B1340) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
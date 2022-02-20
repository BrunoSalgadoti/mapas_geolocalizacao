import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _posicaoCamara = CameraPosition(
    //Latitude e Longitude inicial
      target: LatLng(-23.563645, -46.653642),
      zoom: 20
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  Future<dynamic> _movimentarCamera() async {

    GoogleMapController googleMapController = await _controller.future;

    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
            _posicaoCamara
        )
    );
    setState(() {
      _posicaoCamara;
    });
  }

//-----inserindo marcadores (Linhas de Marcação) no mapa geolocalização---------
  /*
  _carregarMarcadoresLines() {

    Set<Polyline> listaPolylines = {};
    Polyline polyline = Polyline(
      polylineId: PolylineId( "polyline" ),
      color: Colors.red,
      width: 10,
      startCap: Cap.squareCap,
      endCap: Cap.roundCap,
      jointType: JointType.bevel,
      points: [
        LatLng(-23.563645, -46.653642),
        LatLng(-23.566064, -46.650778),
        LatLng(-23.563232, -46.648020),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("Clicado na área");
    }
    );

    listaPolylines.add( polyline );
    setState(() {
      _polylines = listaPolylines;
    });

  }
*/
//-------------inserindo marcadores (taxas) no mapa geolocalização--------------
  /*
  _carregarMarcadoresTaxas() {

    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-23.563370, -46.652923),
        infoWindow: InfoWindow(
            title: "Shopping Cidade São Paulo"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta
        ),
         rotation: 45, //rotação do marcador
        onTap: () {
          print("Shopping Clicado!!");
        }
    );

    Marker marcadorCartorio = Marker(
        markerId: MarkerId("marcador-cartorio"),
        position: LatLng(-23.562868, -46.655874),
        infoWindow: InfoWindow(
            title: "12 Cartório de notas"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue
        ),
         //rotation: 45, //rotação do marcador
        onTap: () {
          print("Cartório clicado!!");
        }
    );

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorCartorio);

    setState(() {
      _marcadores = marcadoresLocal;
    });
    }
*/
//--------------------inserindo marcadores (ÁREA) Geométrica--------------------
/*
    _carregarMarcadoresArea() {

    Set<Polygon> listaPolygons = {};

    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 10,
        points: [
          LatLng(-23.561816, -46.652044),
          LatLng(-23.563625, -46.653642),
          LatLng(-23.564786, -46.652226),
          LatLng(-23.563085, -46.650531),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("Clicado na área marcada 1");
        },
        zIndex: 0 //posicionamento do polygon superior ou inferior
    );

    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon2"),
        fillColor: Colors.transparent,
        strokeColor: Colors.orange,
        strokeWidth: 10,
        points: [
          LatLng(-23.561629, -46.653031),
          LatLng(-23.565189, -46.651872),
          LatLng(-23.562032, -46.650831),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("Clicado na área marcada 2");
        },
        zIndex: 1 //posicionamento do polygon superior ou inferior
    );

    listaPolygons.add( polygon1 );
    listaPolygons.add( polygon2 );

    setState(() {
      _polygons = listaPolygons;
    });
  }
 */
//------------------------------------------------------------------------------
/*
 Future _recuperarLocalizacaoAtual() async{

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      _posicaoCamara = CameraPosition(
        target: LatLng( position.latitude, position.longitude),
        zoom: 17
      );
      _movimentarCamera();
    });

    //print("Localização Atual: " + position.toString());

  }
*/
  _adicionarListenerLocalizacao () async{

     final locationOptions = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
    );

     StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
         locationSettings: locationOptions).listen(
            (Position position) {
              print(position == null
              ? 'Erro de localização'
              : '${position.latitude.toString()}, ${position.longitude.toString()}');

//--------Exemplo:-pode-se usar um marcador no local do usuário-----------------
/*
             Marker marcadorUsuario = Marker(
                  markerId: MarkerId("marcador-usuario"),
                  position: LatLng(position.latitude, position.longitude),
                  infoWindow: InfoWindow(
                      title: "Meu Local"
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue
                  ),
                  //rotation: 45, //rotação do marcador
                  onTap: () {
                    print("Meu local Clicado");
                  }
              );
              //OBS: Ativar os marcadores no setState e no child do googlemaps
*/
//--------------------Continuação do StreamSubscription---ABAIXO:---------------

     setState(() {
       //_marcadores.add( marcadorUsuario );
       _posicaoCamara = CameraPosition(
           target:  LatLng( position.latitude, position.longitude),
           zoom: 17
       );
      _movimentarCamera();
    });
            });
  }

  @override
  void initState() {
    super.initState();
    //_carregarMarcadoresTaxas();
    //_carregarMarcadoresArea();
    //_carregarMarcadoresLines();
    //_recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: Center(
                child: Text("Mapas Geolocalização",
                  style: TextStyle(
                      color: Colors.black
                  ),)
            )
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 3,
          child: Icon(Icons.done),
          onPressed:_movimentarCamera
        ),

        body: Container(

          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _posicaoCamara,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: _marcadores,
            polygons: _polygons,
            polylines: _polylines,
          ),
        ),
      );
    }
  }

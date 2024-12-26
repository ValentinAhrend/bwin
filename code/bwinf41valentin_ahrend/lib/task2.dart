import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class Task2Widget extends StatefulWidget {
  const Task2Widget({super.key});

  @override
  State<Task2Widget> createState() => _Task2WidgetState();
}

class _Task2WidgetState extends State<Task2Widget> {
  int tickDuration = 10;
  RawImage? currentDisplay;
  int aktuellerTick = 0;

  TextEditingController tickGeschwindigkeitController = TextEditingController(text: "100");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aufgabe 2: Verzinkt",
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
            const SizedBox(
              height: 25.0,
            ),
            const Text(
              "Hier wird die Entstehung des Musters eines feuerverzinkten Metalls simultiert. Das Wachstum wird in Tick pro Wachstum angegeben.",
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(
              height: 25.0,
            ),
            SizedBox(
            width: 250.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: tickGeschwindigkeitController,
                decoration: InputDecoration(
                  labelText: "Tick-Geschwindigkeit in ms",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) < 0){
                    tickGeschwindigkeitController.text = "";
                  }else{
                    setState(() {
                      tickDuration = int.parse(change);
                    });
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
              height: 15.0,
            ),
            aktuellerTick == 0 ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: kristalleToWidget(),
            ) : Container(),
            const SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              child: Container(
                width: 150.0,
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[100]!),
                child: const Center(
                  child: Text(
                    "Keim Hinzufügen",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () => {zufaelligerKristall()},
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              child: Container(
                width: 150.0,
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.lime[700]),
                child: Center(
                  child: Text(
                    aktuellerTick == 0 ? "Simulation Starten": "Simulation Stoppen",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () {
                if(aktuellerTick == 0){
                  simulationStarten();
                }else{
                  simulationStoppen();
                }
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                border: Border.all(color: Colors.black, width: 0.5)
              ),
              child: Center(
                child: currentDisplay ?? Container(),
              ),
            )
          ],
        ))));
  }

  /// Die standart From der SimulationsMap. Die Map fungiert wie ein Raster. Mit einer Laenge und Hoehe von 500 Einheiten (jeweils).
  /// In der simulationMap sind die einzelnen Grau-Toene der Kristalle als int Wert von 40 bis 215 (entsprechend rgb(40,40,40) und rgb(215,215,215)) eingetragen.
  /// Das Raster stellt bei -1 keine Farbe dar.
  List<List<int>> simulationMap =
      List.generate(500, (index) => List.generate(500, (index0) => -1));

  /// In diesem Set befinden sich die aktuell verwendeten Kristalle.
  Set<Crystal> aktuelleKristalle = {};

  void simulationStarten() {
    /// bevor die Simulation gestartet wird, müssen die Keime bzw. Grund-Kristalle erstellt werden. (siehe if-Clause unten)
    /// Die Kristalle samt Position (Grau-Ton bzw. Orientierung, Wachstumsgeschwindigkeiten) sind über das Kontrolldisplay
    /// schon vorher in die simulationMap eingetragen und zu den aktuellenKristallen hinzugefügt worden (ursprünglich mittels der zufaelligerKristall Methode).

    if (aktuelleKristalle.isEmpty) {
      /// es gibt keine Grundbausteine, daher kein Start moeglich.
      return;
    }

    /// zum Start wird die runTick Methode mit dem 1. Tick Aufgerufen.
    /// Ich nutze den 0. nicht, da sonst die Liste der Keime (bzw. Grund-Kristalle), die der Benutzer selbst
    /// eingestellt hat, für einen Moment die neu entstandenen Kristalle anzeigt.
    runTick(1);
  }

  void simulationStoppen() {
    /// mit dieser Methode wird die Simulation gestoppt bzw. zurückgesetzt:
    setState(() {
      aktuelleKristalle = {};
      aktuellerTick = 0;
      simulationMap = List.generate(500, (index) => List.generate(500, (index0) => -1));
      sendToUI(0);
    });
  }

  void runTick(int tickNummer) async {
    /// Die Simulation ist in Ticks unterteilt. Dabei entspricht ein Tick dem durchlauf der Methode runTick.
    /// Bei jedem durchlauf wird bei jedem wachsenden Kristall überprüft, welche Seite (oben, unten, links, rechts) hinzugefügt wird.
    /// Die Kristalle sind hier in Form der Crystal Klasse dargelegt.
    ///
    /// Die tickNummer bestimmt den aktuellen Tick bzw. die Zeit.
    /// Wie lange ein Tick dauert, kann vom Benutzer festgelegt werden.

    if (aktuelleKristalle.isEmpty) {
      /// wenn die Liste aktuellerKirstalle leer ist, so ist die Simulation beendet.
      return;
    }

    /// Es werden nun alle Kristalle aus aktuelleKirstalle nacheinander auf Wachstum überprüft.
    for (Crystal kristall in aktuelleKristalle.toList()) {
      Set<Crystal> neueKirstalle =
          kristall.neueKristalle(simulationMap, tickNummer);
      if (neueKirstalle.length == 1 &&
          neueKirstalle.first.creationStatus == 4) {
        aktuelleKristalle.remove(kristall);
      } else {
        aktuelleKristalle.addAll(neueKirstalle);
      }
    }

    /// Die neue Version der simulationMap wird in die UI übertragen:
    sendToUI(tickNummer);

    /// Warten bis die tickDuration vorbei ist und der naechste Tick ausgeführt werden kann.
    await Future.delayed(Duration(milliseconds: tickDuration));
    runTick(tickNummer + 1);
  }

  /// das Raster wird in ein img.Image Objekt eingetragen und anschließend auf ein Image-Widget projeziert.
  void sendToUI(int tickNummer) {
    img.Image image = img.Image.rgb(500, 500);
    for (var i = 0; i < simulationMap.length; i++) {
      for (var j = 0; j < simulationMap[i].length; j++) {
        final c = simulationMap[i][j];
        if (c == -1) {
          image.setPixelSafe(j, i, hexOfRGB(255, 255, 255));
        } else {
          image.setPixelSafe(j, i, hexOfRGB(c, c, c));
        }
      }
    }

    /// Pixel -> Image
    decodeImageFromPixels(
        image.data.buffer.asUint8List(),
        500,
        500,
        PixelFormat.rgba8888,
        (result) {
              /// Übertragung in UI
              if(!mounted){
                return;
              }
              setState(() {
                currentDisplay = RawImage(
                  image: result,
                );
                aktuellerTick = tickNummer;
              });
            });
  }

  List<Widget> kristalleToWidget() {
    List<Widget> widgets = [];
    int index = 0;
    for (Crystal kristall in aktuelleKristalle) {
      final index0 = index;
      index += 1;
      final TextEditingController xC = TextEditingController(text: kristall.positionX.toString());
      final TextEditingController yC = TextEditingController(text: kristall.positionY.toString());
      final TextEditingController mC = TextEditingController(text: kristall.orientierung.toString());
      final TextEditingController oC = TextEditingController(text: kristall.wachstumsGeschwindigkeiten[0].toString());
      final TextEditingController lC = TextEditingController(text: kristall.wachstumsGeschwindigkeiten[3].toString());
      final TextEditingController uC = TextEditingController(text: kristall.wachstumsGeschwindigkeiten[2].toString());
      final TextEditingController rC = TextEditingController(text: kristall.wachstumsGeschwindigkeiten[1].toString());
      final TextEditingController sC = TextEditingController(text: kristall.startTickNummer.toString());

      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: Center(child: Text(
              "Keim${kristall.hashCode}",
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 115.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: xC,
                decoration: InputDecoration(
                  labelText: "X-Koordinate",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) >= 500 || int.parse(change) < 0){
                    xC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.positionX = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                    xC.selection = TextSelection.fromPosition(TextPosition(offset: xC.text.length));
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 115.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: yC,
                decoration: InputDecoration(
                  labelText: "Y-Koordinate",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) >= 500 || int.parse(change) < 0){
                    yC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.positionY = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 160.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: mC,
                decoration: InputDecoration(
                  labelText: "Orientierung 40-215",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) > 215){
                    mC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.orientierung = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 135.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: oC,
                decoration: InputDecoration(
                  labelText: "Wachstum oben",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) > 500 || int.parse(change) < 0){
                    oC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.wachstumsGeschwindigkeiten[0] = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 140.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: rC,
                decoration: InputDecoration(
                  labelText: "Wachstum rechts",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) > 500 || int.parse(change) < 0){
                    rC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.wachstumsGeschwindigkeiten[1] = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 135.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: uC,
                decoration: InputDecoration(
                  labelText: "Wachstum unten",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) > 500 || int.parse(change) < 0){
                    uC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.wachstumsGeschwindigkeiten[2] = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 135.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: lC,
                decoration: InputDecoration(
                  labelText: "Wachstum links",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change){
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) > 500 || int.parse(change) < 0){
                    lC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.wachstumsGeschwindigkeiten[3] = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          SizedBox(
            width: 135.0,
            height: 50.0,
            child: TextFormField(
                autofocus: true,
                controller: sC,
                decoration: InputDecoration(
                  labelText: "Spawn nach",
                  labelStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.lime[700]!, width: 1.0)),
                ),
                onChanged: (change) {
                  /// die Eingabe muss eine Zahl sein, und muss kleiner als 500 und größer als 0 sein.
                  if(int.tryParse(change) == null || int.parse(change) < 0){
                    sC.text = "";
                  }else{
                    final Crystal vorher = kristall.copy();
                    kristall.startTickNummer = int.parse(change);
                    updateKristall(vorher, kristall, index0);
                  }
                },
                cursorColor: Colors.lime),
          ),
          const SizedBox(
            width: 25.0,
          ),
          GestureDetector(
              child: Container(
                width: 150.0,
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[100]),
                child: const Center(
                  child: Text(
                    "Löschen",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () => {kristallLoeschen(kristall)},
            ),
        ],
      ));
      xC.selection = TextSelection.fromPosition(TextPosition(offset: xC.text.length));
      yC.selection = TextSelection.fromPosition(TextPosition(offset: yC.text.length));
      oC.selection = TextSelection.fromPosition(TextPosition(offset: oC.text.length));
      rC.selection = TextSelection.fromPosition(TextPosition(offset: rC.text.length));
      uC.selection = TextSelection.fromPosition(TextPosition(offset: uC.text.length));
      lC.selection = TextSelection.fromPosition(TextPosition(offset: lC.text.length));
      mC.selection = TextSelection.fromPosition(TextPosition(offset: mC.text.length));
      sC.selection = TextSelection.fromPosition(TextPosition(offset: sC.text.length));

      widgets.add(const SizedBox(height: 15.0,));
    }
    return widgets;
  }

  void zufaelligerKristall() {

    /// wenn die Simulation bereits im Gange ist, soll kein neuer Kristall hinzugefügt werden.
    if(aktuellerTick != 0){
      return;
    }

    /// ein zufälliger Kristall wird erstellt.
    Random random = Random();
    Crystal randomCrystal = Crystal(0, random.nextInt(175) + 41,
        random.nextInt(500), random.nextInt(500), [
      random.nextInt(6) + 1,
      random.nextInt(6) + 1,
      random.nextInt(6) + 1,
      random.nextInt(6) + 1
    ]);
    aktuelleKristalle.add(randomCrystal);
    simulationMap[randomCrystal.positionY][randomCrystal.positionX] =
        randomCrystal.orientierung;
    sendToUI(0);
  }

  void kristallLoeschen(Crystal kristall) {
    /// ein Keim bzw. Grund-Kristall wird gelöscht
    aktuelleKristalle.remove(kristall);
    simulationMap[kristall.positionY][kristall.positionX] = -1;
    sendToUI(0);
  }

  void updateKristall(Crystal vorherigerKristall, Crystal updatedKristall, int index){
    /// wenn sich ein Wert bei einem Kristall verändert wird, muss dies auch in dem Set aktuelleKristalle verändert werden bzw. in simulationMap
    //replace(aktuelleKristalle, index, updatedKristall);
    simulationMap[vorherigerKristall.positionY][vorherigerKristall.positionX] = -1;
    simulationMap[updatedKristall.positionY][updatedKristall.positionX] = updatedKristall.orientierung;
    sendToUI(0);
  }

  /// Eine Methode, um rgb-Farben in hex-int-Farben umzuwandeln (src:https://stackoverflow.com/a/57748584/12961658)
  int hexOfRGB(int r, int g, int b) {
    r = (r < 0) ? -r : r;
    g = (g < 0) ? -g : g;
    b = (b < 0) ? -b : b;
    r = (r > 255) ? 255 : r;
    g = (g > 255) ? 255 : g;
    b = (b > 255) ? 255 : b;
    return int.parse(
        '0xff${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}');
  }
  /// Eine Methode, um ein Element eines Sets zu updaten (src:https://stackoverflow.com/a/58378428/12961658)
  void replace<T>(Set<T> set, int index, T newValue) {
    if (set.contains(newValue)) throw StateError("New value already in set");
    int counter = 0;
    while (counter < set.length) {
      var element = set.first;
      set.remove(element);
      if (counter == index) element = newValue;
      set.add(element);
      counter++;
    }
  }

}

class Crystal {

  Crystal copy() {
    return Crystal(startTickNummer, orientierung, positionX, positionY, wachstumsGeschwindigkeiten);
  }

  /// dieser Wert beschreibt, bei welchem Tick der Kristall erstellt wurde.
  int startTickNummer;

  /// die Orientierung des Kristalls legt fest, (wie der Kristall das Licht reflektiert) bzw. welchen Grau-Ton der Kristall in der Darstellung verwendet.
  /// Der Grau-Ton geht von 40 bis 215 (entsprechend rgb(40,40,40) und rgb(215,215,215))
  /// Die Orientierung veraendert sich bei Wachstum nicht.
  int orientierung;

  /// die X-Koordinate des Kristalls im Raster
  int positionX;

  /// die Y-Koordinate des Kristalls im Raster
  int positionY;

  /// eine Liste, die die Anzahl an Ticks angibt, die eine der 4 Seiten braucht, um zu wachsen.
  /// [oben, links, unten, rechts], length = 4
  /// Die Wachstumsgeschwindigkeit aendert sich bei Wachstum nicht (sie wird weiter übetragen).
  List<int> wachstumsGeschwindigkeiten;

  /// Dieser Wert gibt an, ob der Kristall sich in irgwendeine Richtung schon ausgebreitet hat. (max = 4).
  /// Falls das Ausbreiten nicht moeglich war, weil ein anderer Kristall dort bereits existierte, so wird der creationStatus dennoch erhoeht.
  int creationStatus = 0;

  Crystal(this.startTickNummer, this.orientierung, this.positionX,
      this.positionY, this.wachstumsGeschwindigkeiten);

  /// Diese Methode überprüft, ob rechts, links, oben und unter dem Kristall die Moeglichkeit zur Entstehung von einem neuen Kristall mit gleicher Orientierung besteht.
  /// Falls ja, wird überprüft, ob die Wachstumsgeschwindigkeit der Seite mit dem aktuellen Tick übereinstimmt.
  /// Wenn ein neuer Kristall erstellt wird, wird dieser in in einem Set wieder ausgegeben und anschließend in der Methode runTick den aktuellen Kristallen hinzugefügt.
  ///
  Set<Crystal> neueKristalle(List<List<int>> simulationMap, int currentTick) {
    Set<Crystal> ausgabe = {};

    if (creationStatus == 4) {
      /// alle Seiten wurden bereist gefüllt, der Kristall ist unbrauchbar.
      ausgabe.add(this);

      /// die Ausgabe wird überprüft. Falls das einzige Element einen creationStatus von 4 hat wird der Kristall von den aktuellen Kristallen entfernt.
      /// Hiermit wird der Kristall also als überflüssig markiert.
      return ausgabe;
    }

    /// Oben wird überprüft:
    /// überprüfe, ob es sich um den oberen Rand handelt (also position_y = 0)
    if (positionY > 0) {
      if (wachstumsGeschwindigkeiten[0] + startTickNummer <= currentTick) {
        /// wenn die Bedingung erfüllt ist, kann ein Kristall wachsen (oben)
        /// überprüfen, ob an dieser Stelle bereits ein Kristall exisitiert:
        if (simulationMap[positionY - 1][positionX] == -1) {
          /// frei
          /// in der simulationMap wird der Platz mit der Orientierung belegt
          simulationMap[positionY - 1][positionX] = orientierung;

          Crystal neuerKristall = Crystal(currentTick, orientierung, positionX,
              positionY - 1, wachstumsGeschwindigkeiten);
          ausgabe.add(neuerKristall);
        }else{
          if(simulationMap[positionY - 1][positionX] != orientierung){
            creationStatus += 1;
          }
        }
      }
    }

    /// für links
    if (positionX > 0) {
      if (wachstumsGeschwindigkeiten[1] + startTickNummer <= currentTick) {
        /// wenn die Bedingung erfüllt ist, kann ein Kristall wachsen (links)
        /// überprüfen, ob an dieser Stelle bereits ein Kristall exisitiert:
        if (simulationMap[positionY][positionX - 1] == -1) {
          /// frei
          /// in der simulationMap wird der Platz mit der Orientierung belegt
          simulationMap[positionY][positionX - 1] = orientierung;

          Crystal neuerKristall = Crystal(currentTick, orientierung,
              positionX - 1, positionY, wachstumsGeschwindigkeiten);
          ausgabe.add(neuerKristall);
        }else{
          if(simulationMap[positionY][positionX - 1] != orientierung){
            creationStatus += 1;
          }
        }
      }
    }

    /// für unten
    if (positionY + 1 < simulationMap.length) {
      if (wachstumsGeschwindigkeiten[1] + startTickNummer <= currentTick) {
        /// wenn die Bedingung erfüllt ist, kann ein Kristall wachsen (unten)
        /// überprüfen, ob an dieser Stelle bereits ein Kristall exisitiert:
        if (simulationMap[positionY + 1][positionX] == -1) {
          /// frei
          /// in der simulationMap wird der Platz mit der Orientierung belegt
          simulationMap[positionY + 1][positionX] = orientierung;

          Crystal neuerKristall = Crystal(currentTick, orientierung, positionX,
              positionY + 1, wachstumsGeschwindigkeiten);
          ausgabe.add(neuerKristall);
        }else{
          if(simulationMap[positionY + 1][positionX] != orientierung){
            creationStatus += 1;
          }
        }
      }
    }

    /// für rechts
    if (positionX + 1 < simulationMap[0].length) {
      if (wachstumsGeschwindigkeiten[1] + startTickNummer <= currentTick) {
        /// wenn die Bedingung erfüllt ist, kann ein Kristall wachsen (rechts)
        /// überprüfen, ob an dieser Stelle bereits ein Kristall exisitiert:
        if (simulationMap[positionY][positionX + 1] == -1) {
          /// frei
          /// in der simulationMap wird der Platz mit der Orientierung belegt
          simulationMap[positionY][positionX + 1] = orientierung;

          Crystal neuerKristall = Crystal(currentTick, orientierung,
              positionX + 1, positionY, wachstumsGeschwindigkeiten);
          ausgabe.add(neuerKristall);
        }else{
          if(simulationMap[positionY][positionX + 1] != orientierung){
            creationStatus += 1;
          }
        }
      }
    }

    return ausgabe;
  }
}

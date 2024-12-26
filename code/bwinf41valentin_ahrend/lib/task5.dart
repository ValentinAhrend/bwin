// ignore_for_file: unnecessary_this
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Task5Widget extends StatefulWidget {
  const Task5Widget({super.key});

  @override
  State<Task5Widget> createState() => _Task5WidgetState();
}

class _Task5WidgetState extends State<Task5Widget> {


  /// Controller des Eingabefeldes
  late final TextEditingController _controllerMika;
  late final TextEditingController _controllerSasha;

  /// Dargestellte Lösung in der GUI
  String result = "";

  /// ausgewhälte Datei (0-5);
  int aktuelleDatei = 0;

  /// die Startpositionen von Mika und Sasha
  int startPositionMika = -1;
  int startPositionSasha = -1;

  @override
  void initState() {
    super.initState();
    _controllerMika = TextEditingController();
    _controllerSasha = TextEditingController();
  }

  @override
  void dispose() {
     _controllerMika.dispose();
     _controllerSasha.dispose();
     gefundenesPaar = [Runner(-1, [], -1)];
    super.dispose();
  }


  /// GUI für task1, Aufgabe 1
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Aufgabe 5: Huepfburg", style: TextStyle(fontSize: 24.0, color: Colors.black),),
          const SizedBox(
                height: 25.0,
              ),
          RichText(
              text: TextSpan(
                text: "Sie können zwischen den 5 Beispiel-Hüpfburgen wählen. Die Regeln für das Spiel finden Sie ",
                children: [
                  TextSpan(
                    text: "hier",
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap=(){
                      launchUrlString("https://bwinf.de/fileadmin/bundeswettbewerb/41/Bundeswettbewerb_41_Aufgabenblatt_WEB.pdf");
                    }
                  ),
                  const TextSpan(
                    text: ".",
                  )
                ],
                style: const TextStyle(fontSize: 14.0, color: Colors.black)
              ),
            ),
          const SizedBox(
                height: 25.0,
              ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              EinzelneHuepfburg(name: "huepfburg0.txt", onClick: ()=>(){
                setState(() {
                  aktuelleDatei = 0;
                });
              }, selected: aktuelleDatei == 0,),
              EinzelneHuepfburg(name: "huepfburg1.txt", onClick: ()=>(){
                setState(() {
                  aktuelleDatei = 1;
                });
              }, selected: aktuelleDatei == 1),
              EinzelneHuepfburg(name: "huepfburg2.txt", onClick: ()=>(){
                setState(() {
                  aktuelleDatei = 2;
                });
              }, selected: aktuelleDatei == 2),
              EinzelneHuepfburg(name: "huepfburg3.txt", onClick: ()=>(){
                setState(() {
                  aktuelleDatei = 3;
                });
              }, selected: aktuelleDatei == 3),
              EinzelneHuepfburg(name: "huepfburg4.txt", onClick: ()=>(){
                setState(() {
                  aktuelleDatei = 4;
                });
              }, selected: aktuelleDatei == 4),
            ],
          ),
          const SizedBox(
                height: 25.0,
              ),
          Row(children: [
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: TextFormField(
            controller: _controllerSasha,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Startposition Sasha",
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
            ),
            cursorColor: Colors.lime
          ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: TextFormField(
            controller: _controllerMika,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Startposition Mika",
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.lime[700]!, width: 1.0)
              ),
            ),
            cursorColor: Colors.lime
          ),
            )
            ],),
            const SizedBox(
                height: 25.0,
              ),
          GestureDetector(
            child: Container(
              width: 150.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.lime[700]
              ),
              child: const Center(
                child: Text("Analysieren", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),),
              ),
            ),
            onTap: ()=> {
              analysieren()
            },
          ),
          const SizedBox(
                height: 25.0,
              ),
          SizedBox(child: Container(
            height: 180.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center( // add this
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Ausgabe:\n$result", style: const TextStyle(color: Colors.black, fontSize: 14.0),),
                )),
          )))
        ],
    ));
  }


  
  /// Aufgabe 5 Analyse
  void analysieren() async {
    logResult("Laden...");


    /// Start-Positionen werden abgelesen.
    if(int.tryParse(_controllerMika.text) != null){
      startPositionMika = int.parse(_controllerMika.text);
    }else{
      logResult("Startposition ist falsch formattiert.");
      return;
    }
    if(int.tryParse(_controllerSasha.text) != null){
      startPositionSasha = int.parse(_controllerSasha.text);
    }else{
      logResult("Startposition ist falsch formattiert.");
      return;
    }
    if(startPositionMika == -1 || startPositionSasha == -1){
      logResult("Bitte geben Sie die Startfelder von Sasha und Mika an.");
      return;
    }
    /// laden der 'huepfburg'
    String huepfburg = await rootBundle.loadString("assets/aufgabe_5_huepfburg/huepfburg$aktuelleDatei.txt");
    List<String> zeilen = huepfburg.split("\n");

    List<String> datenZeile0 = zeilen[0].split(" ");
    int? anzahlFelder = int.tryParse(datenZeile0[0]);
    int? anzahlPfeile = int.tryParse(datenZeile0[1]);

    if(anzahlFelder == null || anzahlPfeile == null){
      logResult("Datei ist falsch formatiert.");
      return;
    }

    if(startPositionMika < 1 || startPositionMika > anzahlFelder || startPositionSasha < 1 || startPositionSasha > anzahlFelder){
      logResult("Die Startpositionen sind nicht korrekt (innerhalb der Hüpfburg).");
      return;
    }

    /// nun wird die Grund-Liste der Punkte aufgestellt.+
    List<Punkt> allePunkte = [];

    for (var i = 0; i < anzahlFelder; i++) {
      allePunkte.add(Punkt.leererPunkt());
    }

    /// alle Zeilen nach der 1. Zeile
    for (String zeile in zeilen.getRange(1, zeilen.length)) {
      List<String> datenZeile0 = zeile.split(" ");
      int feldA = int.parse(datenZeile0[0]);
      int feldB = int.parse(datenZeile0[1]);
      
      /// die Feld-Nummer entspricht dem Index +1 (In allePunkte).
      
      if(allePunkte[feldA - 1].leer()){
        Punkt punktA = Punkt(feldA, {feldB});
        allePunkte[feldA - 1] = punktA;
      }else{
        allePunkte[feldA - 1].verbindungAddieren(feldB);
      }
    }

    /// Felder, die keine Verbindung haben, aber selber als Ednverbindung dienen, sind noch nicht inkludiert.
    /// Daher werden die Verbindungen der Punkte überprüft und evtl Ergänzungen vorgenommen:
    /// an bestimmten Indexen fehlt also noch ein Punkt bzw. Punkt.leer() == true.
    /// Daher muss dort der leere Punkt durch einen richtigen Punkt ersetzt werden.
    
    for (var i = 0; i < allePunkte.length; i++) {
      if(allePunkte[i].leer()){
        allePunkte[i] = Punkt(i + 1, const {});
      }
    }
    print(allePunkte);
    /// Es folgt die Simulation der Huepfburg.
    /// Dabei wird bei jeder Entscheidung bzw. bei jedem Punkt mit mehreren Verbindungen ein neuer
    /// 'Runner' hinzugefügt. Ein Runner springt bei jedem Tick auf den nächsten Punkt.
    /// Mit registriereRunner wird ein Runner bei einem Punkt aufgenommen.
    /// Gleichzeitig werden in dieser Methode den Runnern (es können auch mehrere sein)
    /// ihre Verbindung (also ihr nächster Punkt) zugeordnet. Wenn allen Runnern ihr nächster
    /// Punkt zugeteilt wurde, werden die Runner von dem Punkt getrennt und die Runner fügen sich selbstständig
    /// dem nächsten Punkt hinzu.
    /// 
    /// Die Runner unterschieden sich in Typ 1 und Typ 2 (Mika und Sasha). 
    /// Die Runner speichern ihren absolvierten Weg in einer Liste.
    /// Wenn in Punkt ein neuer Runner erstellt wird, nimmt dieser den zurückgelegten Weg (den kürzesten Weg) aller anderen Runner an.
    runnerErstellen(startPositionMika, startPositionSasha, allePunkte);
    List<Runner> wege = await handleRunner(0);
    if(wege.isEmpty){
      logResult("Es konnten keine Wege gefunden werden. Der Parcour ist nicht möglich (mit diesem Startpositionen)");
    }else{
      print(wege.first.gelaufeneFelder.length);
      logResult("${wege[0].wegDarstellen()}\n${wege[1].wegDarstellen()}");
    }

  }
  List<Runner> gefundenesPaar = [];

  List<Runner> aktuelleRunner = [];
  List<Punkt> aktuellePunkte = [];

  /// In dieser Methode werden die Runner ihrem nächsten Punkt zugeordnet. 
  /// Anschließned führt jeder Punkt die Test Methode durch
  /// Danach werden die Runner wieder von ihrem Punkt gelöscht (und die Methode wiederholt sich)
  Future<List<Runner>> handleRunner(int index) async{

    /// die Maximale Anzahl an Iteration ist als aktuellePunkte * aktuellePunkte festgelegt.
    if(aktuelleRunner.first.gelaufeneFelder.length > aktuellePunkte.length * aktuellePunkte.length) {
      return [];
    } 


    /// wenn die Lösung bereits gefunden wurde, ist die Simulation vorbei.
    if(gefundenesPaar.isNotEmpty){
      return gefundenesPaar;
    }

    if(index % 100 == 0){
      /// Sonst entsteht ein StackOverFlow Error (ungebremste Rekursion)
      await Future.delayed(const Duration(milliseconds: 1)); 
    }

    bool erfolg = false;
    /// überprüfe, ob es noch Runner beider Typen gibt.
    int gefundenerTyp = aktuelleRunner.first.typ;
    for (Runner runner in aktuelleRunner) {
      /// runner wird Punkt zugeorndet
      if(!erfolg && runner.typ != gefundenerTyp){
          /// es gibt noch Runner beieder Typen, die Simulation wird fortgeführt.
          erfolg = true;
      }
      aktuellePunkte[runner.naechsterPunkt - 1].runnerAddieren(runner);
    }
    if(!erfolg){
      /// Simulation ist vorbei, da nur noch Runner eines Types bzw. eines Spielers existieren.
      /// (es käme in Zukunft auch nicht zu einer Lösung).
      return [];
    }
print("nach $index $aktuelleRunner");
    aktuelleRunner = [];

    for (Punkt punkt in aktuellePunkte) {
      /// punkte werden getestet
      if(punkt.test().isEmpty){
        Set<Runner> neueRunner = punkt.runnerAbmelden();
        aktuelleRunner.addAll(neueRunner);
      }else{
        gefundenesPaar = punkt.test();
        return gefundenesPaar;
      }
    }


    ///wiederholen
    return handleRunner(index + 1);
  }

  void runnerErstellen(int startPositionMika, int startPositionSasha, List<Punkt> aktuellePunkte) {
    /// Es werden zunächst zwei Runner an den jeweiligen Startpositionen erstellt.
    Runner mika = Runner(0, [], startPositionMika);
    Runner sasha = Runner(1, [], startPositionSasha);
    aktuelleRunner = [];
    aktuelleRunner.add(mika);
    aktuelleRunner.add(sasha);
    print(aktuelleRunner);
    gefundenesPaar = [];
    this.aktuellePunkte = aktuellePunkte;
  }

  void logResult(String msg) {
    setState(() {
      result = msg;
    });
  }
}


/// Die Runner-Klasse stellt einen Weg eines Spielers dar.
/// Die gelaufeneFelder sind der gelaufene Weg
/// Der Runner wird immer dem Punkt mit der id == naechsterPunkt zugeordnet.
class Runner {
  final int typ; ///typ = 0 -> Mika,  typ = 1 -> Sasha
  final List<int> gelaufeneFelder;
  
  int naechsterPunkt;

  /// ein Runner wird aus einem anderen Runner erstellt.
  static Runner from(Runner runner){

    String felder = runner.gelaufeneFelder.join(",");

    return Runner(runner.typ, felder.isEmpty ? [] : felder.split(",").map((e) => int.parse(e)).toList(), runner.naechsterPunkt);
  }

  /// der naechsterPunkt ist der Startpunkt des Runners
  Runner(this.typ, this.gelaufeneFelder, this.naechsterPunkt);

  @override
  String toString() {
    return "Runner: $typ ${this.gelaufeneFelder} ${this.naechsterPunkt}";
  }

  String wegDarstellen() {
    return "${typ == 0 ? "Mika: " : "Sasha: "}${gelaufeneFelder.join(" -> ")} -> $naechsterPunkt";
  }

}

/// Diese Klasse stellt ein Feld dar und beinhaltet die id (also die Nummer des Feldes) und die Verbindungen des Feldes.
class Punkt {

  static Punkt leererPunkt() {
    return Punkt(-1, {});
  }

  final int id;
  Set<int> verbindungen;

  /// Teil 2
  Set<Runner> aktuelleRunner = {};

  Punkt(this.id, this.verbindungen);

  /// Hier wird ausgegeben, ob das Feld meherer Verbindungen hat oder nur eine.
  bool mehrfacheVerbindung() {
    return verbindungen.length > 1;
  }

  /// Hier wird ausgegeben, ob das Feld das Ende einer Kette sein kann bzw. keine weiteren Verbindungen hat.
  bool ende() {
    return verbindungen.isEmpty;
  }

  /// fügt Verbindungen hinzu.
  void verbindungAddieren(int neueVerbindung) {
    verbindungen.add(neueVerbindung);
  }

  /// gibt an, ob es sich um einen Dummy Punkt handelt.
  bool leer() {
    return id == -1;
  }

  /// Hier wird getestet, ob sich in dem Set<Runner> aktuelleRunner, Runner mit unterschiedlichem Typ befinden.
  /// Wenn ja, ist das Spiel erfolgreich.
  List<Runner> test() {
    int runnerTyp = -1;
    Runner? letzterRunner;
    for (Runner runner in aktuelleRunner) {
      if(runnerTyp == -1){
        runnerTyp = runner.typ;
        letzterRunner = runner;
      }else{
        if(runnerTyp != runner.typ){
          /// found!
          return [runner, letzterRunner!];
        }else{
          letzterRunner = runner;
        }
      }
    }
    return [];
  }

  /// Ein Runner Wird hinzugefügt.
  void runnerAddieren(Runner runner){
    aktuelleRunner.add(runner);
  }

  /// Runner werden abgemeldet und als Set zurückgegeben.
  Set<Runner> runnerAbmelden() {

    if(aktuelleRunner.isEmpty){
      return {};
    }

    if(aktuelleRunner.length < verbindungen.length) {

      int neueRunnerAnzahl = verbindungen.length - aktuelleRunner.length;
      for (var i = 0; i < neueRunnerAnzahl; i++) {
        aktuelleRunner.add(Runner.from(aktuelleRunner.first));
      }
    }else{
      if(verbindungen.length < aktuelleRunner.length) {
        int removeRunnerAnzahl = aktuelleRunner.length - verbindungen.length;
        aktuelleRunner.removeAll(aktuelleRunner.toList().getRange(0, removeRunnerAnzahl));
      }
    }

    Set<Runner> ausgabeRunners = {};

    /// verbindungen werden den Runnern zugeordnet
    int i = 0;
    for (Runner runner in aktuelleRunner) {
      int verbindung = verbindungen.elementAt(i);
      runner.gelaufeneFelder.add(runner.naechsterPunkt);
      runner.naechsterPunkt = verbindung;
      ausgabeRunners.add(Runner(runner.typ, runner.gelaufeneFelder, runner.naechsterPunkt));
      i++;
    }
    
    aktuelleRunner.clear();

    return ausgabeRunners;

  }

  @override
  String toString() {
    return "Punkt: $id, $verbindungen";
  }
}


/// UI-Widget nicht wichtig
/// Stellt einen Button dar.
class EinzelneHuepfburg extends StatelessWidget {
  final String name;
  final Function onClick;
  final bool selected;
  const EinzelneHuepfburg({super.key, required this.name, required this.onClick, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onClick(),
    child: Container(
      height: 30,
      width: 120.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: selected ? Border.all(color: Colors.lime, width: 2.0) : Border.all(color: Colors.black, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            offset: const Offset(0, 1),
            spreadRadius: 1.0,
            blurRadius: 0.5
          )
        ]
      ),
      child: Center(
        child: Text(name),
      ),
    ),
    );
  }
}
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Task1Widget extends StatefulWidget {
  const Task1Widget({super.key});

  @override
  State<Task1Widget> createState() => _Task1WidgetState();
}

class _Task1WidgetState extends State<Task1Widget> {


  /// Controller des Eingabefeldes
  late final TextEditingController _controller;

  /// Dargestellte Lösung in der GUI
  String result = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// gibt Text in Eingabe Feld ein.
  void enterToPrompt(String text) {
    _controller.text = text;
  }


  /// GUI für task1, Aufgabe 1
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Aufgabe 1: Störung", style: TextStyle(fontSize: 24.0, color: Colors.black),),
          const SizedBox(
                height: 25.0,
              ),
          RichText(text: TextSpan(
            children: [
              const TextSpan(
                text: "Gegeben ist der Text: ", 
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
              TextSpan(
                text: "Alice im Wunderland", 
                style: const TextStyle(fontSize: 14.0, color: Colors.grey), 
                mouseCursor: SystemMouseCursors.click,
                recognizer: TapGestureRecognizer()..onTap = () => {
                  launchUrlString("https://bwinf.de/fileadmin/bundeswettbewerb/41/Alice_im_Wunderland.txt")
                }),
              const TextSpan(
                text: ". Folgende ”Lückensätze” können durch das Klicken auf ", 
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
              TextSpan(
                text: "”Vervollständigen”", 
                style: TextStyle(fontSize: 14.0, color: Colors.lime[700])),
              const TextSpan(
                text: " durch das Programm vervollständigt werden. Es kann auch ein eigener Lückensatz eingegeben werden.", 
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ]
          )),
          const SizedBox(
                height: 25.0,
              ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              EinzelneStoerung(name: "stoerung0.txt", onClick: enterToPrompt),
              EinzelneStoerung(name: "stoerung1.txt", onClick: enterToPrompt),
              EinzelneStoerung(name: "stoerung2.txt", onClick: enterToPrompt),
              EinzelneStoerung(name: "stoerung3.txt", onClick: enterToPrompt),
              EinzelneStoerung(name: "stoerung4.txt", onClick: enterToPrompt),
              EinzelneStoerung(name: "stoerung5.txt", onClick: enterToPrompt)
            ],
          ),
          const SizedBox(
                height: 25.0,
              ),
          TextFormField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Eingabe",
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
                child: Text("Vervollständigen", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),),
              ),
            ),
            onTap: ()=> {
              auswertung()
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


  
  /// Aufgabe 1 Auswertung
  void auswertung() async {
    String eingabe = _controller.text;
    /// ueberpruefe Eingabe auf:
    /// - Länge größer als 0 / also nicht empty
    if(eingabe.isEmpty){
      return;
    }

    /// eingabe wird zunächst in einzelne Wörter unterteilt.
    List<String> woerter = textToWords(eingabe);

    /// Text 'Alice im Wunderland' wird aus assets geladen
    String alice = await rootBundle.loadString("assets/aufgabe_1_stoerung/Alice_im_Wunderland.txt");
    
    /// Lösungsidee: der String 'alice' entsprechend dem Text 'Alice_im_Wunderland.txt' wird genutzt
    /// um die Lücken im Satz zu füllen. Dabei wird versucht, den Startindex des Satzes im Text zu finden.
    /// Dabei werden die existierenden Wörter der Eingabe zur Lokalisierung verwendet.
    
    /// Zunächst wird der String alice in eine Liste aus einzelnen Wörtern gesplittet (siehe Methode textToWords)
    List<String> aliceWoerter = textToWords(alice);

    /// Zunächst wird eine Liste aller Indexe angelegt (Index = Position eines Strings in einem anderen String)
    /// Das erste sichtbare Wort legt die Indexe in dieser Liste fest.
    /// Für das nächste sichtbare Wort werden wieder alle möglichen Indexe in aliceWoerter ermittelt
    /// Anschließend wird überprüft, welcher Index in alleIndexe [einem der neu ermittelten Indexe - 1] entspricht.
    /// Bei einer Lücke, falls alleIndexe bereits gefüllt wurden, werden alle Werte um 1 (auf den jeweiligen Index der Lücke) erhöht.
    /// Das Ziel der Liste alleIndexe ist, den aktuellen Index des aktuellen eingabeWortes darzustellen,
    /// dabei wird sich die Tatsache, dass die Indexe der einzlenen Eingabewörter in aliceWoeter stets um 1 erhöhen, wenn es sich um die richtige Textstelle handelt:
    /// 
    /// Beispiel:
    /// Eingabe: das _ mir _ _ _ vor
    /// Der String "das" kommt an vielen verschiedenen Position in aliceWoerter vor. Alle Positionen bzw. Indexe werden nun in alleIndexe gelistet. Z.B. an Index 100 und Index 500
    /// 
    /// Als nächstes kommt die Lücke _, hier werden alle vorherigen Indexe um 1 erhöht. -> Index 101 und Index 501
    /// 
    /// Der String "mir" wird nun gesucht. Er hat bspw. die Indexe 102 und 300 in aliceWoerter. Vergleicht man nun die Liste (alleIndexe) mit den Indexen von "mir" so wird deutlich, 
    /// dass der Index 102 auf den Index 101 (aus alleIndexe) folgt. Demnacht wird der Index 101 mit 102 aktualisiert, während der Index 501 verworfen wird.
    /// 
    /// Bei den nöchsten 3 Lücken erhöhen sich alleIndexe wieder um 3, d.h. Index 102 -> Index 105
    /// 
    /// Der String "vor" wird nun gesucht, falls dieser einen Index von 106 in aliceWoerter aufweist, so ist die Reihe komplett und die Endposition der Eingabe steht fest.
    List<int> alleIndexe = [];

    /// Mit einem For loop wird durch die woerter Liste iteriert.
    for (var i = 0; i < woerter.length; i++) {
      String eingabeWort = woerter[i];
      /// aliceWoerter wird nach eingabeWort durchsucht, falls das eingabeWort keine Lücke ist
      if(eingabeWort != "_") {
        int indexWortInAlice = aliceWoerter.indexOf(eingabeWort);
        if(indexWortInAlice == -1){
          /// wenn indexWortInAlice == -1, so befindet sich das eingabeWort nicht in dem Text
          /// demnach ist die Eingabe nicht korrekt, da sich jedes eingabeWort im Text befinden muss.
          logResult("Eingabe ist nicht korrekt, da nicht alle sichtbaren Wörter sich im Text befinden.");
          return;
        }
        /// ueberpruefe ob es das erste sichtbare Wort ist, also alleIndexe leer ist...
        if(alleIndexe.isEmpty) {



          /// da aliceWoerter mehrmals das eingabeWort beinhaltet kann, und bei indexOf nur der erste Wert
          /// als Index in der Liste ausgegeben wird, müssen alle anderen Indexe auch gefunden bzw. überprüft
          /// werden.
          ///  
          alleIndexe.add(indexWortInAlice);
         
          /// currentIndex ist der akutelle Wert des Indexes von eingabeWort in aliceWoerter
          int currentIndex = indexWortInAlice;
          /// in dieser while-Scheleife werden alle Indexe von eingabeWort in aliceWoerter festgestellt,
          /// wenn ein Index gefunden wurde, anfangs indexWortInAlice, so wird dieser verwendet um den nächsten
          /// Index des eingabeWorts zu bestimmen. Der zweite Parameter von indexOf gibt an, ab welchem Index die Suche
          /// nach dem nächsten Index startet. Der Start-Index liegt hier bei currentIndex + 1, sodass nur ein neuer
          /// Index gefunden werden kann. Ist dieser neue Index -1, so wurden alle Vorkommnisse von eingabeWort in
          /// aliceWoerter gefunden, und in alleIndexe aufgelistet.
          while(true) {
            int naechsterIndexWortInAlice = aliceWoerter.indexOf(eingabeWort, currentIndex + 1);
            if(naechsterIndexWortInAlice == -1) {
              break;
            }
            alleIndexe.add(naechsterIndexWortInAlice);
            currentIndex = naechsterIndexWortInAlice;
          }
        }else{

          List<int> neueAlleIndexeProWort = [];
          neueAlleIndexeProWort.add(indexWortInAlice);

          /// copy (siehe oben)
          int currentIndex = indexWortInAlice;
          while(true) {
            int naechsterIndexWortInAlice = aliceWoerter.indexOf(eingabeWort, currentIndex + 1);
            if(naechsterIndexWortInAlice == -1) {
              break;
            }
            neueAlleIndexeProWort.add(naechsterIndexWortInAlice);
            currentIndex = naechsterIndexWortInAlice;
          }

          /// nun wird überprüft, welche Indexe aus neueAlleIndexeProWort 1 größer als ein Wert von alleIndexe sind, denn eine Wort folgt schließlich auf das nächste (index+1)
          for (var i = 0; i < alleIndexe.length; i++) {
            if(alleIndexe[i] >= 0){
              bool neuerWert = false;
              for (var j = 0; j < neueAlleIndexeProWort.length; j++) {
                if(neueAlleIndexeProWort[j] == alleIndexe[i] + 1){
                  /// wenn der neue Index 1 größer ist als der alte Index (Beispiel oben, 101 auf 102)
                  /// -> alleIndexe wird bei i, der neue Index zugeschrieben
                  alleIndexe[i] = neueAlleIndexeProWort[j];
                  neuerWert = true;
                  break;
                }
              }
              /// wenn nichts verändert wurde, ist dieser Index falsch und wird mit -1 ersetzt.
              if(!neuerWert){
                alleIndexe[i] = -1;
              }
            }
          } 
        }
      }else{
        /// wenn Indexe bereits in alleIndexe eingetragen wurden, dann wird jedem Index ein Wert von 1
        /// hinzugefügt, entsprechend der einzelnen Lücke.
        if(alleIndexe.isNotEmpty){
          for (var i = 0; i < alleIndexe.length; i++) {
            /// jedem Index in alleIndexe wird die Lücke (als +1) hinzugefügt.
            /// außer wenn der zugeordnete Index zu große für aliceWoerter ist oder der Index mit -1 markiert wurde (also falsch ist)
            if(alleIndexe[i] + 1 >= aliceWoerter.length || alleIndexe[i] == -1){
              continue;
            }
            alleIndexe[i] = alleIndexe[i] + 1;
          }
        }
      }
      print("alleIndexe");
      print(alleIndexe);
    }

    /// nun sollte alleIndexe den Index des letzten Wortes des Lösungssatzes enthaltet und/oder -1.
    /// wenn alleIndexe nur aus -1 besteht, so konnte der Satz nicht vervollständigt werden.
    /// falls mehrere Werte nicht -1 entsprechen, so gibt es mehrere Lösungssätze.
    
    List<int> valideIndexe = [];
    for (var i = 0; i < alleIndexe.length; i++) {
      if(alleIndexe[i] != -1){
        valideIndexe.add(alleIndexe[i]);
      }
    }

    /// Liste für valide Lösungen
    List<String> valideLoesungen = List.filled(valideIndexe.length, "");
    for (var i = woerter.length - 1; i >= 0; i--) {
      if(woerter[i] == "_"){
        for (var j = 0; j < valideIndexe.length; j++) {

          /// String der jeweiligen Lücke in woerter wird bestimmt, indem man rückwärts durch die Liste der Eingabewörter iteriert.
          /// Der Index für die jeweilige Lücke beträgt nun valideIndexe[j] - (woerter.length - i - 1)

          String? lueckeX = aliceWoerter[valideIndexe[j] - (woerter.length - i - 1)];

          /// Es werden gleichzeitig mehrere Lösungen bereitsgestellt, da es mehrere korrekte Endindexe geben kann.
          /// trim() wird gecallt, um die Lösung ins optimale Format ohne überflüssige Leerzeichen zu bringen.
          valideLoesungen[j] = "$lueckeX ${valideLoesungen[j].trim()}";
        }
      }else{
        for (var j = 0; j < valideIndexe.length; j++) {
          /// hier muss die Lücke nicht aus aliceWoerter erschlossen werden, da sich das Wort bereits in der Eingabe befindet.
          valideLoesungen[j] = "${woerter[i]} ${valideLoesungen[j]}";
        }
      }
    }

    /// die Lösungen werden auf Duplikate und leere Stellen überprüft und bereinigt.
    /// toSet() -> ein Set kann keine Duplikate haben -> toList()
    valideLoesungen = valideLoesungen.toSet().toList(growable: true);
    valideLoesungen.removeWhere((element) => element == "");
    
    /// der GUI wird die Lösung übertragen
    setState(() {
      result = valideLoesungen.join(", ");
    });
  }
  List<String> textToWords(String text) {
    /// Diese Methode setzt Eingabe und Originaltext auf das gleiche 'Textformat', sodass beide vergleichbar werden.
    /// aufteilen des Textes in Zeilen
    final lines = text.split("\n");
    /// Liste aller Wörter
    List<String> words = [];
    for (var element in lines) {
      /// der Liste an Wörtern werden die einzelnen Wörter einer Zeile zugeordenet. 
      /// dabei wird mit der RegExp r"[^A-Za-z0-9üäöß_\n]" alles außer den Buchstaben des Alphabets, Zahlen und Unterstrichen (wegen Eingabe) aus dem jeweiligen Wort gelöscht.
      /// Der Satz "»Das kommt mir gar nicht richtig vor,«" wird somit in:
      /// das Array ['das', 'kommt', 'mir', 'gar', 'nicht', 'richtig', 'vor'] zerlegt. 
      words.addAll(element.split(" ").map((e) => e.toLowerCase().replaceAll(RegExp(r"[^a-z0-9üäöß_\n]"), "")).toList());
    }
    return words;
  }
  void logResult(String msg) {
    setState(() {
      result = msg;
    });
  }
}


/// UI-Widget nicht wichtig
/// Stellt einen Button dar.
class EinzelneStoerung extends StatelessWidget {
  final String name;
  final Function onClick;
  const EinzelneStoerung({super.key, required this.name, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: Container(
      height: 30,
      width: 120.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
    onTap: ()=>{
      rootBundle.loadString("assets/aufgabe_1_stoerung/$name").then((value) => onClick(value))
    },
    );
  }
}
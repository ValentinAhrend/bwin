import 'package:bwinf41valentin_ahrend/task1.dart';
import 'package:bwinf41valentin_ahrend/task2.dart';
import 'package:bwinf41valentin_ahrend/task5.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// main Funktion startet die Flutter-Applikation (mit runApp).
void main() {
  runApp(const MyProgramm());
}

class MyProgramm extends StatelessWidget {
  const MyProgramm({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BWINF41 by Valentin Ahrend",
      theme: ThemeData(
        primaryColor: Colors.lime[900],
       // primaryContrastingColor: Colors.lime,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const CentralWidget(),
    );
  }
}

///Zentrales Widget welches das Fenster in Aufgabenleiste und Aufgabendarstellung unterteilt. 
///Die Aufgaben werden über AufgabenAnzeige angezeigt.
class CentralWidget extends StatefulWidget{
  const CentralWidget({super.key});

  @override
  State<CentralWidget> createState() => _CentralWidgetState();
}

class _CentralWidgetState extends State<CentralWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///die akutell selektierte Aufgabe bzw. bei -1 Übersicht
  int currentSelected = -1;

  void setCurrentSelected(int newCurrentSelected) {
    setState(() {
      currentSelected = newCurrentSelected;
    });
  }

  ///Ausgabe: aktueller Aufgabenbildschirm oder Ueberblick
  Widget taskSelector() {
    if(currentSelected == -1){
      ///return: Ueberblick
      return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            
            width: 200,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: Image.asset("assets/other/portrait.png"),
            )
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text("BWINF41 von Valentin Ahrend", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w600),),
          const SizedBox(
            height: 20.0,
          ),
          const SizedBox(
              width: 350.0,
              child: Text("Willkommen! Die Dokumentation zu diesem Programm finden Sie in /dokumentation/EINLEITUNG.md. Das Programm stellt die einzelnen Aufgaben (siehe links) in einem Fenster dar.", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
          )),
          const Spacer(),
          SizedBox(
            height: 50.0,
            child: Center(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 10,),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: const Text("Website", style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                  onTap: ()=>{
                    launchUrlString("https://valentinahrend.com")
                  },
                )
              ),
              const Spacer(flex: 1,),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: const Text("Github", style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                  onTap: ()=>{
                    launchUrlString("https://github.com/ValentinAhrend")
                  },
                )
              ),
              const Spacer(flex: 10,)
            ],
          )))
        ],
      ));
    }
    if(currentSelected == 0) {
      return const Task1Widget();
    }
    if(currentSelected == 1){
      return const Task2Widget();
    }
    if(currentSelected == 4){
      return const Task5Widget();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(body: Row(
      children: [
        Container(
          width: 200.0,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: const Border(right: BorderSide(color: Colors.grey, width: 1.0))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25.0,
              ),
              const SizedBox(
                width: 150.0,
                child: Center(child: Text("BWINF41/1", style: TextStyle(color: Colors.black, fontSize: 24.0),)),
              ),
              const SizedBox(
                height: 50.0,
              ),
              AufgabenAnzeige(name: "Übersicht", id: -1, isSelected: currentSelected == -1, onClick: setCurrentSelected),
              AufgabenAnzeige(name: "1. Aufgabe", id: 0, isSelected: currentSelected == 0, onClick: setCurrentSelected),
              AufgabenAnzeige(name: "2. Aufgabe", id: 1, isSelected: currentSelected == 1, onClick: setCurrentSelected),
              AufgabenAnzeige(name: "5. Aufgabe", id: 4, isSelected: currentSelected == 4, onClick: setCurrentSelected)

            ],
          ),
        ),
        Container(
          width: size.width - 200.0,
          height: size.height,
          color: Colors.white,
          child: taskSelector(),
        )
      ],
    ));
  }
}

class AufgabenAnzeige extends StatelessWidget {
  final String name;
  final int id;
  final bool isSelected;
  final Function onClick;
  const AufgabenAnzeige({super.key, required this.name, required this.id, required this.isSelected, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onClick(id),
      child: Container(
                width: 200.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border(top: id != -1 ? BorderSide.none : const BorderSide(color: Colors.black, width: 1.0), bottom: BorderSide(color: Colors.black, width: 1.0))
                ),
                child: Center(
                  child: SizedBox(
                    width: 180.0,
                    child: Text(name, style: const TextStyle(fontSize: 14.0),),
                  )
                ),
              ));
  }
}
import 'package:flutter/material.dart';
import 'package:osm_bingo/dao/bingo.dart';
import 'package:osm_bingo/map_service.dart';
import 'package:osm_bingo/navigation_service.dart';
import 'package:osm_bingo/quest_popup.dart';

import 'bingo_element.dart';

class BingoCard {
  static List<List<BingoElement>> bingoCard = [
    [
      BingoElement(
        "Het Kasteel",
        "Maak een foto van het Kasteel met je groepje.",
        53.21774270053335,
        6.555017571423083,
      ),
      BingoElement(
        "Forum Groningen",
        "Maak een selfie/foto op het dak van het Forum met je groepje.",
        53.21893636399295,
        6.570391954630532,
      ),
      BingoElement(
        "Martinitoren",
        "Maak een foto van de Martinitoren met de grootste persoon uit je groepje ernaast.",
        53.21938568974004,
        6.568207623222464,
      ),
      BingoElement(
        "Nieuwe Kerk",
        "Maak een foto in de Nieuwe Kerk of voor de hoofdingang met je groepje.",
        53.223280467862814,
        6.561681503979227,
      ),
      BingoElement(
        "Groninger Museum",
        "Maak een foto van het Groninger Museum waarin een of meerdere leden van je groepje een kunstwerk na doen, geef ook aan welk kunstwerk je na doet. Het hoeft niet van dit museum te zijn.",
        53.21228190017462,
        6.566079351512879,
      ),
    ],
    [
      BingoElement(
        "Akerk",
        "Maak een foto in de Akerk of voor de hoofdingang met je groepje.",
        53.216492401093994,
        6.562364669840671,
      ),
      BingoElement(
        "Station Groningen",
        "Maak een foto bij het paarden standbeeld bij het stations gebouw.",
        53.211020494728324,
        6.564063342704337,
      ),
      BingoElement(
        "MartiniPlaza",
        "Maak een foto met je groepje met het Martiniplaza in de achtergrond.",
        53.20303240513857,
        6.555081707361252,
      ),
      BingoElement(
        "Noorderpoort Kunst & Multimedia",
        "Maak een foto van je groepje met het Noorderpoort logo.",
        53.207594630285534,
        6.557172995605856,
      ),
      BingoElement(
        "Kinderboerderij Stadspark",
        "Maak een foto per persoon met hun favoriete dier.",
        53.20606466399597,
        6.547321014823603,
      ),
    ],
    [
      BingoElement(
        "Skatepark De Paardenbak",
        "Maak een foto met je groepje op het skatepark.",
        53.20415683364296,
        6.5478241337411,
      ),
      BingoElement(
        "Groningen Atletiek",
        "Maak een foto op de baan, als de baan dicht is maak een foto van de ingang.",
        53.198871227315074,
        6.539539240983704,
      ),
      BingoElement(
        "Noorderpoort Technologie & ICT",
        "Maak een foto van iemand uit je groepje met hun coach.",
        53.20329518505192,
        6.562301116096836,
      ),
      BingoElement(
        "Pepergasthuis",
        "Maak een foto van je groepje in het Pepergasthuis als het open is, maak anders buiten een foto.",
        53.21742607496547,
        6.57141301267729,
      ),
      BingoElement(
        "Rijksuniversiteit Groningen",
        "Maak een foto van je groepje bij de ingang van het Rijksuniversiteit.",
        53.21920524542988,
        6.563175805756274,
      ),
    ],
    [
      BingoElement(
        "Noorderplantsoen",
        "Maak een foto met je hele groepje bij een van de bankjes in het Noorderplantsoen.",
        53.22421158564376,
        6.555581019774128,
      ),
      BingoElement(
        "McDonald's Westerhaven",
        "Maak een foto van een vuilnisbak met een McDonalds logo erop.",
        53.21619848026004,
        6.557473848143307,
      ),
      BingoElement(
        "McDonald's Herestraat",
        "Maak een foto van het McDonalds bord.",
        53.21652939251069,
        6.567871745345571,
      ),
      BingoElement(
        "McDonald's Sontplein",
        "Maak een foto van de McDonalds van de andere kant van de parkeerplaats.",
        53.216157759482684,
        6.584330600549564,
      ),
      BingoElement(
        "KFC Westerkade",
        "Maak een foto met van iemand in je groepje met Colonel Sanders.",
        53.21524576553252,
        6.557393169762863,
      ),
    ],
    [
      BingoElement(
        "Prinsentuin",
        "Maak een foto met je groepje in de prinsjes tuin.",
        53.2213457069883,
        6.568897712273988,
      ),
      BingoElement(
        "Voormalige Draftbaan Stadspark",
        "Maak een foto van de drafbaan met je groepje.",
        53.20349208509578,
        6.5491170434165795,
      ),
      BingoElement(
        "Domino's Pizza Paterswoldseweg",
        "Maak een foto van het Domino’s bord.",
        53.203118573549695,
        6.559126479689959,
      ),
      BingoElement(
        "'t Pannekoekschip",
        "Maak een foto van ‘t Pannekoekschip met iemand van je groepje.",
        53.21695900180443,
        6.579041728818073,
      ),
      BingoElement(
        "Boteringebrug",
        "Maak een foto van je groepje met het kanaal in de achtergrond.",
        53.22132573050829,
        6.562735226033523,
      ),
    ],
  ];

  static int score = 0;

  static List<BingoElement> get flattenedBingoElements =>
      BingoCard.bingoCard.expand((row) => row).toList();

  static void markAsCompleted(double latitude, double longitude) {
    for (int x = 0; x < bingoCard.length; x++) {
      for (int y = 0; y < bingoCard[x].length; y++) {
        final element = bingoCard[x][y];

        if (element.latitude == latitude && element.longitude == longitude) {
          if (element.locationStatus != LocationStatus.completed) {
            element.locationStatus = LocationStatus.completed;
            score += 1;

            if (_isRowCompleted(x)) score += 5;

            if (_isColumnCompleted(y)) score += 5;

            if (score > 75) score = 75;
            debugPrint('Total Score: $score');

            BingoDao().insertCompleted(x, y);
            MapService().refreshMarkers();
          }
          return;
        }
      }
    }
  }

  static bool _isRowCompleted(int rowIndex) {
    for (int i = 0; i < 5; i++) {
      if (bingoCard[rowIndex][i].locationStatus != LocationStatus.completed) {
        return false;
      }
    }
    return true;
  }

  static bool _isColumnCompleted(int colIndex) {
    for (int i = 0; i < 5; i++) {
      if (bingoCard[i][colIndex].locationStatus != LocationStatus.completed) {
        return false;
      }
    }
    return true;
  }

  static bool hasBingo() {
    List<bool> diagonalOne = [false, false, false, false, false];
    List<bool> diagonalTwo = [false, false, false, false, false];

    for (int x = 0; x < 5; x++) {
      List<bool> xAxis = [false, false, false, false, false];
      List<bool> yAxis = [false, false, false, false, false];

      for (int y = 0; y < 5; y++) {
        xAxis[y] =
            bingoCard[x][y].locationStatus == LocationStatus.completed
                ? true
                : false;
        yAxis[y] =
            bingoCard[y][x].locationStatus == LocationStatus.completed
                ? true
                : false;
      }

      if (!xAxis.contains(false)) return true;
      if (!yAxis.contains(false)) return true;

      diagonalOne[x] =
          bingoCard[x][x].locationStatus == LocationStatus.completed
              ? true
              : false;
      diagonalTwo[x] =
          bingoCard[x][4 - x].locationStatus == LocationStatus.completed
              ? true
              : false;
    }

    if (!diagonalOne.contains(false)) return true;
    if (!diagonalTwo.contains(false)) return true;

    return false;
  }

  static void markAsSeen(double latitude, double longitude) {
    for (int x = 0; x < bingoCard.length; x++) {
      for (int y = 0; y < bingoCard[x].length; y++) {
        final element = bingoCard[x][y];

        if (element.latitude == latitude && element.longitude == longitude) {
          element.locationStatus = LocationStatus.hasBeenInRange;
          MapService().refreshMarkers();

          showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder:
                (context) => PopScope(
                  canPop: false,
                  child: QuestPopup(
                    text: element.taskDescription,
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                      navigationIndexNotifier.value = 2;
                    },
                  ),
                ),
          );

          return;
        }
      }
    }
  }
}

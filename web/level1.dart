library level1;

import 'dart:html';
import 'dart:math';

import 'package:BeerRun/level.dart';
import 'package:BeerRun/drawing.dart';
import 'package:BeerRun/canvas_manager.dart';
import 'package:BeerRun/path.dart';
import 'package:BeerRun/game.dart';
import 'package:BeerRun/car.dart';
import 'package:BeerRun/region.dart';
import 'package:BeerRun/npc.dart';

class Level1 extends Level {

  Random rng = new Random();

  Path roadPath1;
  Path roadPath2;
  Path roadPath3;

  Region npcRegion1;
  Region npcRegion2;
  Region npcRegion3;
  Region npcRegion4;
  Region npcRegion5;
  Region npcRegion6;
  Region npcRegion7;

  final int _spawnCar1At = 200;
  final int _spawnCar2At = 300;
  final int _spawnCar3At = 350;
  int _spawnCar1Cnt = 200;
  int _spawnCar2Cnt = 0;
  int _spawnCar3Cnt = 150;


  List<Sprite> _car1Sprites;
  List<Sprite> _car2Sprites;

  // Overridden from Level
  int get startX => 32 * 20;
  int get startY => 32 * 0;
  int get storeX => 0 * 32;
  int get storeY => 15 * 32;

  int get beersToWin => 24;

  Level1(CanvasManager manager, CanvasDrawer drawer) :
    super(drawer, manager, new Duration(minutes: 3),
        30, 40, 32, 32)
  {

    SpriteSheet road = new SpriteSheet("img/Street.png", 32, 32);
    Map<String, Sprite> roadSprites =
        Level.parseSpriteSheet(road, Level1._roadSpriteSheetData);

    SpriteSheet apt = new SpriteSheet("img/apartments.png", 32, 32);
    Map<String, Sprite> aptSprites =
        Level.parseSpriteSheet(apt, Level1._aptSpriteSheetData);

    SpriteSheet grass = new SpriteSheet("img/LPC Base Assets/tiles/grass.png", 32, 32);
    Map<String, Sprite> grassSprites =
        Level.parseSpriteSheet(grass, Level1._grassSpriteSheetData);

    SpriteSheet sw = new SpriteSheet("img/Sidewalk_dark.png", 32, 32);
    Map<String, Sprite> swSprites =
        Level.parseSpriteSheet(sw, Level1._swSpriteSheetData);

    SpriteSheet fence = new SpriteSheet("img/fence.png", 32, 32);
    Map<String, Sprite> fenceSprites =
        Level.parseSpriteSheet(fence, Level1._fenceSpriteSheetData);

    SpriteSheet house = new SpriteSheet("img/house.png", 32, 32);
    Map<String, Sprite> houseSprites =
        Level.parseSpriteSheet(house, Level1._houseSpriteSheetData);

    SpriteSheet building = new SpriteSheet("img/Building.png", 32, 32);
    Map<String, Sprite> buildingSprites =
        Level.parseSpriteSheet(building, Level1._buildingSpriteSheetData);


    SpriteSheet carSheet = new SpriteSheet('img/Cars_final.png');
    Sprite brokenCarTopLeft = carSheet.spriteAt(384, 0, 32, 32);
    Sprite brokenCarTopRight = carSheet.spriteAt(416, 0, 32, 32);
    Sprite brokenCarMidTopLeft = carSheet.spriteAt(384, 32, 32, 32);
    Sprite brokenCarMidTopRight = carSheet.spriteAt(416, 32, 32, 32);
    Sprite brokenCarMidBotLeft = carSheet.spriteAt(384, 64, 32, 32);
    Sprite brokenCarMidBotRight = carSheet.spriteAt(416, 64, 32, 32);
    Sprite brokenCarBotLeft = carSheet.spriteAt(384, 96, 32, 32);
    Sprite brokenCarBotRight = carSheet.spriteAt(416, 96, 32, 32);
    Sprite tire = carSheet.spriteAt(384, 128, 32, 32);


    // Grass layer0
    this.newLayer();

    Random rand = new Random();
    for (int r = 0; r < this.rows; r++) {
      for (int c = 0; c < this.cols; c++) {

        int num = rand.nextInt(3) + 1;
        this.setSpriteAt(grassSprites["grassBG${num}"], r, c);
      }
    }

    // Sidewalk and street Layer
    this.newLayer();

    this.setSpriteAt(swSprites["swHorzMid"], 3, 0);
    this.setSpriteAt(swSprites["swHorzMidTopMidConnector"], 3, 1);
    this.setSpriteAt(swSprites["swHorzMidTopLeftConnector"], 3, 2);
    this.setSpriteAt(swSprites["swHorzMidTopRightConnector"], 3, 3);
    this.setSpriteAt(swSprites["swHorzMid"], 3, 4);
    this.setSpriteAt(swSprites["swHorzMidTopMidConnector"], 3, 5);
    this.setSpriteAt(swSprites["swHorzMidTopLeftConnector"], 3, 6);
    this.setSpriteAt(swSprites["swHorzMidTopRightConnector"], 3, 7);
    this.setSpriteAt(swSprites["swHorzMid"], 3, 8);
    this.setSpriteAt(swSprites["swHorzMidTopMidConnector"], 3, 9);
    this.setSpriteAt(swSprites["swHorzMidTopLeftConnector"], 3, 10);
    this.setSpriteAt(swSprites["swHorzMidTopRightConnector"], 3, 11);

    this.setSpriteAt(swSprites["swHorzTop"], 8, 0);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 1);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 2);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 3);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 4);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 5);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 6);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 7);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 8);
    this.setSpriteAt(swSprites["swHorzTop"], 8, 9);
    //this.setSpriteAt(swSprites["swVertRight"], 7, 11);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 0);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 1);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 2);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 3);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 4);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 5);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 6);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 7);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 8);
    this.setSpriteAt(swSprites["swBrkDownLeft"], 9, 9);
    this.setSpriteAt(swSprites["swVertRight"], 9, 10);
    for (int r = 10; r < 30; r++) {
      this.setSpriteAt(swSprites["swBrkVertLeft"], r, 9);
      this.setSpriteAt(swSprites["swVertRight"], r, 10);
    }
    /**
     * This is the parking lot.  Three hobos hang out here to steal your beer.
     */
    for (int r = 10; r < 30; r++) {
      for (int c = 0; c < 9; c++) {

        int rand = this.rng.nextInt(22);
        if (rand == 0) {
          this.setSpriteAt(swSprites["brkTopLeft"], r, c);
        } else if (rand == 1) {
          this.setSpriteAt(swSprites["brkTopRight"], r, c);
        } else if (rand == 2) {
          this.setSpriteAt(swSprites["brkBottomLeft"], r, c);
        } else if (rand == 3) {
          this.setSpriteAt(swSprites["brkBottomRight"], r, c);
        } else {
          this.setSpriteAt(swSprites["brk"], r, c);
        }
      }
    }

    // Parking lot region
    this.npcRegion1 = new Region(
      0,
      10 * this.tileWidth,
      10 * this.tileHeight,
      30 * this.tileHeight
    );
    this.npcRegion2 = new Region(
      17 * this.tileWidth,
      20 * this.tileWidth,
      0,
      30 * this.tileHeight
    );
    this.npcRegion3 = new Region(
        33 * this.tileWidth,
        38 * this.tileWidth,
        14 * this.tileHeight,
        30 * this.tileHeight
    );
    this.npcRegion4 = new Region(
      33 * this.tileWidth,
      40 * this.tileWidth,
      10 * this.tileHeight,
      12 * this.tileHeight
    );

    /**
     * END Parking Lot
     */

    for (int c = 0; c < 11; c++) {
      this.setSpriteAt(roadSprites["roadOuterTop"], 4, c);
      this.setSpriteAt(roadSprites["lineHorizontal"], 5, c);
      this.setSpriteAt(roadSprites["roadOuterBottom"], 6, c);
    }

    this.setSpriteAt(roadSprites["lineCurveDownLeft"], 5, 11);
    this.setSpriteAt(roadSprites["lineCurveDownLeft"], 6, 12);

    for (int r = 7; r < 30; r++) {
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 11);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 12);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 13);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 14);
    }

    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 21);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 22);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 23);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 24);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 26);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 27);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 28);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 29);
    }

    for (int r = 4; r < 30; r++) {
      this.setSpriteAt(swSprites["swVertMid"], r, 15);

    }

    for (int r = 18; r < 30; r++) {
      this.setSpriteAt(swSprites["swVertMid"], r, 31);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 32);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 33);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 34);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 35);
    }

    this.setSpriteAt(swSprites["swVertMid"], 17, 31);
    this.setSpriteAt(swSprites["swVertMid"], 16, 31);
    this.setSpriteAt(swSprites["swVertMid"], 15, 31);
    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 14, 31);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 32);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 33);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 34);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 35);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 36);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 37);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 38);
    this.setSpriteAt(swSprites["swHorzMid"], 14, 39);

    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 29, 36);
    this.setSpriteAt(swSprites["swVertMid"], 28, 36);
    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 27, 36);
    this.setSpriteAt(swSprites["swVertMid"], 26, 36);
    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 25, 36);
    this.setSpriteAt(swSprites["swVertMid"], 24, 36);
    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 23, 36);
    this.setSpriteAt(swSprites["swVertMid"], 22, 36);
    this.setSpriteAt(swSprites["swVertMid"], 21, 36);
    this.setSpriteAt(swSprites["swVertMid"], 20, 36);
    this.setSpriteAt(swSprites["swVertMid"], 19, 36);
    this.setSpriteAt(swSprites["swVertMidRightMidConnector"], 18, 36);
    this.setSpriteAt(swSprites["swHorzMid"], 18, 37);
    this.setSpriteAt(swSprites["swHorzMid"], 18, 38);
    this.setSpriteAt(swSprites["swHorzMid"], 18, 39);



    for (int c = 36; c < 40; c++) {
      this.setSpriteAt(roadSprites["roadOuterTop"], 15, c);
      this.setSpriteAt(roadSprites["lineHorizontal"], 16, c);
      this.setSpriteAt(roadSprites["roadOuterBottom"], 17, c);
    }

    // Apartment/fence layer
    //this.newLayer();

    for (int c = 0; c < 6; c++) {
      this.setSpriteAt(fenceSprites["wireHorizMid"], 7, c, true);
    }
    //this.setSpriteAt(fenceSprites["wireHorizRight"], 7, 5);
    //this.setSpriteAt(fenceSprites["wireHorizLeft"], 7, 8);
    for (int c = 8; c < 10; c++) {
      this.setSpriteAt(fenceSprites["wireHorizMid"], 7, c, true);
    }
    this.setSpriteAt(fenceSprites["wireHorizRight"], 7, 10, true);

    for (int r = 8; r < 30; r++) {
      this.setSpriteAt(fenceSprites["wireVertMid"], r, 10, true);
    }

    for (int r = 0; r < 25; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 16, true);
    }
    for (int r = 27; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 16, true);
    }

    for (int r = 0; r < 12; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 20, true);
    }
    for (int r = 14; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 20, true);
    }
    for (int r = 0; r < 4; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 25, true);
    }
    for (int r = 6; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 25, true);
    }
    for (int r = 7; r < 27; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 30, true);
    }
    for (int r = 29; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 30, true);
    }

    for (int c = 31; c < 34; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 9, c, true);
    }
    this.setSpriteAt(fenceSprites["woodHorizRight"], 9, 34, true);
    this.setSpriteAt(fenceSprites["woodHorizLeft"], 9, 37, true);
    for (int c = 38; c < 40; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 9, c, true);
    }
    for (int c = 31; c < 36; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 13, c, true);
    }
    this.setSpriteAt(fenceSprites["woodHorizRight"], 13, 36, true);
    this.setSpriteAt(fenceSprites["woodHorizLeft"], 13, 39, true);

    this.setSpriteAt(aptSprites["apt1TopLeft"], 0, 0, true);
    this.setSpriteAt(aptSprites["apt1TopRight"], 0, 1, true);
    this.setSpriteAt(aptSprites["apt2TopLeft"], 0, 2, true);
    this.setSpriteAt(aptSprites["apt2TopRight"], 0, 3, true);
    this.setSpriteAt(aptSprites["apt3TopLeft"], 0, 4, true);
    this.setSpriteAt(aptSprites["apt3TopRight"], 0, 5, true);
    this.setSpriteAt(aptSprites["apt4TopLeft"], 0, 6, true);
    this.setSpriteAt(aptSprites["apt4TopRight"], 0, 7, true);
    this.setSpriteAt(aptSprites["apt5TopLeft"], 0, 8, true);
    this.setSpriteAt(aptSprites["apt5TopRight"], 0, 9, true);
    this.setSpriteAt(aptSprites["apt6TopLeft"], 0, 10, true);
    this.setSpriteAt(aptSprites["apt6TopRight"], 0, 11, true);
    this.setSpriteAt(aptSprites["apt1MidLeft"], 1, 0, true);
    this.setSpriteAt(aptSprites["apt1MidRight"], 1, 1, true);
    this.setSpriteAt(aptSprites["apt2MidLeft"], 1, 2, true);
    this.setSpriteAt(aptSprites["apt2MidRight"], 1, 3, true);
    this.setSpriteAt(aptSprites["apt3MidLeft"], 1, 4, true);
    this.setSpriteAt(aptSprites["apt3MidRight"], 1, 5, true);
    this.setSpriteAt(aptSprites["apt4MidLeft"], 1, 6, true);
    this.setSpriteAt(aptSprites["apt4MidRight"], 1, 7, true);
    this.setSpriteAt(aptSprites["apt5MidLeft"], 1, 8, true);
    this.setSpriteAt(aptSprites["apt5MidRight"], 1, 9, true);
    this.setSpriteAt(aptSprites["apt6MidLeft"], 1, 10, true);
    this.setSpriteAt(aptSprites["apt6MidRight"], 1, 11, true);
    this.setSpriteAt(aptSprites["apt1BotLeft"], 2, 0, true);
    this.setSpriteAt(aptSprites["apt1BotRight"], 2, 1, true);
    this.setSpriteAt(aptSprites["apt2BotLeft"], 2, 2, true);
    this.setSpriteAt(aptSprites["apt2BotRight"], 2, 3, true);
    this.setSpriteAt(aptSprites["apt3BotLeft"], 2, 4, true);
    this.setSpriteAt(aptSprites["apt3BotRight"], 2, 5, true);
    this.setSpriteAt(aptSprites["apt4BotLeft"], 2, 6, true);
    this.setSpriteAt(aptSprites["apt4BotRight"], 2, 7, true);
    this.setSpriteAt(aptSprites["apt5BotLeft"], 2, 8, true);
    this.setSpriteAt(aptSprites["apt5BotRight"], 2, 9, true);
    this.setSpriteAt(aptSprites["apt6BotLeft"], 2, 10, true);
    this.setSpriteAt(aptSprites["apt6BotRight"], 2, 11, true);

    this.setSpriteAt(aptSprites["treeTopLeft"], 0, 13, true);
    this.setSpriteAt(aptSprites["treeTopMid"], 0, 14, true);
    this.setSpriteAt(aptSprites["treeTopRight"], 0, 15, true);
    this.setSpriteAt(aptSprites["treeMidLeft"], 1, 13, true);
    this.setSpriteAt(aptSprites["treeMidMid"], 1, 14, true);
    this.setSpriteAt(aptSprites["treeMidRight"], 1, 15, true);
    this.setSpriteAt(aptSprites["treeBotLeft"], 2, 13, true);
    this.setSpriteAt(aptSprites["treeBotMid"], 2, 14, true);
    this.setSpriteAt(aptSprites["treeBotRight"], 2, 15, true);
    this.setSpriteAt(aptSprites["treeShadowLeft"], 3, 13, true);
    this.setSpriteAt(aptSprites["treeShadowMid"], 3, 14, true);
    this.setSpriteAt(aptSprites["treeShadowRight"], 3, 15, true);

    // THE HOUSE
    this.setSpriteAt(houseSprites["wallTopLeft"], 2, 30, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 31, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 32, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 33, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 34, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 38, true);
    this.setSpriteAt(houseSprites["wallTopRight"], 2, 39, true);
    this.setSpriteAt(houseSprites["wallMidLeft"], 3, 30, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 31, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 32, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 33, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 34, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 38, true);
    this.setSpriteAt(houseSprites["wallMidRight"], 3, 39, true);
    this.setSpriteAt(houseSprites["wallBotLeft"], 4, 30, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 31, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 32, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 33, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 34, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 38, true);
    this.setSpriteAt(houseSprites["wallBotRight"], 4, 39, true);

    this.setSpriteAt(houseSprites["roofSideAngleLeft"], 0, 30, true);
    this.setSpriteAt(houseSprites["roofFlatBotLeft"], 0, 31, true);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 32, true);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 33, true);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 34, true);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 35, true);
    this.setSpriteAt(houseSprites["roofFlatMidMid"], 0, 36, true);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 37, true);
    this.setSpriteAt(houseSprites["roofFlatBotRight"], 0, 38, true);
    this.setSpriteAt(houseSprites["roofSideAngleRight"], 0, 39, true);
    this.setSpriteAt(houseSprites["roofFrontAngleLeft"], 2, 35, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 2, 36, true);
    this.setSpriteAt(houseSprites["roofFrontAngleRight"], 2, 37, true);
    this.setSpriteAt(houseSprites["roofFrontAngleInvLeft"], 1, 35, true);
    this.setSpriteAt(houseSprites["roofFlatOpenTop"], 1, 36, true);
    this.setSpriteAt(houseSprites["roofFrontAngleInvRight"], 1, 37, true);
    this.setSpriteAt(houseSprites["roofFrontAngleLeft"], 1, 30, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 31, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 32, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 33, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 34, true);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 38, true);
    this.setSpriteAt(houseSprites["roofFrontAngleRight"], 1, 39, true);

    this.setSpriteAt(houseSprites["wallMidMid"], 3, 35, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 37, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 35, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 37, true);

    // Lower right apartments
    this.setSpriteAt(aptSprites["aptSideBotLeft"], 29, 38, true);
    this.setSpriteAt(aptSprites["aptSideBotRight"], 29, 39, true);
    this.setSpriteAt(aptSprites["aptSideMidLeft"], 28, 38, true);
    this.setSpriteAt(aptSprites["aptSideMidRight"], 28, 39, true);
    this.setSpriteAt(aptSprites["aptSideTopLeft"], 27, 38, true);
    this.setSpriteAt(aptSprites["aptSideTopRight"], 27, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotLeft"], 26, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotRight"], 26, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopLeft"], 25, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopRight"], 25, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotLeft"], 24, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotRight"], 24, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopLeft"], 23, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopRight"], 23, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotLeft"], 22, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotRight"], 22, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopLeft"], 21, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopRight"], 21, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotLeft"], 20, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofBotRight"], 20, 39, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopLeft"], 19, 38, true);
    this.setSpriteAt(aptSprites["aptSideRoofTopRight"], 19, 39, true);
    this.setSpriteAt(aptSprites["aptSideStairsTop"], 28, 37, false);
    this.setSpriteAt(aptSprites["aptSideStairsBot"], 29, 37, true);
    this.setSpriteAt(aptSprites["aptSideStairsTop"], 26, 37, false);
    this.setSpriteAt(aptSprites["aptSideStairsBot"], 27, 37, true);
    this.setSpriteAt(aptSprites["aptSideStairsTop"], 24, 37, false);
    this.setSpriteAt(aptSprites["aptSideStairsBot"], 25, 37, true);
    this.setSpriteAt(aptSprites["aptSideStairsTop"], 22, 37, false);
    this.setSpriteAt(aptSprites["aptSideStairsBot"], 23, 37, true);

    this.newLayer();
    this.setSpriteAt(houseSprites["wallTopLeft"], 3, 35, true);
    this.setSpriteAt(houseSprites["wallTopMid"], 3, 36, true);
    this.setSpriteAt(houseSprites["wallTopRight"], 3, 37, true);
    this.setSpriteAt(houseSprites["wallMidLeft"], 4, 35, true);
    this.setSpriteAt(houseSprites["wallMidMid"], 4, 36, true);
    this.setSpriteAt(houseSprites["wallMidRight"], 4, 37, true);
    this.setSpriteAt(houseSprites["wallBotLeft"], 5, 35, true);
    this.setSpriteAt(houseSprites["wallBotMid"], 5, 36, true);
    this.setSpriteAt(houseSprites["wallBotRight"], 5, 37, true);



    this.newLayer();
    this.setSpriteAt(houseSprites["door2Top"], 4, 36, false);
    this.setSpriteAt(houseSprites["door2Bot"], 5, 36, false);
    this.setSpriteAt(houseSprites["window2Top"], 2, 34, true);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 34, true);
    this.setSpriteAt(houseSprites["window2Top"], 2, 32, true);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 32, true);
    this.setSpriteAt(houseSprites["window2Top"], 2, 38, true);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 38, true);
    this.newLayer();
    this.setSpriteAt(houseSprites["stairsTop"], 5, 36);
    this.setSpriteAt(houseSprites["stairsBot"], 6, 36);



    // CAR
    this.setSpriteAt(brokenCarTopLeft, 4, 30, true);
    this.setSpriteAt(brokenCarTopRight, 4, 31, true);
    this.setSpriteAt(brokenCarMidTopLeft, 5, 30, true);
    this.setSpriteAt(brokenCarMidTopRight, 5, 31, true);
    this.setSpriteAt(brokenCarMidBotLeft, 6, 30, true);
    this.setSpriteAt(brokenCarMidBotRight, 6, 31, true);
    this.setSpriteAt(brokenCarBotLeft, 7, 30, true);
    this.setSpriteAt(brokenCarBotRight, 7, 31, true);
    this.setSpriteAt(tire, 5, 32, false);

    // BEER STORE

    this.setSpriteAt(buildingSprites["storeWallMidLeft"], 27, 0, true);
    this.setSpriteAt(buildingSprites["storeWallMidMid"], 27, 1, true);
    this.setSpriteAt(buildingSprites["storeWallMidMid"], 27, 2, true);
    this.setSpriteAt(buildingSprites["doorBotLeft"], 27, 3, false);
    this.setSpriteAt(buildingSprites["doorBotRight"], 27, 4, false);
    this.setSpriteAt(buildingSprites["storeWallMidRight"], 27, 5, true);
    this.setSpriteAt(buildingSprites["storeWallMidLeft"], 26, 0, true);
    this.setSpriteAt(buildingSprites["beerSignLeft"], 26, 1, true);
    this.setSpriteAt(buildingSprites["beerSignRight"], 26, 2, true);
    this.setSpriteAt(buildingSprites["doorTopLeft"], 26, 3, true);
    this.setSpriteAt(buildingSprites["doorTopRight"], 26, 4, true);
    this.setSpriteAt(buildingSprites["storeWallMidRight"], 26, 5, true);
    this.setSpriteAt(buildingSprites["storeWallTopLeft"], 25, 0, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 25, 1, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 25, 2, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 25, 3, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 25, 4, true);
    this.setSpriteAt(buildingSprites["storeWallTopRight"], 25, 5, true);
    this.setSpriteAt(buildingSprites["storeRoofLeft"], 24, 0, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 24, 1, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 24, 2, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 24, 3, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 24, 4, true);
    this.setSpriteAt(buildingSprites["storeRoofRight"], 24, 5, true);
    this.setSpriteAt(buildingSprites["storeRoofBackLeft"], 23, 0, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 23, 1, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 23, 2, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 23, 3, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 23, 4, true);
    this.setSpriteAt(buildingSprites["storeRoofBackRight"], 23, 5, true);


    this.roadPath1 = new Path([
                              new GamePoint(this.tileWidth * 13,// - this.tileWidth ~/ 2,
                                  this.rows * this.tileHeight),
                              new GamePoint(this.tileWidth * 13,// - this.tileWidth ~/ 2,
                                  5 * 32 - 48),
                              new GamePoint(-160, 5 * 32 - 48)
                              ]);
    this.roadPath2 = new Path([
                                new GamePoint(27 * this.tileWidth + 16,
                                   this.rows * this.tileHeight),
                                new GamePoint(27 * this.tileWidth + 16, -160)
                               ]);
    this.roadPath3 = new Path([

                               new GamePoint(22 * this.tileWidth, -160),
                               new GamePoint(22 * this.tileWidth,
                                   this.rows * this.tileHeight)
                               ]);

    this._car1Sprites = [
                         carSheet.spriteAt(96, 96, 96, 160),
                         carSheet.spriteAt(0, 96, 96, 160),
                         carSheet.spriteAt(0, 0, 192, 96),
                         carSheet.spriteAt(160, 0, 192, 96)
                         ];
    this._car2Sprites = [
                         carSheet.spriteAt(198, 96, 96, 160),
                         carSheet.spriteAt(288, 96, 96, 160),
                         carSheet.spriteAt(0, 256, 192, 96),
                         carSheet.spriteAt(160, 256, 192, 96)
                         ];


    // Add level triggers

    GameEvent beerStoreEvent = new GameEvent();
    beerStoreEvent.type = GameEvent.BEER_STORE_EVENT;
    beerStoreEvent.value = 24;
    Trigger beerStoreTrigger = new Trigger(beerStoreEvent, 27, 3);
    Trigger beerStoreTrigger2 = new Trigger(beerStoreEvent, 27, 4);

    GameEvent partyEvent = new GameEvent();
    partyEvent.type = GameEvent.PARTY_ARRIVAL_EVENT;
    Trigger partyTrigger = new Trigger(partyEvent, 6, 36);

    this.addTrigger(beerStoreTrigger);
    this.addTrigger(beerStoreTrigger2);
    this.addTrigger(partyTrigger);


    // ADD OBJECTS
    NPC npc1 = new NPC(this, DIR_RIGHT, 0, 400);
    NPC npc2 = new NPC(this, DIR_DOWN, 20, 320);
    NPC npc3 = new NPC(this, DIR_LEFT, 160, 420);
    NPC npc4 = new NPC(this, DIR_UP, 17 * this.tileWidth, 20);
    NPC npc5 = new NPC(this, DIR_DOWN, 17 * this.tileWidth, 28 * this.tileHeight);
    NPC npc6 = new NPC(this, DIR_UP, 36 * this.tileWidth, 25 * this.tileHeight);
    NPC npc7 = new NPC(this, DIR_RIGHT, 33 * this.tileWidth, 11 * this.tileHeight);
    npc1.speed = 2;
    npc2.speed = 2;
    npc3.speed = 3;
    npc4.speed = 2;
    npc5.speed = 2;
    npc6.speed = 1;
    npc7.speed = 1;
    npc1.setControlComponent(new NPCInputComponent(this.npcRegion1));
    npc2.setControlComponent(new NPCInputComponent(this.npcRegion1));
    npc3.setControlComponent(new NPCInputComponent(this.npcRegion1));
    npc4.setControlComponent(new NPCInputComponent(this.npcRegion2));
    npc5.setControlComponent(new NPCInputComponent(this.npcRegion2));
    npc6.setControlComponent(new NPCInputComponent(this.npcRegion3));
    npc7.setControlComponent(new NPCInputComponent(this.npcRegion4));
    npc1.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc2.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc3.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc4.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc5.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc6.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));
    npc7.setDrawingComponent(
        new DrawingComponent(
            this.canvasManager, this.canvasDrawer, false));

    this.addObject(npc1);
    this.addObject(npc2);
    this.addObject(npc3);
    this.addObject(npc4);
    this.addObject(npc5);
    this.addObject(npc6);
    this.addObject(npc7);
  }



  void update() {
    this._spawnCar1Cnt++;
    this._spawnCar2Cnt++;
    this._spawnCar3Cnt++;
    if (this._spawnCar1Cnt >= this._spawnCar1At) {
      int blah = this.rng.nextInt(2);
      Car c = new Car(this.roadPath1, DIR_UP,
          (blah == 0 ? this._car1Sprites : this._car2Sprites));
      c.setLevel(this);
      c.setDrawingComponent(
          new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
      this.addObject(c);
      // Sorta randomize the interval that we spawn cars
      this._spawnCar1Cnt = this.rng.nextInt(this._spawnCar1At ~/ 2);
    }
    if (this._spawnCar2Cnt >= this._spawnCar2At){
      int blah = this.rng.nextInt(2);
      Car c = new Car(this.roadPath2, DIR_UP,
          (blah == 0 ? this._car1Sprites : this._car2Sprites));
      c.setLevel(this);
      c.setDrawingComponent(
          new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
      this.addObject(c);
      this._spawnCar2Cnt = 0;
    }
    if (this._spawnCar3Cnt >= this._spawnCar3At){
      int blah = this.rng.nextInt(2);
      Car c = new Car(this.roadPath3, DIR_DOWN,
          (blah == 0 ? this._car1Sprites : this._car2Sprites));
      c.setLevel(this);
      c.setDrawingComponent(
          new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
      this.addObject(c);
      this._spawnCar3Cnt = 0;
    }

    super.update();
  }

  static final Map _houseSpriteSheetData = {
    "wallTopLeft": [0, 0],
    "wallMidLeft": [0, 32],
    "wallBotLeft": [0, 64],
    "wallTopMid": [32, 0],
    "wallMidMid": [32, 32],
    "wallBotMid": [32, 64],
    "wallTopRight": [64, 0],
    "wallMidRight": [64, 32],
    "wallBotRight": [64, 64],
    "door1Top": [96, 0],
    "door1Bot": [96, 32],
    "stairsTop": [128, 0],
    "stairsBot": [128, 32],
    "door2Top": [160, 0],
    "door2Bot": [160, 32],
    "window2Top": [256, 0],
    "window2Bot": [256, 32],

    "frontTopLeft": [224, 64],
    "frontMidLeft": [224, 96],
    "frontBotLeft": [224, 128],
    "frontTopRight": [256, 64],
    "frontMidRight": [256, 96],
    "frontBotRight": [256, 128],

    "roofSideAngleLeft": [0, 128],
    "roofSideAngleRight": [64, 128],
    "roofFrontAngleLeft": [0, 160],
    "roofFrontAngleMid": [32, 160],
    "roofFrontAngleRight": [64, 160],
    "roofFrontAngleInvLeft": [0, 192],
    "roofFrontAngleInvRight": [64, 192],

    "roofFlatTopLeft": [96, 128],
    "roofFlatTopMid": [128, 128],
    "roofFlatTopRight": [160, 128],
    "roofFlatMidLeft": [96, 192],
    "roofFlatMidMid": [128, 192],
    "roofFlatMidRight": [160, 192],
    "roofFlatBotLeft": [96, 160],
    "roofFlatBotMid": [128, 160],
    "roofFlatBotRight": [160, 160],
    "roofFlatOpenTop": [192, 160],
  };

  static final Map _grassSpriteSheetData = {
    "grassBG1": [0, 160],
    "grassBG2": [32, 160],
    "grassBG3": [64, 160],
  };

  static final Map _swSpriteSheetData = {
    "swHorzMid": [0, 128],
    "swHorzMidTopMidConnector": [0, 160],
    "swHorzMidTopLeftConnector": [0, 192],
    "swHorzMidTopRightConnector": [32, 192],

    "swHorzTop": [32, 128],

    "swVertMid": [0, 96],
    "swVertRight": [32, 96],
    "swVertLeft": [64, 96],
    "swVertMidRightMidConnector": [96, 128],
    "swVertMidLeftMidConnector": [96, 160],

    "swBrkDownRight": [0, 0],
    "swBrkHorzBot": [32, 0],
    "swBrkDownLeft": [64, 0],
    "swBrkVertRight": [0, 32],
    "brk": [32, 32],
    "swBrkVertLeft": [64, 32],
    "swBrkTopRight": [0, 64],
    "swBrkHorzTop": [32, 64],
    "swBrkTopLeft": [64, 64],

    "brkTopLeft": [96, 0],
    "brkTopRight": [96, 32],
    "brkBottomRight": [96, 64],
    "brkBottomLeft": [96, 96],
  };

  static final Map _aptSpriteSheetData = {

    "apt1TopLeft": [0, 0],
    "apt1TopRight": [32, 0],
    "apt1MidLeft": [0, 32],
    "apt1MidRight": [32, 32],
    "apt1BotLeft": [0, 64],
    "apt1BotRight": [32, 64],

    "apt2TopLeft": [64, 0],
    "apt2TopRight": [96, 0],
    "apt2MidLeft": [64, 32],
    "apt2MidRight": [96, 32],
    "apt2BotLeft": [64, 64],
    "apt2BotRight": [96, 64],

    "apt3TopLeft": [128, 0],
    "apt3TopRight": [160, 0],
    "apt3MidLeft": [128, 32],
    "apt3MidRight": [160, 32],
    "apt3BotLeft": [128, 64],
    "apt3BotRight": [160, 64],

    "apt4TopLeft": [192, 0],
    "apt4TopRight": [224, 0],
    "apt4MidLeft": [192, 32],
    "apt4MidRight": [224, 32],
    "apt4BotLeft": [192, 64],
    "apt4BotRight": [224, 64],

    "apt5TopLeft": [256, 0],
    "apt5TopRight": [288, 0],
    "apt5MidLeft": [256, 32],
    "apt5MidRight": [288, 32],
    "apt5BotLeft": [256, 64],
    "apt5BotRight": [288, 64],

    "apt6TopLeft": [320, 0],
    "apt6TopRight": [352, 0],
    "apt6MidLeft": [320, 32],
    "apt6MidRight": [352, 32],
    "apt6BotLeft": [320, 64],
    "apt6BotRight": [352, 64],

    "treeTopLeft": [384, 0],
    "treeTopMid": [416, 0],
    "treeTopRight": [448, 0],
    "treeMidLeft": [384, 32],
    "treeMidMid": [416, 32],
    "treeMidRight": [448, 32],
    "treeBotLeft": [384, 64],
    "treeBotMid": [416, 64],
    "treeBotRight": [448, 64],
    "treeShadowLeft": [384, 96],
    "treeShadowMid": [416, 96],
    "treeShadowRight": [448, 96],

    "aptSideBotLeft": [32, 256],
    "aptSideBotRight": [64, 256],
    "aptSideMidLeft": [32, 224],
    "aptSideMidRight": [64, 224],
    "aptSideTopLeft": [32, 192],
    "aptSideTopRight": [64, 192],
    "aptSideRoofBotLeft": [32, 160],
    "aptSideRoofBotRight": [64, 160],
    "aptSideRoofTopLeft": [32, 128],
    "aptSideRoofTopRight": [64, 128],
    "aptSideStairsTop": [0, 224],
    "aptSideStairsBot": [0, 256],
  };

  static final Map _roadSpriteSheetData = {

    "road": [32, 32],
    "brokenRoad1": [0, 128],
    "brokenRoad2": [32, 128],
    "brokenRoad3": [64, 128],
    "roadOuterTopLeft": [0, 0],
    "roadOuterTop": [32, 0],
    "roadOuterTopRight": [64, 0],
    "roadOuterLeft": [0, 32],
    "roadOuterRight": [64, 32],
    "roadOuterBottomLeft": [0, 64],
    "roadOuterBottom": [32, 64],
    "roadOuterBottomRight": [64, 64],
    "roadInnerBottomRight": [0, 160],
    "roadInnerBottom": [32, 156],
    "roadInnerBottomLeft": [64, 160],
    "roadInnerRight": [0, 192],
    "roadInnerLeft": [64, 192],
    "roadInnerTopRight": [0, 224],
    "roadInnerTop": [32, 224],
    "roadInnerTopLeft": [64, 224],
    "lineVertical": [96, 0],
    "lineHorizontal": [96, 32],
    "lineCross": [96, 64],
    "lineHorizontalTop": [0, 128],
    "lineHorizontalBottom": [32, 128],
    "lineVerticalRight": [64, 128],
    "lineVerticalLeft": [96, 128],
    "lineCurveDownRight": [262, 132],
    "lineCurveUpRight": [262, 348],
    "lineCurveDownLeft": [474, 132],
    "lineCurveUpLeft": [474, 348],
    "lineDottedHorizTop": [160, 32],
    "lineDottedHorizBot": [128, 32],
    "lineDottedVertLeft": [128, 0],
    "lineDottedVertRight": [160, 0]

  };

  static final _fenceSpriteSheetData = {
    "wireHorizLeft": [0, 0],
    "wireHorizMid": [32, 0],
    "wireHorizRight": [64, 0],
    "wireVertMid": [0, 32],
    "woodHorizLeft": [32, 32],
    "woodHorizRight": [64, 32],
    "woodDownRight": [0, 64],
    "woodDownLeft": [64, 64],
    "woodHorizMid": [32, 64],
    "woodVertMid": [0, 96],
    "woodVertBot": [32, 96],
  };

  static final _buildingSpriteSheetData = {
    "storeWallMidMid": [224, 224],
    "beerSignLeft": [0, 224],
    "beerSignRight": [32, 224],
    "storeWallMidLeft": [160, 192],
    "storeWallMidRight": [224, 192],
    "storeWallTopLeft": [160, 160],
    "storeWallTopMid": [192, 160],
    "storeWallTopRight": [224, 160],
    "storeRoofLeft": [160, 128],
    "storeRoofMid": [192, 128],
    "storeRoofRight": [224, 128],
    "storeRoofBackLeft": [160, 96],
    "storeRoofBackMid": [192, 96],
    "storeRoofBackRight": [224, 96],
    "doorBotLeft": [64, 224],
    "doorBotMid": [96, 224],
    "doorBotRight": [128, 224],
    "doorTopLeft": [64, 192],
    "doorTopMid": [96, 192],
    "doorTopRight": [128, 192],
  };
}

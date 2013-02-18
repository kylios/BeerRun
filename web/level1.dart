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

class Level1 extends Level {

  Random rng = new Random();

  Path roadPath1;
  Path roadPath2;
  Path roadPath3;

  Region npcRegion1;
  Region npcRegion2;
  Region npcRegion3;
  Region npcRegion4;

  final int _spawnCar1At = 200;
  final int _spawnCar2At = 300;
  final int _spawnCar3At = 350;
  int _spawnCar1Cnt = 200;
  int _spawnCar2Cnt = 0;
  int _spawnCar3Cnt = 150;


  List<Sprite> _car1Sprites;
  List<Sprite> _car2Sprites;

  Level1(CanvasManager manager, CanvasDrawer drawer) :
    super(drawer, manager, 30, 40, 32, 32)
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
    this.setSpriteAt(swSprites["swHorzTop"], 8, 10);
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
    this.setSpriteAt(swSprites["swBrkHorzBot"], 9, 9);
    this.setSpriteAt(swSprites["swBrkDownLeft"], 9, 10);
    this.setSpriteAt(swSprites["swVertRight"], 9, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 10, 10);
    this.setSpriteAt(swSprites["swVertRight"], 10, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 11, 10);
    this.setSpriteAt(swSprites["swVertRight"], 11, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 12, 10);
    this.setSpriteAt(swSprites["swVertRight"], 12, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 13, 10);
    this.setSpriteAt(swSprites["swVertRight"], 13, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 14, 10);
    this.setSpriteAt(swSprites["swVertRight"], 14, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 15, 10);
    this.setSpriteAt(swSprites["swVertRight"], 15, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 16, 10);
    this.setSpriteAt(swSprites["swVertRight"], 16, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 17, 10);
    this.setSpriteAt(swSprites["swVertRight"], 17, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 18, 10);
    this.setSpriteAt(swSprites["swVertRight"], 18, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 19, 10);
    this.setSpriteAt(swSprites["swVertRight"], 19, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 20, 10);
    this.setSpriteAt(swSprites["swVertRight"], 20, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 21, 10);
    this.setSpriteAt(swSprites["swVertRight"], 21, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 22, 10);
    this.setSpriteAt(swSprites["swVertRight"], 22, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 23, 10);
    this.setSpriteAt(swSprites["swVertRight"], 23, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 24, 10);
    this.setSpriteAt(swSprites["swVertRight"], 24, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 25, 10);
    this.setSpriteAt(swSprites["swVertRight"], 25, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 26, 10);
    this.setSpriteAt(swSprites["swVertRight"], 26, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 27, 10);
    this.setSpriteAt(swSprites["swVertRight"], 27, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 28, 10);
    this.setSpriteAt(swSprites["swVertRight"], 28, 11);
    this.setSpriteAt(swSprites["swBrkVertLeft"], 29, 10);
    this.setSpriteAt(swSprites["swVertRight"], 29, 11);

    /**
     * This is the parking lot.  Three hobos hang out here to steal your beer.
     */
    for (int r = 10; r < 30; r++) {
      for (int c = 0; c < 10; c++) {

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

    this.npcRegion1 = new Region(
      0,
      10 * this.tileWidth,
      10 * this.tileHeight,
      30 * this.tileHeight
    );

    /**
     * END Parking Lot
     */

    for (int c = 0; c < 12; c++) {
      this.setSpriteAt(roadSprites["roadOuterTop"], 4, c);
      this.setSpriteAt(roadSprites["lineHorizontal"], 5, c);
      this.setSpriteAt(roadSprites["roadOuterBottom"], 6, c);
    }

    this.setSpriteAt(roadSprites["lineCurveDownLeft"], 5, 12);
    this.setSpriteAt(roadSprites["lineCurveDownLeft"], 6, 13);

    for (int r = 7; r < 30; r++) {
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 12);
      this.setSpriteAt(roadSprites["lineVertical"], r, 13);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 14);
    }

    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 22);
      this.setSpriteAt(roadSprites["lineVertical"], r, 23);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 24);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 26);
      this.setSpriteAt(roadSprites["lineVertical"], r, 27);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 28);
    }

    for (int r = 4; r < 30; r++) {
      this.setSpriteAt(swSprites["swVertMid"], r, 15);
    }

    for (int r = 18; r < 30; r++) {
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 30);
      this.setSpriteAt(roadSprites["lineVertical"], r, 31);
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 32);
    }
    for (int c = 33; c < 40; c++) {
      this.setSpriteAt(roadSprites["roadOuterTop"], 15, c);
      this.setSpriteAt(roadSprites["lineHorizontal"], 16, c);
      this.setSpriteAt(roadSprites["roadOuterBottom"], 17, c);
    }

    // Apartment/fence layer
    //this.newLayer();

    for (int c = 0; c < 6; c++) {
      this.setSpriteAt(fenceSprites["wireHorizMid"], 7, c);
    }
    //this.setSpriteAt(fenceSprites["wireHorizRight"], 7, 5);
    //this.setSpriteAt(fenceSprites["wireHorizLeft"], 7, 8);
    for (int c = 8; c < 11; c++) {
      this.setSpriteAt(fenceSprites["wireHorizMid"], 7, c);
    }
    this.setSpriteAt(fenceSprites["wireHorizRight"], 7, 11);

    for (int r = 8; r < 30; r++) {
      this.setSpriteAt(fenceSprites["wireVertMid"], r, 11);
    }

    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 16);
    }

    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 21);
    }
    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 25);
    }
    for (int r = 0; r < 30; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 29);
    }

    for (int c = 30; c < 34; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 9, c);
    }
    this.setSpriteAt(fenceSprites["woodHorizRight"], 9, 34);
    this.setSpriteAt(fenceSprites["woodHorizLeft"], 9, 37);
    for (int c = 38; c < 40; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 9, c);
    }
    for (int c = 32; c < 36; c++) {
      this.setSpriteAt(fenceSprites["woodHorizMid"], 14, c);
    }
    this.setSpriteAt(fenceSprites["woodHorizRight"], 14, 36);
    this.setSpriteAt(fenceSprites["woodHorizLeft"], 14, 39);

    this.setSpriteAt(aptSprites["apt1TopLeft"], 0, 0);
    this.setSpriteAt(aptSprites["apt1TopRight"], 0, 1);
    this.setSpriteAt(aptSprites["apt2TopLeft"], 0, 2);
    this.setSpriteAt(aptSprites["apt2TopRight"], 0, 3);
    this.setSpriteAt(aptSprites["apt3TopLeft"], 0, 4);
    this.setSpriteAt(aptSprites["apt3TopRight"], 0, 5);
    this.setSpriteAt(aptSprites["apt4TopLeft"], 0, 6);
    this.setSpriteAt(aptSprites["apt4TopRight"], 0, 7);
    this.setSpriteAt(aptSprites["apt5TopLeft"], 0, 8);
    this.setSpriteAt(aptSprites["apt5TopRight"], 0, 9);
    this.setSpriteAt(aptSprites["apt6TopLeft"], 0, 10);
    this.setSpriteAt(aptSprites["apt6TopRight"], 0, 11);
    this.setSpriteAt(aptSprites["apt1MidLeft"], 1, 0);
    this.setSpriteAt(aptSprites["apt1MidRight"], 1, 1);
    this.setSpriteAt(aptSprites["apt2MidLeft"], 1, 2);
    this.setSpriteAt(aptSprites["apt2MidRight"], 1, 3);
    this.setSpriteAt(aptSprites["apt3MidLeft"], 1, 4);
    this.setSpriteAt(aptSprites["apt3MidRight"], 1, 5);
    this.setSpriteAt(aptSprites["apt4MidLeft"], 1, 6);
    this.setSpriteAt(aptSprites["apt4MidRight"], 1, 7);
    this.setSpriteAt(aptSprites["apt5MidLeft"], 1, 8);
    this.setSpriteAt(aptSprites["apt5MidRight"], 1, 9);
    this.setSpriteAt(aptSprites["apt6MidLeft"], 1, 10);
    this.setSpriteAt(aptSprites["apt6MidRight"], 1, 11);
    this.setSpriteAt(aptSprites["apt1BotLeft"], 2, 0);
    this.setSpriteAt(aptSprites["apt1BotRight"], 2, 1);
    this.setSpriteAt(aptSprites["apt2BotLeft"], 2, 2);
    this.setSpriteAt(aptSprites["apt2BotRight"], 2, 3);
    this.setSpriteAt(aptSprites["apt3BotLeft"], 2, 4);
    this.setSpriteAt(aptSprites["apt3BotRight"], 2, 5);
    this.setSpriteAt(aptSprites["apt4BotLeft"], 2, 6);
    this.setSpriteAt(aptSprites["apt4BotRight"], 2, 7);
    this.setSpriteAt(aptSprites["apt5BotLeft"], 2, 8);
    this.setSpriteAt(aptSprites["apt5BotRight"], 2, 9);
    this.setSpriteAt(aptSprites["apt6BotLeft"], 2, 10);
    this.setSpriteAt(aptSprites["apt6BotRight"], 2, 11);

    this.setSpriteAt(aptSprites["treeTopLeft"], 0, 13);
    this.setSpriteAt(aptSprites["treeTopMid"], 0, 14);
    this.setSpriteAt(aptSprites["treeTopRight"], 0, 15);
    this.setSpriteAt(aptSprites["treeMidLeft"], 1, 13);
    this.setSpriteAt(aptSprites["treeMidMid"], 1, 14);
    this.setSpriteAt(aptSprites["treeMidRight"], 1, 15);
    this.setSpriteAt(aptSprites["treeBotLeft"], 2, 13);
    this.setSpriteAt(aptSprites["treeBotMid"], 2, 14);
    this.setSpriteAt(aptSprites["treeBotRight"], 2, 15);
    this.setSpriteAt(aptSprites["treeShadowLeft"], 3, 13);
    this.setSpriteAt(aptSprites["treeShadowMid"], 3, 14);
    this.setSpriteAt(aptSprites["treeShadowRight"], 3, 15);

    // THE HOUSE
    this.setSpriteAt(houseSprites["wallTopLeft"], 2, 30);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 31);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 32);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 33);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 34);
    this.setSpriteAt(houseSprites["wallTopMid"], 2, 38);
    this.setSpriteAt(houseSprites["wallTopRight"], 2, 39);
    this.setSpriteAt(houseSprites["wallMidLeft"], 3, 30);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 31);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 32);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 33);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 34);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 38);
    this.setSpriteAt(houseSprites["wallMidRight"], 3, 39);
    this.setSpriteAt(houseSprites["wallBotLeft"], 4, 30);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 31);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 32);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 33);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 34);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 38);
    this.setSpriteAt(houseSprites["wallBotRight"], 4, 39);

    this.setSpriteAt(houseSprites["roofSideAngleLeft"], 0, 30);
    this.setSpriteAt(houseSprites["roofFlatBotLeft"], 0, 31);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 32);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 33);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 34);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 35);
    this.setSpriteAt(houseSprites["roofFlatMidMid"], 0, 36);
    this.setSpriteAt(houseSprites["roofFlatBotMid"], 0, 37);
    this.setSpriteAt(houseSprites["roofFlatBotRight"], 0, 38);
    this.setSpriteAt(houseSprites["roofSideAngleRight"], 0, 39);
    this.setSpriteAt(houseSprites["roofFrontAngleLeft"], 2, 35);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 2, 36);
    this.setSpriteAt(houseSprites["roofFrontAngleRight"], 2, 37);
    this.setSpriteAt(houseSprites["roofFrontAngleInvLeft"], 1, 35);
    this.setSpriteAt(houseSprites["roofFlatOpenTop"], 1, 36);
    this.setSpriteAt(houseSprites["roofFrontAngleInvRight"], 1, 37);
    this.setSpriteAt(houseSprites["roofFrontAngleLeft"], 1, 30);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 31);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 32);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 33);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 34);
    this.setSpriteAt(houseSprites["roofFrontAngleMid"], 1, 38);
    this.setSpriteAt(houseSprites["roofFrontAngleRight"], 1, 39);

    this.setSpriteAt(houseSprites["wallMidMid"], 3, 35);
    this.setSpriteAt(houseSprites["wallMidMid"], 3, 37);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 35);
    this.setSpriteAt(houseSprites["wallBotMid"], 4, 37);

    this.newLayer();
    this.setSpriteAt(houseSprites["wallTopLeft"], 3, 35);
    this.setSpriteAt(houseSprites["wallTopMid"], 3, 36);
    this.setSpriteAt(houseSprites["wallTopRight"], 3, 37);
    this.setSpriteAt(houseSprites["wallMidLeft"], 4, 35);
    this.setSpriteAt(houseSprites["wallMidMid"], 4, 36);
    this.setSpriteAt(houseSprites["wallMidRight"], 4, 37);
    this.setSpriteAt(houseSprites["wallBotLeft"], 5, 35);
    this.setSpriteAt(houseSprites["wallBotMid"], 5, 36);
    this.setSpriteAt(houseSprites["wallBotRight"], 5, 37);



    this.newLayer();
    this.setSpriteAt(houseSprites["door2Top"], 4, 36);
    this.setSpriteAt(houseSprites["door2Bot"], 5, 36);
    this.setSpriteAt(houseSprites["window2Top"], 2, 34);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 34);
    this.setSpriteAt(houseSprites["window2Top"], 2, 32);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 32);
    this.setSpriteAt(houseSprites["window2Top"], 2, 38);
    this.setSpriteAt(houseSprites["window2Bot"], 3, 38);
    this.newLayer();
    this.setSpriteAt(houseSprites["stairsTop"], 5, 36);
    this.setSpriteAt(houseSprites["stairsBot"], 6, 36);


    this.roadPath1 = new Path([
                              new Point(32 * 13, this.rows * this.tileHeight),
                              new Point(32 * 13, 5 * 32 - 48),
                              new Point(-160, 5 * 32 - 48)
                              ]);
    this.roadPath2 = new Path([
                                new Point(27 * this.tileWidth,
                                   this.rows * this.tileHeight),
                                new Point(27 * this.tileWidth, -160)
                               ]);
    this.roadPath3 = new Path([

                               new Point(23 * this.tileWidth, -160),
                               new Point(23 * this.tileWidth,
                                   this.rows * this.tileHeight)
                               ]);

    SpriteSheet carSheet = new SpriteSheet('img/Cars_final.png');
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
    "lineCurveUpLeft": [474, 348]

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
}

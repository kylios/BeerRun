library level1;

import 'dart:html';
import 'dart:math';

import 'package:BeerRun/level.dart';
import 'package:BeerRun/drawing.dart';
import 'package:BeerRun/canvas_manager.dart';

class Level1 extends Level {

  Level1(CanvasManager manager, CanvasDrawer drawer) :
    super(drawer, manager, 15, 20, 32, 32)
  {

    SpriteSheet road = new SpriteSheet("img/Street.png", this.tileWidth, this.tileHeight);
    Map<String, Sprite> roadSprites =
        Level.parseSpriteSheet(road, Level1._roadSpriteSheetData);

    SpriteSheet apt = new SpriteSheet("img/apartments.png", this.tileWidth, this.tileHeight);
    Map<String, Sprite> aptSprites =
        Level.parseSpriteSheet(apt, Level1._aptSpriteSheetData);

    SpriteSheet grass = new SpriteSheet("img/LPC Base Assets/tiles/grass.png", this.tileWidth, this.tileHeight);
    Map<String, Sprite> grassSprites =
        Level.parseSpriteSheet(grass, Level1._grassSpriteSheetData);

    SpriteSheet sw = new SpriteSheet("img/Sidewalk_dark.png", this.tileWidth, this.tileHeight);
    Map<String, Sprite> swSprites =
        Level.parseSpriteSheet(sw, Level1._swSpriteSheetData);


    // Grass layer
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

    this.setSpriteAt(swSprites["swHorzTop"], 7, 0);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 1);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 2);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 3);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 4);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 5);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 6);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 7);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 8);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 9);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 10);
    this.setSpriteAt(swSprites["swHorzTop"], 7, 11);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 0);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 1);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 2);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 3);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 4);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 5);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 6);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 7);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 8);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 9);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 10);
    this.setSpriteAt(swSprites["swBrkHorzBot"], 8, 11);

    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 0);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 1);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 2);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 3);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 4);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 5);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 6);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 7);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 8);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 9);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 10);
    this.setSpriteAt(roadSprites["roadOuterTop"], 4, 11);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 0);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 1);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 2);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 3);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 4);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 5);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 6);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 7);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 8);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 9);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 10);
    this.setSpriteAt(roadSprites["lineHorizontal"], 5, 11);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 0);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 1);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 2);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 3);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 4);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 5);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 6);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 7);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 8);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 9);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 10);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 6, 11);




    // Apartment layer
    this.newLayer();

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
  }

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
    "swBrk": [32, 32],
    "swBrkVertLeft": [64, 32],
    "swBrkTopRight": [0, 64],
    "swBrkHorzTop": [32, 64],
    "swBrkTopLeft": [64, 64],

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
    "lineVerticalLeft": [96, 128]

  };
}

part of beer_run;

class Level1 extends Level {
  Random rng = new Random();

  Level1(CanvasManager manager, CanvasDrawer drawer) : super(
      drawer, manager,
      new Duration(minutes: 1, seconds: 30), 15, 40, 32, 32) {

    SpriteSheet road = new SpriteSheet("img/Street.png", 32, 32);
    Map<String, Sprite> roadSprites =
        Level.parseSpriteSheet(road, Data._roadSpriteSheetData);

    SpriteSheet apt = new SpriteSheet("img/apartments.png", 32, 32);
    Map<String, Sprite> aptSprites =
        Level.parseSpriteSheet(apt, Data._aptSpriteSheetData);

    SpriteSheet grass = new SpriteSheet("img/LPC Base Assets/tiles/grass.png", 32, 32);
    Map<String, Sprite> grassSprites =
        Level.parseSpriteSheet(grass, Data._grassSpriteSheetData);

    SpriteSheet sw = new SpriteSheet("img/Sidewalk_dark.png", 32, 32);
    Map<String, Sprite> swSprites =
        Level.parseSpriteSheet(sw, Data._swSpriteSheetData);

    SpriteSheet fence = new SpriteSheet("img/fence.png", 32, 32);
    Map<String, Sprite> fenceSprites =
        Level.parseSpriteSheet(fence, Data._fenceSpriteSheetData);

    SpriteSheet house = new SpriteSheet("img/house.png", 32, 32);
    Map<String, Sprite> houseSprites =
        Level.parseSpriteSheet(house, Data._houseSpriteSheetData);

    SpriteSheet building = new SpriteSheet("img/Building.png", 32, 32);
    Map<String, Sprite> buildingSprites =
        Level.parseSpriteSheet(building, Data._buildingSpriteSheetData);



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

    this.newLayer();

    // Sidewalk
    this.setSpriteAt(swSprites["swHorzMidTopMidConnector"], 7, 28, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 29, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 30, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 31, false);
    this.setSpriteAt(swSprites["swHorzMidBotMidConnector"], 7, 32, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 33, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 34, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 35, false);
    this.setSpriteAt(swSprites["swHorzMidTopMidConnector"], 7, 36, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 37, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 38, false);
    this.setSpriteAt(swSprites["swHorzMid"], 7, 39, false);

    this.setSpriteAt(swSprites["swVertMid"], 0, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 1, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 2, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 3, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 4, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 5, 28, false);
    this.setSpriteAt(swSprites["swVertMid"], 6, 28, false);

    this.setSpriteAt(swSprites["swVertMid"], 8, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 9, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 10, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 11, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 12, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 13, 32, false);
    this.setSpriteAt(swSprites["swVertMid"], 14, 32, false);

    for (int r = 0; r < 15; r++) {
      this.setSpriteAt(swSprites["swVertMid"], r, 23, false);
      this.setSpriteAt(swSprites["swVertMid"], r, 18, false);
    }



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


    // FENCE
    this.setSpriteAt(fenceSprites["woodVertMid"], 0, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 1, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 2, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 3, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 4, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 5, 29, true);
    this.setSpriteAt(fenceSprites["woodVertMid"], 6, 29, true);
    this.setSpriteAt(fenceSprites["woodHorizMid"], 6, 32, true);
    this.setSpriteAt(fenceSprites["woodHorizMid"], 6, 33, true);
    this.setSpriteAt(fenceSprites["woodHorizMid"], 6, 34, true);
    this.setSpriteAt(fenceSprites["woodHorizRight"], 6, 35, true);
    this.setSpriteAt(swSprites["swVertMid"], 6, 36, false);
    this.setSpriteAt(fenceSprites["woodHorizLeft"], 6, 37, true);
    this.setSpriteAt(fenceSprites["woodHorizMid"], 6, 38, true);
    this.setSpriteAt(fenceSprites["woodHorizMid"], 6, 39, true);

    for (int r = 0; r < 13; r++) {
      this.setSpriteAt(fenceSprites["woodVertMid"], r, 17, true);
    }

    // Road
    this.setSpriteAt(roadSprites["roadOuterRight"], 14, 31, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 13, 31, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 12, 31, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 11, 31, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 10, 31, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 14, 30, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 13, 30, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 12, 30, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 14, 29, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 13, 29, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 12, 29, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 14, 28, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 13, 28, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 12, 28, false);

    this.setSpriteAt(roadSprites["roadOuterTop"], 8, 29, false);
    this.setSpriteAt(roadSprites["roadOuterTop"], 8, 28, false);

    this.setSpriteAt(roadSprites["roadOuterRight"], 7, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 6, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 5, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 4, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 3, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 2, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 1, 27, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 0, 27, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 7, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 6, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 5, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 4, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 3, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 2, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 1, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 0, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 7, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 6, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 5, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 4, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 3, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 2, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 1, 25, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 0, 25, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 7, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 6, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 5, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 4, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 3, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 2, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 1, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 0, 24, false);

    for (int r = 0; r < 15; r++) {
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 22, false);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 21, false);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 20, false);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 19, false);

      for (int c = 0; c < 16; c++) {
        int rand = this.rng.nextInt(22);
        if (rand == 0) {
          this.setSpriteAt(swSprites["brkTopLeft"], r, c, false);
        } else if (rand == 1) {
          this.setSpriteAt(swSprites["brkTopRight"], r, c, false);
        } else if (rand == 2) {
          this.setSpriteAt(swSprites["brkBottomLeft"], r, c, false);
        } else if (rand == 3) {
          this.setSpriteAt(swSprites["brkBottomRight"], r, c, false);
        } else {
          this.setSpriteAt(swSprites["brk"], r, c, false);
        }
      }
      this.setSpriteAt(swSprites["swBrkVertLeft"], r, 16, false);
    }






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


    // WIRE FENCE
    for (int r = 2; r < 15; r++) {
      this.setSpriteAt(fenceSprites["wireVertMid"], r, 14, true);
    }


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

    // TREE
    this.setSpriteAt(aptSprites["treeTopLeft"], 8, 37, true);
    this.setSpriteAt(aptSprites["treeTopMid"], 8, 38, true);
    this.setSpriteAt(aptSprites["treeTopRight"], 8, 39, true);
    this.setSpriteAt(aptSprites["treeMidLeft"], 9, 37, true);
    this.setSpriteAt(aptSprites["treeMidMid"], 9, 38, true);
    this.setSpriteAt(aptSprites["treeMidRight"], 9, 39, true);
    this.setSpriteAt(aptSprites["treeBotLeft"], 10, 37, true);
    this.setSpriteAt(aptSprites["treeBotMid"], 10, 38, true);
    this.setSpriteAt(aptSprites["treeBotRight"], 10, 39, true);
    this.setSpriteAt(aptSprites["treeShadowLeft"], 11, 37, true);
    this.setSpriteAt(aptSprites["treeShadowMid"], 11, 38, true);
    this.setSpriteAt(aptSprites["treeShadowRight"], 11, 39, true);


    this.setSpriteAt(aptSprites["treeTopLeft"], 9, 34, true);
    this.setSpriteAt(aptSprites["treeTopMid"], 9, 35, true);
    this.setSpriteAt(aptSprites["treeTopRight"], 9, 36, true);
    this.setSpriteAt(aptSprites["treeMidLeft"], 10, 34, true);
    this.setSpriteAt(aptSprites["treeMidMid"], 10, 35, true);
    this.setSpriteAt(aptSprites["treeMidRight"], 10, 36, true);
    this.setSpriteAt(aptSprites["treeBotLeft"], 11, 34, true);
    this.setSpriteAt(aptSprites["treeBotMid"], 11, 35, true);
    this.setSpriteAt(aptSprites["treeBotRight"], 11, 36, true);
    this.setSpriteAt(aptSprites["treeShadowLeft"], 12, 34, true);
    this.setSpriteAt(aptSprites["treeShadowMid"], 12, 35, true);
    this.setSpriteAt(aptSprites["treeShadowRight"], 12, 36, true);

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


    // BEER STORE
    this.setSpriteAt(buildingSprites["storeWallMidLeft"], 4, 0, true);
    this.setSpriteAt(buildingSprites["storeWallMidMid"], 4, 1, true);
    this.setSpriteAt(buildingSprites["storeWallMidMid"], 4, 2, true);
    this.setSpriteAt(buildingSprites["doorBotLeft"], 4, 3, false);
    this.setSpriteAt(buildingSprites["doorBotRight"], 4, 4, false);
    this.setSpriteAt(buildingSprites["storeWallMidRight"], 4, 5, true);
    this.setSpriteAt(buildingSprites["storeWallMidLeft"], 3, 0, true);
    this.setSpriteAt(buildingSprites["beerSignLeft"], 3, 1, true);
    this.setSpriteAt(buildingSprites["beerSignRight"], 3, 2, true);
    this.setSpriteAt(buildingSprites["doorTopLeft"], 3, 3, true);
    this.setSpriteAt(buildingSprites["doorTopRight"], 3, 4, true);
    this.setSpriteAt(buildingSprites["storeWallMidRight"], 3, 5, true);
    this.setSpriteAt(buildingSprites["storeWallTopLeft"], 2, 0, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 2, 1, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 2, 2, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 2, 3, true);
    this.setSpriteAt(buildingSprites["storeWallTopMid"], 2, 4, true);
    this.setSpriteAt(buildingSprites["storeWallTopRight"], 2, 5, true);
    this.setSpriteAt(buildingSprites["storeRoofLeft"], 1, 0, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 1, 1, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 1, 2, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 1, 3, true);
    this.setSpriteAt(buildingSprites["storeRoofMid"], 1, 4, true);
    this.setSpriteAt(buildingSprites["storeRoofRight"], 1, 5, true);
    this.setSpriteAt(buildingSprites["storeRoofBackLeft"], 0, 0, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 0, 1, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 0, 2, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 0, 3, true);
    this.setSpriteAt(buildingSprites["storeRoofBackMid"], 0, 4, true);
    this.setSpriteAt(buildingSprites["storeRoofBackRight"], 0, 5, true);


    //this.setSpriteAt(s, row, col, blocked)

  }

  int get startX => 32 * 36 - 16;
  int get startY => 32 * 6;
  int get storeX => 0 * 32;
  int get storeY => 0 * 32;
  int get beersToWin => 12;

  void setupTutorial(UI ui, Player p) {

    this.tutorial.onStart((var _) {
      Completer c = new Completer();
      this.canvasDrawer.setOffset(20 * 32, 0);

      View v = new TutorialDialog(this.tutorial,
          "What.. YOU want to come to our party!?  Well we need more "
          "beer, and it looks like you drew the short straw here buddy... "
          "We need you to head down to the STORE and get some BEER if you "
          "wanna come to the party.  You can find the store over there..."
      );

      ui.showView(v, callback: c.complete);

      return c.future;
    }).addStep((var _) {

      Completer c = new Completer();

      int tutorialDestX = this.storeX;
      int tutorialDestY = this.storeY;
      Timer _t = new Timer.periodic(new Duration(milliseconds: 20), (Timer t) {

        int offsetX = this.canvasDrawer.offsetX;
        int offsetY = this.canvasDrawer.offsetY;

        if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
          t.cancel();
          c.complete();
        }

        int moveX;
        if (tutorialDestX < offsetX) {
          moveX = max(-5, tutorialDestX - offsetX);
        } else {
          moveX = min(5, offsetX - tutorialDestX);
        }
        int moveY;
        if (tutorialDestY < offsetY) {
          moveY = max(-5, offsetY - tutorialDestY);
        } else {
          moveY = min(5, tutorialDestY - offsetY);
        }

        // Move the viewport closer to the beer store
        this.canvasDrawer.moveOffset(moveX, moveY);

        this.canvasDrawer.clear();
        this.draw(this.canvasDrawer);
      });

      return c.future;
    })
    .addStep((var _) {
      Completer c = new Completer();
      ui.showView(
          new TutorialDialog(this.tutorial,
              "Grab us a ${this.beersToWin} pack and bring it back.  Better "
              "avoid the bums... they like to steal your beer, and then you'll "
              "have to go BACK and get MORE!"),
          callback: c.complete
      );
      return c.future;
    })
    .addStep((var _) {
      window.console.log("continueTutorial2");

      Completer c = new Completer();

      int tutorialDestX = 20 * 32;
      int tutorialDestY = 0;
      Timer _t = new Timer.periodic(new Duration(milliseconds: 5), (Timer t) {

        int offsetX = this.canvasDrawer.offsetX;
        int offsetY = this.canvasDrawer.offsetY;

        window.console.log("$offsetX - $offsetY");
        if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
          t.cancel();
          c.complete();
          return c.future;
        }

        int moveX;
        if (tutorialDestX < offsetX) {
          moveX = max(-5, tutorialDestX - offsetX);
        } else {
          moveX = min(5, tutorialDestX - offsetX);
        }
        int moveY;
        if (tutorialDestY < offsetY) {
          moveY = max(-5, tutorialDestY - offsetY);
        } else {
          moveY = min(5, tutorialDestY - offsetY);
        }

        // Move the viewport closer to the beer store
        this.canvasDrawer.moveOffset(moveX, moveY);

        this.canvasDrawer.clear();
        this.draw(this.canvasDrawer);
      });

      return c.future;
    })
    .addStep((var _) {
      window.console.log("continueTutorial3");
      Completer c = new Completer();

      ui.showView(
          new TutorialDialog(this.tutorial,
              "Well, what are you waiting for!?  Better get going!  Oh yea, and"
              " don't forget to keep your buzz going... don't get bored and"
              " bail on us!"),
          callback: () { c.complete(); }
      );
      return c.future;
    })
    .onFinish((var _) {

      p.setPos(this.startX, this.startY);
      p.setDrawingComponent(
        new PlayerDrawingComponent(this.canvasManager, this.canvasDrawer, true)
      );
    });
  }

}


part of beer_run;

class Level1 extends Level {
  Random rng = new Random();

  final int _spawnCar1At = 200;
  final int _spawnCar2At = 300;
  final int _spawnCar3At = 350;
  int _spawnCar1Cnt = 200;
  int _spawnCar2Cnt = 0;
  int _spawnCar3Cnt = 150;

  List<Sprite> _car1Sprites;
  List<Sprite> _car2Sprites;

  Path roadPath1;
  Path roadPath2;

  Level1(CanvasManager manager, CanvasDrawer drawer) : super(
      drawer, manager, 15, 40, 32, 32) {

    SpriteSheet road = Data.road;
    Map<String, Sprite> roadSprites =
        Level.parseSpriteSheet(road, Data._roadSpriteSheetData);

    SpriteSheet apt = Data.apt;
    Map<String, Sprite> aptSprites =
        Level.parseSpriteSheet(apt, Data._aptSpriteSheetData);

    SpriteSheet grass = Data.grass;
    Map<String, Sprite> grassSprites =
        Level.parseSpriteSheet(grass, Data._grassSpriteSheetData);

    SpriteSheet sw = Data.sw;
    Map<String, Sprite> swSprites =
        Level.parseSpriteSheet(sw, Data._swSpriteSheetData);

    SpriteSheet fence = Data.fence;
    Map<String, Sprite> fenceSprites =
        Level.parseSpriteSheet(fence, Data._fenceSpriteSheetData);

    SpriteSheet house = Data.house;
    Map<String, Sprite> houseSprites =
        Level.parseSpriteSheet(house, Data._houseSpriteSheetData);

    SpriteSheet building = Data.building;
    Map<String, Sprite> buildingSprites =
        Level.parseSpriteSheet(building, Data._buildingSpriteSheetData);

    SpriteSheet carSheet = Data.carSheet;
    Sprite brokenCarTopLeft = carSheet.spriteAt(384, 0, 32, 32);
    Sprite brokenCarTopRight = carSheet.spriteAt(416, 0, 32, 32);
    Sprite brokenCarMidTopLeft = carSheet.spriteAt(384, 32, 32, 32);
    Sprite brokenCarMidTopRight = carSheet.spriteAt(416, 32, 32, 32);
    Sprite brokenCarMidBotLeft = carSheet.spriteAt(384, 64, 32, 32);
    Sprite brokenCarMidBotRight = carSheet.spriteAt(416, 64, 32, 32);
    Sprite brokenCarBotLeft = carSheet.spriteAt(384, 96, 32, 32);
    Sprite brokenCarBotRight = carSheet.spriteAt(416, 96, 32, 32);
    Sprite tire = carSheet.spriteAt(384, 128, 32, 32);

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
    this.setSpriteAt(roadSprites["roadOuterTopRight"], 8, 31, false);

    for (int r = 11; r < 15; r++) {
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 31, false);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 30, false);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 29, false);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 28, false);
    }
    this.setSpriteAt(roadSprites["roadOuterRight"], 9, 31, false);
    this.setSpriteAt(roadSprites["roadOuterRight"], 10, 31, false);
    this.setSpriteAt(roadSprites["road"], 9, 30, false);
    this.setSpriteAt(roadSprites["road"], 10, 30, false);
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 10, 30, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 10, 29, false);
    this.setSpriteAt(roadSprites["roadInnerBottomLeft"], 10, 28, false);

    for (int c = 26; c < 30; c++) {
      this.setSpriteAt(roadSprites["lineHorizontal"], 9, c, false);
    }
    this.setSpriteAt(roadSprites["roadOuterLeft"], 8, 24, false);
    this.setSpriteAt(roadSprites["roadOuterLeft"], 9, 24, false);
    this.setSpriteAt(roadSprites["road"], 9, 25, false);

    this.setSpriteAt(roadSprites["roadOuterTop"], 8, 30, false);
    this.setSpriteAt(roadSprites["roadOuterTop"], 8, 29, false);
    this.setSpriteAt(roadSprites["roadOuterTop"], 8, 28, false);
    this.setSpriteAt(roadSprites["roadInnerTopRight"], 8, 27, false);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 10, 27, false);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 10, 26, false);
    this.setSpriteAt(roadSprites["roadOuterBottom"], 10, 25, false);
    this.setSpriteAt(roadSprites["roadOuterBottomLeft"], 10, 24, false);

    for (int r = 0; r < 8; r++) {
      this.setSpriteAt(roadSprites["roadOuterRight"], r, 27, false);
      this.setSpriteAt(roadSprites["lineDottedVertLeft"], r, 26, false);
      this.setSpriteAt(roadSprites["lineDottedVertRight"], r, 25, false);
      this.setSpriteAt(roadSprites["roadOuterLeft"], r, 24, false);
    }
    this.setSpriteAt(roadSprites["lineDottedVertLeft"], 8, 26, false);
    this.setSpriteAt(roadSprites["lineDottedVertRight"], 8, 25, false);


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



    // Add level triggers
    GameEvent beerStoreEvent = new GameEvent();
    beerStoreEvent.type = GameEvent.BEER_STORE_EVENT;
    beerStoreEvent.value = 24;
    Trigger beerStoreTrigger = new Trigger(beerStoreEvent, 3, 3);
    Trigger beerStoreTrigger2 = new Trigger(beerStoreEvent, 3, 4);

    GameEvent partyEvent = new GameEvent();
    partyEvent.type = GameEvent.PARTY_ARRIVAL_EVENT;
    Trigger partyTrigger = new Trigger(partyEvent, 4, 36);

    this.addTrigger(beerStoreTrigger);
    this.addTrigger(beerStoreTrigger2);
    this.addTrigger(partyTrigger);

    // Add cars
    this.roadPath1 = new Path([
      new GamePoint(21 * this.tileWidth, -160),
      new GamePoint(21 * this.tileWidth, this.rows * this.tileHeight)
    ]);
    this.roadPath2 = new Path([
      new GamePoint(30 * this.tileWidth, this.rows * this.tileHeight),
      new GamePoint(30 * this.tileWidth, 8 * this.tileHeight),
      new GamePoint(26 * this.tileWidth, 8 * this.tileHeight),
      new GamePoint(26 * this.tileWidth, -160)
    ]);

    // Add NPCs
    Region npcRegion1 = new Region(
        0,
        14 * this.tileWidth,
        5 * this.tileHeight,
        15 * this.tileHeight
    );
    Region npcRegion2 = new Region(
        23 * this.tileWidth,
        24 * this.tileWidth,
        0,
        15 * this.tileHeight
    );

    NPC npc1 = new NPC(this, DIR_DOWN, 8 * this.tileWidth, 10 * this.tileHeight);
    NPC npc2 = new NPC(this, DIR_DOWN, 3 * this.tileWidth, 12 * this.tileHeight);
    NPC npc3 = new NPC(this, DIR_DOWN, 23 * this.tileWidth, 10 * this.tileHeight);

    npc1.speed = 2;
    npc2.speed = 2;
    npc3.speed = 1;
    npc1.setControlComponent(new NPCInputComponent(npcRegion1));
    npc2.setControlComponent(new NPCInputComponent(npcRegion1));
    npc3.setControlComponent(new NPCInputComponent(npcRegion2));
    npc1.setDrawingComponent(
        new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
    npc2.setDrawingComponent(
        new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
    npc3.setDrawingComponent(
        new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
    this.addObject(npc1);
    this.addObject(npc2);
    this.addObject(npc3);
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
    if (this._spawnCar2Cnt >= this._spawnCar2At) {
      int blah = this.rng.nextInt(2);
      Car c = new Car(this.roadPath2, DIR_UP,
          (blah == 0 ? this._car1Sprites : this._car2Sprites));
      c.setLevel(this);
      c.setDrawingComponent(
          new DrawingComponent(this.canvasManager, this.canvasDrawer, false));
      this.addObject(c);
      // Sorta randomize the interval that we spawn cars
      this._spawnCar2Cnt = this.rng.nextInt(this._spawnCar2At ~/ 2);
    }
    super.update();
  }

  int get startX => 32 * 36 - 16;
  int get startY => 32 * 6;
  int get storeX => 0 * 32;
  int get storeY => 0 * 32;
  int get beersToWin => 12;
  Duration get duration => new Duration(minutes: 1, seconds: 30);

  void setupTutorial(UI ui, Player p) {

    this.tutorial.onStart((var _) {
      Completer c = new Completer();
      this.canvasDrawer.setOffset(20 * 32, 0);

      View v = new TutorialDialog(this.tutorial,
          "What.. who's this drunk idiot who wants to come to OUR party? "
          "I suppose you can come in.. BUT, we're running low on beer! "
          "Why don't you stumble on down to the store over there and grab us "
          "some beers!"
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
              "Well, what are you waiting for!?  Get moving, and don't sober "
              "up too much!"),
          callback: () { c.complete(); }
      );
      return c.future;
    })
    .onFinish((var _) {

      p.setPos(this.startX, this.startY);
    });
  }

}


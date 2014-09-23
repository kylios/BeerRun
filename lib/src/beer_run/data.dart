part of beer_run;

class Data {

    static final SpriteSheet road = new SpriteSheet("img/street.png", 32, 32);
    static final SpriteSheet apt = new SpriteSheet("img/apartments.png", 32, 32
            );
    static final SpriteSheet grass = new SpriteSheet("img/grass.png", 32, 32);
    static final SpriteSheet sw = new SpriteSheet("img/sidewalk.png", 32, 32);
    static final SpriteSheet fence = new SpriteSheet("img/fence.png", 32, 32);
    static final SpriteSheet house = new SpriteSheet("img/house.png", 32, 32);
    static final SpriteSheet building = new SpriteSheet("img/building.png", 32,
            32);
    static final SpriteSheet carSheet = new SpriteSheet('img/cars.png');

    static final Map _carSpriteSheetData = {
        "brokenCarTopLeft": [384, 0],
        "brokenCarTopRight": [416, 0],
        "brokenCarMidTopLeft": [384, 32],
        "brokenCarMidTopRight": [416, 32],
        "brokenCarMidBotLeft": [384, 64],
        "brokenCarMidBotRight": [416, 64],
        "brokenCarBotLeft": [384, 96],
        "brokenCarBotRight": [416, 96],
        "tire": [384, 128],

        "car1Up": [96, 96],
        "car1Right": [0, 96],
        "car1Down": [0, 0],
        "car1Left": [160, 0],
        "car2Up": [198, 96],
        "car2Right": [288, 96],
        "car2Down": [0, 256],
        "car2Left": [160, 256]
    };

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
        "swHorzMidBotMidConnector": [32, 160],
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

        "aptSideLeftBotLeft": [32, 256],
        "aptSideLeftBotRight": [64, 256],
        "aptSideLeftMidLeft": [32, 224],
        "aptSideLeftMidRight": [64, 224],
        "aptSideLeftTopLeft": [32, 192],
        "aptSideLeftTopRight": [64, 192],
        "aptSideLeftRoofBotLeft": [32, 160],
        "aptSideLeftRoofBotRight": [64, 160],
        "aptSideLeftRoofTopLeft": [32, 128],
        "aptSideLeftRoofTopRight": [64, 128],
        "aptSideLeftStairsTop": [0, 224],
        "aptSideLeftStairsBot": [0, 256],

        'flagPrideLeft': [0, 128],
        'flagAmericaLeft': [0, 160],
        'flagCaliforniaLeft': [0, 192],

        "aptSideRightBotLeft": [32, 256],
        "aptSideRightBotRight": [92, 256],
        "aptSideRightMidLeft": [32, 224],
        "aptSideRightMidRight": [92, 224],
        "aptSideRightTopLeft": [32, 192],
        "aptSideRightTopRight": [92, 192],
        "aptSideRightRoofBotLeft": [32, 160],
        "aptSideRightRoofBotRight": [92, 160],
        "aptSideRightRoofTopLeft": [32, 128],
        "aptSideRightRoofTopRight": [92, 128],
        "aptSideRightStairsTop": [0, 224],
        "aptSideRightStairsBot": [0, 256],

        'flagPrideRight': [0, 128],
        'flagAmericaRight': [0, 160],
        'flagCaliforniaRight': [0, 192],
    };

    static final Map _roadSpriteSheetData = {

        "road": [32, 32],
        "brokenRoad1": [0, 128],
        "brokenRoad2": [32, 128],
        "brokenRoad3": [64, 128],
        "roadOuterTopLeft": [128, 448],//[0, 0],
        "roadOuterTop": [32, 0],
        "roadOuterTopRight": [160, 448],//[64, 0],
        "roadOuterLeft": [0, 32],
        "roadOuterRight": [64, 32],
        "roadOuterBottomLeft": [128, 480],//[0, 64],
        "roadOuterBottom": [32, 64],
        "roadOuterBottomRight": [160, 480],//[64, 64],
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

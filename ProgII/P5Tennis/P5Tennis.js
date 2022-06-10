/*  Tennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/
var game;

var g_inputManager;

var g_keyboard;

function setup() {
    initializeFields();
    createCanvas(800, 800);
    g_inputManager = new InputManager();
    g_keyboard = new KeyboardState();
    game = new Game();
}

function draw() {
    background(0, 122, 0);
    game.run();
}

function keyReleased() {
    if (game.getState() != GAME_STATES.GAME_MENU) {
        g_keyboard.updateKeyReleased(key);
    }
}

function keyPressed() {
    var b = game.getBall();
    if (game.getState() != GAME_STATES.GAME_MENU) {
        g_keyboard.updateKeyPressed(key);
    }
    if (g_inputManager.getContext("Debug").getAction("Debug")) {
        game.changeDebug();
    }
    if (g_inputManager.getContext("Debug").getAction("Reset")) {
        reset(game.getPlayer(1), game.getPlayer(2), b);
    }
    if (g_inputManager.getContext("Debug").getAction("Add Point")) {
        game.setPoint(game.getPlayer(1), game.getPlayer(2), b);
    }
}

function reset(p1, p2, b) {
    b.init(0, 640, 15);
    p1.init(0, 0, -1);
    p2.init(0, 0, 1);
    game.startServe(p2, p1, b);
}

function getDeltaTime() {
    return DT;
}

function getRealDeltaTime() {
    return game.m_deltaTime;
}

function getDebug() {
    return game.m_debug;
}

function initializeFields() {
    game = null;
    g_inputManager = null;
    g_keyboard = null;
}


class Game {
    m_states;
    m_ball;
    m_players;
    m_court;
    m_net;
    m_activePlayers;
    m_menuChoice;
    m_contexts;
    m_currentTime;
    m_deltaTime;
    m_lastTime;
    m_scoreText;
    m_gameTitle;
    m_debug;
    m_state;
    constructor() {
        this.init();
    }
    init() {
        this.m_deltaTime = 0.0;
        this.m_currentTime = 0.0;
        this.m_lastTime = 0.0;
        this.m_activePlayers = 0;
        this.m_court = new Court();
        this.m_ball = new Ball(0, 0, 15);
        this.m_players = new Array(4);
        this.m_contexts = new Array(10);
        this.m_gameTitle = "Tennis Atari 2600";
        for (let i = 1; i <= PLAYERS_PLAYING; i++) {
            if (i % 2 == 0) {
                this.m_players[i - 1] = new Player(0, 0, i, 1);
            } else {
                this.m_players[i - 1] = new Player(0, 0, i, 2);
            }
            this.m_activePlayers++;
        }
        this.m_players[1].setColor(0, color(255, 0, 0));
        this.m_players[1].setColor(1, color(134, 50, 200));
        this.m_players[1].setColor(2, color(0, 255, 0));
        this.m_net = this.m_court.getNet();
        this.m_state = GAME_STATES.GAME_MENU;
        this.m_debug = false;
        this.initControllerContexts();
        this.loadController("controller.dante");
        this.startServe(this.m_players[0], this.m_players[1], this.m_ball);
    }
    initControllerContexts() {
        // from 0 to 3 are players contexts
        // 1 context for debug = 4 contexts;
        for (let i = 0; i < 5; i++) {
            this.m_contexts[i] = new InputContext(g_keyboard);
        }
        g_inputManager.addContext(this.m_players[0].m_name, this.m_contexts[0]);
        g_inputManager.addContext(this.m_players[1].m_name, this.m_contexts[1]);
        g_inputManager.addContext("Debug", this.m_contexts[4]);
    }
    loadController(inputConfig) {
        let input = g_inputManager;
        let lines = loadStrings(inputConfig);
        let context = "";
        let keyStr = "";
        let valueStr = "";
        let typeStr = "";
        for (let i = 0; i < lines.length; i++) {
            let words = split(lines[i], " ");
            if (words.length <= 2) {
                context = lines[i];
                continue;
            }
            if (words.length >= 4) {
                keyStr = words[0] + " " + words[1];
                valueStr = words[2];
                typeStr = words[3];
            } else {
                keyStr = words[0];
                valueStr = words[1];
                typeStr = words[2];
            }
            if (valueStr.equals("space")) valueStr = " ";
            let c = valueStr.toCharArray();
            console.log(
                context +
                    "," +
                    keyStr +
                    "," +
                    valueStr +
                    "," +
                    typeStr +
                    "," +
                    c[0]
            );
            if (typeStr.equals("ACTION")) {
                input.getContext(context).mapAction(keyStr, c[0]);
            } else {
                input.getContext(context).mapState(keyStr, c[0]);
            }
        }
    }
    updateMenu() {
        if (
            CollisionRP(
                float(width / 2 - 30),
                float(height / 2 + 50),
                float(60),
                float(30),
                float(mouseX),
                float(mouseY)
            )
        ) {
            this.m_menuChoice = 1;
        } else if (
            CollisionRP(
                float(width / 2 - 30),
                float(height / 2 + 90),
                float(60),
                float(30),
                float(mouseX),
                float(mouseY)
            )
        ) {
            this.m_menuChoice = 2;
        } else {
            this.m_menuChoice = 0;
        }
        if (mouseButton == LEFT_ARROW && mousePressed) {
            switch (this.m_menuChoice) {
                case 0:
                    break;
                case 1:
                    this.setState(GAME_STATES.GAME_SERVE);
                    break;
                case 2:
                    exit();
                    break;
                default:
                    break;
            }
        }
    }
    updateGame() {
        this.m_currentTime = millis() / 1000.0;
        this.m_deltaTime += this.m_currentTime - this.m_lastTime;
        this.m_lastTime = this.m_currentTime;
        if (this.m_deltaTime >= DT) {
            if (this.m_state == GAME_STATES.GAME_MENU) {
            } else {
                this.m_deltaTime -= DT;
                this.m_ball.update(this, this.m_court, this.m_net);
                for (let player = 0; player < this.m_activePlayers; player++) {
                    let p = this.m_players[player];
                    if (p != null) {
                        p.handleInput(this);
                        p.update(this, this.m_court, this.m_net);
                    }
                }
                if (this.shouldGivePoint()) {
                    this.setState(GAME_STATES.GAME_POINT);
                    this.setPoint(
                        this.m_players[0],
                        this.m_players[1],
                        this.m_ball
                    );
                    this.startServe(
                        this.m_players[0],
                        this.m_players[1],
                        this.m_ball
                    );
                }
            }
        }
        g_keyboard.update();
    }
    drawGame() {
        this.m_court.draw(); // Should draw Player 2 and 4 if they exist
        if (this.m_players[1] != null) this.m_players[1].draw();
        if (this.m_players[3] != null) this.m_players[3].draw();
        if (this.m_ball.getSide() == 1) {
            this.m_ball.draw();
            this.m_court.drawNet();
        } else {
            this.m_court.drawNet();
            this.m_ball.draw();
        } // Should draw Player 1 and 3if they exist
        if (this.m_players[0] != null) this.m_players[0].draw();
        if (this.m_players[2] != null) this.m_players[2].draw();
    }
    drawMenu() {
        fill(150, 150, 0);
        textSize(46);
        text(
            this.m_gameTitle,
            width / 2 - textWidth(this.m_gameTitle) / 2,
            height / 2 - 100
        ); // Button - Start
        fill(180);
        rect(width / 2 - 30, height / 2 + 50, 60, 30);
        textSize(16);
        fill(16);
        text("Start", width / 2 - 15, height / 2 + 50 + 20); // Button - Exit
        fill(180);
        rect(width / 2 - 30, height / 2 + 90, 60, 30);
        textSize(16);
        fill(16);
        text(
            "Exit",
            width / 2 - 15,
            height / 2 + 90 + 20
        ); /* text("" + m_state,10,10); */
        /* text("" + m_menuChoice,10,25); */
    }
    run() {
        if (this.m_state == GAME_STATES.GAME_MENU) {
            this.updateMenu();
            this.drawMenu();
        } else {
            this.updateGame();
            this.drawGame();
            this.drawGUI();
        }
    }
    drawGUI() {
        textSize(36);
        fill(255, 255, 0);
        this.m_scoreText =
            int(this.m_players[0].m_score) +
            " : " +
            int(this.m_players[1].m_score);
        text(
            this.m_scoreText,
            width / 2 - textWidth(this.m_scoreText) / 2,
            textDescent() + textAscent()
        );
        textSize(12);
        if (this.m_debug) {
            fill(0, 255, 0);
            text("CurrentTime: " + this.m_currentTime, 0, 15);
            text("DeltaTime: " + this.m_deltaTime, 0, 30);
            text("Game State: " + this.m_state, 0, 45);
            for (let i = 0; i < this.m_players.length; i++) {
                let p = this.m_players[i];
                if (p != null) {
                    p.drawDebug(0 + 150 * i, 625);
                }
            }
        }
    } // Helpers
    getBall() {
        return this.m_ball;
    }
    getCourt() {
        return this.m_court;
    }
    getPlayerServing() {
        let pId = 0;
        for (let p = 0; p < this.m_players.length; p++) {
            if (this.m_players[p] != null) {
                if (this.m_players[p].getServeStatus()) {
                    pId = p;
                    break;
                }
            }
        }
        return this.m_players[pId];
    }
    getPlayerRecieving() {
        let pId = 0;
        for (let p = 0; p < this.m_players.length; p++) {
            if (this.m_players[p] != null) {
                if (this.m_players[p].getRecieverStatus()) {
                    pId = p;
                    break;
                }
            }
        }
        return this.m_players[pId];
    }
    getPlayer(id) {
        if (id > 0 && id < 5) {
            return this.m_players[id - 1];
        }
        return this.m_players[0];
    }
    getPlayersLength() {
        return this.m_players.length;
    }
    setState(state) {
        this.m_state = state;
    }
    shouldStartServing() {
        return this.m_state == GAME_STATES.GAME_SERVE;
    }
    isServing() {
        return this.m_state == GAME_STATES.GAME_SERVING;
    }
    isInGame() {
        return this.m_state == GAME_STATES.GAME_PLAYING;
    }
    shouldGivePoint() {
        return this.m_ball.hasEnd();
    }
    changeDebug() {
        this.m_debug = !this.m_debug;
    }
    getState() {
        return this.m_state;
    } // Start any serve of the game
    startServe(serve, reciever, b) {
        b.startServe();
        b.setLastHit(serve);
        serve.setServeStatus();
        reciever.setRecieverStatus();
        serve.resetAim();
        reciever.resetAim();
        let option = int(random(1, 3));
        if (serve.getSide() == 1) {
            serve.setFacing(1);
            reciever.setFacing(-1);
            if (option % 2 == 0) {
                serve.setPos(width / 2 - width / 8, 130);
                reciever.setPos(width / 2 + width / 4, 620);
            } else {
                serve.setPos(width / 2 + width / 8, 130);
                reciever.setPos(width / 2 - width / 4, 620);
            }
        } else {
            serve.setFacing(-1);
            reciever.setFacing(1);
            if (option % 2 == 0) {
                serve.setPos(width / 2 - width / 4, 620);
                reciever.setPos(width / 2 + width / 8, 130);
            } else {
                serve.setPos(width / 2 + width / 4, 620);
                reciever.setPos(width / 2 - width / 8, 130);
            }
        }
        if (this.m_state != GAME_STATES.GAME_MENU) {
            this.m_state = GAME_STATES.GAME_SERVE;
        }
    } // Change from moving in serving to shooting ball up to serve
    startServing(server, b, reciever) {
        this.m_state = GAME_STATES.GAME_SERVING;
        server.setState(PLAYER_STATES.PLAYING, false);
        reciever.setState(PLAYER_STATES.PLAYING, true);
    }
    endServing() {
        this.m_state = GAME_STATES.GAME_PLAYING;
    }
    startGame(serve, reciever, b) {
        this.startServe(serve, reciever, b);
        serve.setScore(0);
        reciever.setScore(0);
    }
    setPoint(p1, p2, b) {
        let side = b.getSide();
        let reciever = p1.getState(PLAYER_STATES.RECIEVING) ? p1 : p2;
        let server = p1.getState(PLAYER_STATES.SERVING) ? p1 : p2; // When we went to DEUCE MODE
        let difference = abs(p1.getScore() - p2.getScore()); // This doesn't work when we have same points in advantage mode
        if (
            difference < 2 &&
            difference >= 0 &&
            (p1.getScore() > 0 || p2.getScore() > 0) &&
            p1.getScore() <= 10 &&
            p2.getScore() <= 10
        ) {
            if (
                (side == 1 && b.getLastHit() == p1 && b.isInside()) ||
                (side == 1 && b.getLastHit() == p2)
            ) {
                p1.addScore(1);
            } else {
                p2.addScore(1);
            }
            difference = abs(p1.getScore() - p2.getScore()); // Someone Won
            if (difference == 2) {
                if (p1.getScore() > p2.getScore()) {
                    p1.addGame();
                } else {
                    p2.addGame();
                }
                this.startGame(reciever, server, b);
            }
        } else {
            if (
                (side == 1 && b.getLastHit() == p1 && b.isInside()) ||
                (side == 1 && b.getLastHit() == p2) ||
                (side == 2 && b.getLastHit() == p2 && !b.isInside())
            ) {
                // Player one Won
                if (p1.getScore() == 40 && p2.getScore() != 40) {
                    p1.addGame();
                    this.startGame(reciever, server, b);
                } //DEUCE
                else if (p1.getScore() == 40 && p2.getScore() == 40) {
                    p1.setScore(1);
                    p2.setScore(0);
                } // Point for Player one
                else {
                    if (p1.getScore() == 30) {
                        p1.addScore(10);
                        return;
                    }
                    p1.addScore(15);
                }
            } else if (
                (side == 2 && b.getLastHit() == p2 && b.isInside()) ||
                (side == 2 && b.getLastHit() == p1) ||
                (side == 1 && b.getLastHit() == p1 && !b.isInside())
            ) {
                // Player two Won
                if (p2.getScore() >= 40 && p1.getScore() != 40) {
                    p2.addGame();
                    this.startGame(reciever, server, b);
                } //DEUCE
                else if (p2.getScore() == 40 && p1.getScore() == 40) {
                    p1.setScore(0);
                    p2.setScore(1);
                } // Point for Player two
                else {
                    if (p2.getScore() == 30) {
                        p2.addScore(10);
                        return;
                    }
                    p2.addScore(15);
                }
            }
        }
    }
}

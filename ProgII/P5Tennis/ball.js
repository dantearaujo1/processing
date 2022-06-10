/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */
class Ball {
    m_x;
    m_y;
    m_diameter;
    m_shadowX;
    m_shadowY;
    m_vel;
    m_velZ;
    m_currentHeight;
    m_currentMaxHeight;
    m_kickCount;
    m_lastHit; // Ball States
    m_side;
    m_inside;
    m_firstHit;
    m_state;
    serveKickDuration;
    elapsedTime;
    m_color; // Constructor
    constructor() {
        this.m_x = 0;
        this.m_y = 0;
        this.m_diameter = 10;
        this.m_color = color(190, 190, 0);
        this.m_vel = new p5.Vector(0, 1);
        this.m_velZ = 1;
        this.m_inside = false;
        this.m_firstHit = true;
        this.m_currentMaxHeight = BALL_MAX_HEIGHT;
        this.m_currentHeight = 0;
        this.m_kickCount = 0;
        this.serveKickDuration = 0.6;
        this.elapsedTime = 0;
        this.m_state = BALL_STATES.STOPPED;
    } // Constructor 2 overload
    /*constructor( x , y , d ) { this.m_x= x; this.m_y= y; this.m_diameter= d; this.m_color= color( 190 , 190 , 0 ) ; this.m_vel= new p5.Vector ( 0 , 0 ) ; this.m_velZ= 2 ; this.m_inside= false ; this.m_currentMaxHeight= BALL_MAX_HEIGHT; this.m_currentHeight= 0 ; this.m_kickCount= 0 ; this.m_firstHit= true ; this.serveKickDuration= 0.6; this.elapsedTime= 0 ; } */ init(
        x,
        y,
        d
    ) {
        this.m_x = x;
        this.m_y = y;
        this.m_diameter = d;
        this.m_color = color(190, 190, 0);
        this.m_vel = new p5.Vector(0, 0);
        this.m_velZ = 2;
        this.m_inside = false;
        this.m_firstHit = true;
        this.m_currentMaxHeight = BALL_MAX_HEIGHT;
        this.m_currentHeight = 0;
        this.m_kickCount = 0;
        this.serveKickDuration = 0.6;
        this.elapsedTime = 0;
        this.m_state = BALL_STATES.SERVE;
    }
    update(g, c, n) {
        if (g.shouldStartServing()) {
            this.kickBallAnimation();
        } else if (g.isServing()) {
            if (
                this.m_state != BALL_STATES.THROWING &&
                this.m_state != BALL_STATES.SERVING
            ) {
                this.simulateThrow(); // This makes the ball Z thrust up and start our game going
            } else if (this.m_state == BALL_STATES.SERVING) {
                g.endServing();
            } else {
                this.simulateHeight2();
            }
        } else if (g.isInGame()) {
            this.simulateHeight();
            this.m_y += this.m_vel.y * getDeltaTime();
            this.m_x += this.m_vel.x * getDeltaTime();
            this.checkCourt(c);
            this.checkNet(n);
            this.setBallSide(n);
            this.checkOutOfBounds();
        }
    } // GERAL LOGIC UPDATE FUNCTIONS ==================================================
    kickBallAnimation() {
        let t = this.elapsedTime / this.serveKickDuration;
        if (t <= BALL_ANIMATION_KICK_UP) {
            this.m_currentHeight =
                this.m_currentHeight +
                (BALL_ANIMATION_END_OFFSET_Y - this.m_currentHeight) * (t * t);
        } else if (t > BALL_ANIMATION_KICK_DOWN) {
            this.m_currentHeight = 0 + this.m_currentHeight * (1 - t * t * t);
        }
        if (t >= 1.0) {
            this.elapsedTime = 0;
        }
        this.elapsedTime += getDeltaTime();
        let p = this.m_lastHit;
        this.m_x = p.getRacketX();
        this.m_y = p.getPosY() + 20;
    }
    simulateThrow() {
        this.m_velZ = 116; // MAGIC NUMBER
        this.m_state = BALL_STATES.THROWING;
    }
    simulateHeight() {
        this.m_velZ -= GRAVITY * getDeltaTime();
        this.m_currentHeight += this.m_velZ * getDeltaTime(); // We to low, we should stop
        // Probably m_currentMaxHeight never going down to 1
        // With small numbers of BALL_MAX_KICKS
        if (
            this.m_currentMaxHeight <= 1 ||
            this.m_kickCount >= BALL_MAX_KICKS
        ) {
            this.m_state = BALL_STATES.STOPPED;
            this.m_kickCount = 0;
            return;
        }
        if (this.m_currentHeight <= 0) {
            this.m_firstHit = false;
            this.m_currentHeight = 0;
            this.m_currentMaxHeight =
                this.m_currentMaxHeight * BALL_MAXHEIGHT_DECREASE_PERCENTAGE;
            this.m_velZ = -this.m_velZ * BALL_Z_DECREASE_PERCENTAGE;
            this.m_kickCount += 1;
        } else if (this.m_currentHeight >= this.m_currentMaxHeight) {
            this.m_currentHeight = this.m_currentMaxHeight;
        } else if (this.m_state == BALL_STATES.THROWING && this.m_velZ <= 0) {
            this.m_state = BALL_STATES.SERVING;
        }
    }
    simulateHeight2() {
        this.m_velZ -= GRAVITY * getDeltaTime();
        this.m_currentHeight += this.m_velZ * getDeltaTime();
        if (this.m_state == BALL_STATES.THROWING && this.m_velZ <= 0) {
            this.m_state = BALL_STATES.SERVING;
        }
    } // ===============================================================================
    draw() {
        // Getting a percentage of the distance between ball current fake height
        // and currentMaxHeight
        let shadowPercentage = 1 - this.m_currentHeight / BALL_MAX_HEIGHT;
        let shadowFullSize = this.m_diameter * SHADOW_FULL_PERCENTAGE;
        let shadowSize = shadowFullSize * shadowPercentage; // Increase ball with higher heights. Max is 1 + Minimum Percentage multiply
        // by ball diameter
        let ballIncreasePercentage =
            BALL_MINIMUM_PERCENTAGE + this.m_currentHeight / BALL_MAX_HEIGHT;
        let ballFullSize = this.m_diameter;
        let ballSize = ballFullSize * ballIncreasePercentage; // Drawing shadow first so it go behind the ball fill(140);
        pushStyle();
        noStroke();
        fill(
            20,
            20,
            20,
            (1 -
                this.m_currentHeight /
                    (BALL_MAX_HEIGHT + BALL_ANIMATION_MAX_HEIGHT)) *
                255
        );
        circle(this.m_x, this.m_y + shadowSize / 2, shadowSize); // Drawing the ball
        fill(this.m_color);
        circle(this.m_x, this.m_y - this.m_currentHeight, ballSize);
        popStyle(); // Debug ball information
        if (getDebug()) {
            this.debug(550, 0);
        }
    } // We need to get our circle correct dimensions to check out of window
    // collision.
    checkOutOfBounds() {
        let ballPos = this.getBallPosition();
        let check = this.getBallDiameter() / 2;
        if (ballPos.y + check > height) {
            this.setBallPosition(this.m_x, height - check);
            this.m_vel.y *= -1;
            this.m_kickCount += 1;
        }
        if (ballPos.y - check < 0) {
            this.setBallPosition(this.m_x, check);
            this.m_vel.y *= -1;
            this.m_kickCount += 1;
        }
        if (ballPos.x > width - check) {
            this.m_x = width - check;
            this.m_vel.x *= -1;
            this.m_kickCount += 1;
        }
        if (ballPos.x - check < 0) {
            this.m_x = check;
            this.m_vel.x *= -1;
            this.m_kickCount += 1;
        }
    }
    checkNet(n) {
        if (
            n.getZ() >= this.m_currentHeight &&
            this.m_state == BALL_STATES.PLAYING
        ) {
            let radius = this.getBallDiameter() / 2;
            if (
                !CollisionCR(
                    this.m_x,
                    this.m_y,
                    radius,
                    n.getPosX(),
                    n.getPosY() - n.getHeight(),
                    n.getWidth(),
                    n.getHeight()
                )
            ) {
                return;
            } else {
                this.m_currentHeight = 0;
                this.m_y = n.getPosY();
                this.m_currentMaxHeight = 0.1;
                this.m_state = BALL_STATES.STOPPED;
            }
        }
    }
    checkCourt(c) {
        let pos = this.getBallPosition();
        if (
            !CollisionPTrapeze(pos.x, pos.y, c.getAngle(), c.getVertices()) &&
            this.m_currentHeight == 0
        ) {
            if (this.m_state == BALL_STATES.PLAYING) {
                this.m_state = BALL_STATES.OUT;
                this.m_inside = false;
            }
        } else if (
            CollisionPTrapeze(pos.x, pos.y, c.getAngle(), c.getVertices()) &&
            this.m_currentHeight == 0
        ) {
            this.m_inside = true;
            if (
                this.m_lastHit.getSide() == this.m_side &&
                this.m_state == BALL_STATES.PLAYING
            ) {
                this.m_state = BALL_STATES.STOPPED;
            }
        }
    } // SOME GETTERS AND SETTERS ======================================================
    setPos(x, y) {
        this.m_x = x;
        this.m_y = y;
    }
    getCurrentMaxHeight() {
        return this.m_currentMaxHeight;
    }
    getCurrentHeight() {
        return this.m_currentHeight;
    }
    getState() {
        return this.m_state;
    }
    getMaxHeight() {
        return BALL_MAX_HEIGHT;
    }
    setCurrentHeight(c) {
        this.m_currentHeight = c;
    }
    setCurrentMaxHeight(c) {
        this.m_currentMaxHeight = c;
    }
    setState(state) {
        this.m_state = state;
    }
    getVel() {
        return this.m_vel.copy();
    }
    setVel(x, y) {
        this.m_vel.x = x;
        this.m_vel.y = y;
    }
    getVelZ() {
        return this.m_velZ;
    }
    setVelZ(c) {
        this.m_velZ = c;
    }
    getKickCount() {
        return this.m_kickCount;
    }
    setKickCount(i) {
        this.m_kickCount = i;
    }
    getLastHit() {
        return this.m_lastHit;
    }
    setLastHit(p) {
        this.m_lastHit = p;
    }
    setBallSide(n) {
        if (this.m_side == 1) {
            if (this.m_y + this.getBallDiameter() / 2 > n.getPosY()) {
                this.m_side = 2;
            }
        } else {
            if (this.m_y < n.getPosY() - n.getHeight()) {
                this.m_side = 1;
            }
        }
    }
    getSide() {
        return this.m_side;
    } // ==========================================================================
    // Helpers =================================================================
    isInside() {
        return this.m_inside;
    }
    getBallPosition() {
        return new p5.Vector(this.m_x, this.m_y - this.m_currentHeight);
    }
    setBallPosition(x, y) {
        this.m_x = x;
        this.m_y = y + this.m_currentHeight;
    }
    setShadowPosition(x, y) {
        this.m_x = x;
        this.m_y = y;
    }
    getBallDiameter() {
        let check =
            this.m_diameter * BALL_MINIMUM_PERCENTAGE +
            this.m_currentHeight / BALL_MAX_HEIGHT;
        return check;
    }
    getShadowDiameter() {
        let shadowPercentage = 1 - this.m_currentHeight / BALL_MAX_HEIGHT;
        let check = this.m_diameter * SHADOW_FULL_PERCENTAGE * shadowPercentage;
        return check;
    }
    hasEnd() {
        return (
            this.m_state == BALL_STATES.OUT ||
            this.m_state == BALL_STATES.STOPPED
        );
    }
    isInGame() {
        return this.m_state == BALL_STATES.PLAYING;
    }
    isServing() {
        return this.m_state == BALL_STATES.SERVING;
    }
    isFirstHit() {
        return this.m_firstHit;
    }
    startServe() {
        this.init(0, 640, 15);
    }
    debug(atX, atY) {
        pushStyle();
        fill(0, 255, 0);
        text(
            "Ball Position: " +
                this.m_x +
                "," +
                (this.m_y - this.m_currentHeight),
            atX,
            atY + 15
        );
        text("MaxCurrentHeight: " + this.m_currentMaxHeight, atX, atY + 30);
        text("Z height: " + this.m_currentHeight, atX, atY + 45);
        text("Vel Z: " + this.m_velZ, atX, atY + 60);
        text("Ball Radius: " + this.getBallDiameter() / 2, atX, atY + 75);
        text("Ball state: " + this.m_state, atX, atY + 90);
        text("KickCount: " + this.m_kickCount, atX, atY + 105);
        text("Side: " + this.m_side, atX, atY + 120);
        text("LastHit: " + this.m_lastHit, atX, atY + 135);
        popStyle();
    }
}

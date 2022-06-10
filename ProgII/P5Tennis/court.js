class Vector {
    m_x;
    m_y;
    constructor(x, y) {
        this.m_x = x;
        this.m_y = y;
    }
}
class Court {
    m_vertices;
    m_net;
    m_angle;
    constructor() {
        // Creating Vertices Vector
        this.m_angle = 20;
        this.m_vertices = new Array(4);
        let courtHeight = 0.6 * height;
        let offsetX = tan(radians(this.m_angle)) * courtHeight; // Setting Vertices Vector points;
        this.m_vertices[0] = new Vector(0.1 * width, 0.8 * height);
        this.m_vertices[1] = new Vector(
            this.m_vertices[0].m_x + offsetX,
            0.2 * height
        );
        this.m_vertices[3] = new Vector(0.9 * width, 0.8 * height);
        this.m_vertices[2] = new Vector(
            this.m_vertices[3].m_x - offsetX,
            0.2 * height
        ); // Creating Net Object
        this.m_net = new Net(); // Setting Net Size and Positioning
        this.m_net.setPos(
            (this.m_vertices[0].m_x + this.m_vertices[1].m_x) / 2,
            (this.m_vertices[0].m_y + this.m_vertices[1].m_y) / 2
        );
        this.m_net.setSize(
            (this.m_vertices[2].m_x + this.m_vertices[3].m_x) / 2 -
                this.m_net.getPosX(),
            40
        );
    }
    draw() {
        fill(0, 0, 70);
        stroke(190);
        beginShape();
        for (let i = 0; i < 4; i++) {
            vertex(this.m_vertices[i].m_x, this.m_vertices[i].m_y);
        }
        endShape(CLOSE);
        noStroke();
    }
    drawNet() {
        this.m_net.draw();
    }
    getNet() {
        return this.m_net;
    }
    getVertices() {
        return this.m_vertices;
    }
    getAngle() {
        return this.m_angle;
    }
}

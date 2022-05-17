
class Court{
  Vector[]  m_vertices;
  Net       m_net;

  class Vector{
    float m_x;
    float m_y;

    Vector(float x, float y){
      m_x = x;
      m_y = y;
    }
  }

  Court(){
    // Creating Vertices Vector
    m_vertices = new Vector[4];
    float courtHeight = 0.6 * height;
    float offsetX = tan(radians(20)) * courtHeight;

    // Setting Vertices Vector points;
    m_vertices[0] = new Vector(0.1 * width, 0.8 * height);
    m_vertices[1] = new Vector(m_vertices[0].m_x + offsetX, 0.2 * height);
    m_vertices[3] = new Vector(0.9 * width, 0.8 * height);
    m_vertices[2] = new Vector(m_vertices[3].m_x - offsetX, 0.2 * height);

    // Creating Net Object
    m_net = new Net();

    // Setting Net Size and Positioning
    m_net.setPos((m_vertices[0].m_x + m_vertices[1].m_x)/2, (m_vertices[0].m_y + m_vertices[1].m_y)/2 );
    m_net.setSize((m_vertices[2].m_x + m_vertices[3].m_x)/2 - m_net.getPosX(), 40);
  }

  void draw(){
    fill(0,0,70);
    stroke(190);
    beginShape();
    for (int i = 0; i < 4; i++){
      vertex(m_vertices[i].m_x, m_vertices[i].m_y);
    }
    endShape(CLOSE);
    noStroke();

  }
  void drawNet(){
    m_net.draw();
  }

  Net getNet(){
    return m_net;
  }
}

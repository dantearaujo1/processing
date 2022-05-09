
class Court{
  Vector[] m_vertices;

  class Vector{
    float m_x;
    float m_y;

    Vector(float x, float y){
      m_x = x;
      m_y = y;
    }
  }

  Court(){
    m_vertices = new Vector[4];
    float courtHeight = 0.6 * height;
    float offsetX = tan(radians(20)) * courtHeight;
    m_vertices[0] = new Vector(0.1 * width, 0.8 * height);
    m_vertices[1] = new Vector(m_vertices[0].m_x + offsetX, 0.2 * height);
    m_vertices[3] = new Vector(0.9 * width, 0.8 * height);
    m_vertices[2] = new Vector(m_vertices[3].m_x - offsetX, 0.2 * height);
  }

  void draw(){
    beginShape();
    for (int i = 0; i < 4; i++){
      vertex(m_vertices[i].m_x, m_vertices[i].m_y);
      fill(255,0,0);
      if(i == 0 || i == 3){
        text(m_vertices[i].m_x + "," + m_vertices[i].m_y, m_vertices[i].m_x, m_vertices[i].m_y + 20);
      }
      else{
        text(m_vertices[i].m_x + "," + m_vertices[i].m_y, m_vertices[i].m_x, m_vertices[i].m_y);

      }
    }
    endShape();

    stroke(255);
    line(80,0,80, 800);
    line(10,0,10, 800);
    line(720,0,720, 800);
    line(780,0,780, 800);

  }
  void update(){

  }
}

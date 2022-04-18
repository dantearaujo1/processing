// Setting global variables
PImage img;
PGraphics viewport;
boolean worked = false;
boolean colorSelector = false;
boolean debug = false;
ArrayList<PVector> vertices = new ArrayList<PVector>();
ArrayList<PVector> points = new ArrayList<PVector>();
IntList colors = new IntList();
int menuHeight = 100;
int fontHeight = 18;
int circleDiameter = 300;
int Luminosity = 300;
int luminosityRange = 300;
int saturationRange = 150;
float offsetx;
float offsety;
float Saturation;
float Matiz;
color usedColor = color(255,255,255);


void setup() {
  surface.setTitle("Ferramenta do Dante");
  surface.setResizable(true);
  // FileBrowser to open a file
  selectInput("Select a file to process:", "fileSelected");
  // Creating the viewport that will render colorSelector
  viewport = createGraphics(300,300);
}

void draw(){
  if(worked && colorSelector == false){
    // Creating the menu bar
    background(0);
    noStroke();
    colorMode(RGB,255,255,255);
    fill(0,0,0);
    rect(0,0,width,menuHeight);
    // Creating rect representing the selected color in HSB
    colorMode(HSB,TWO_PI,saturationRange,luminosityRange);
    fill(usedColor);
    rect(20, menuHeight/4, 50, 50);

    // Drawing the selected image
    image(img, (width - img.width)/2, menuHeight);
    // Printing to the screen mouse coordinates
    colorMode(RGB,255,255,255);
    fill(255,255,255);
    textSize(fontHeight);
    text("X: " + str(mouseX - width/2 + img.width/2), 100, menuHeight/2 - fontHeight/2);
    text("Y: " + str(mouseY - menuHeight), 100, menuHeight/2 + fontHeight/2);
    if(debug){
      // Printing to the screen quantity of vertices and Triangles
      text("Points: " + str(vertices.size()), 190, menuHeight/2 - fontHeight/2);
      text("Triangles: " + str(vertices.size()/3), 190, menuHeight/2 + fontHeight/2);
    }

    // This variables are for offsetting the stored PVectors for vertices
    offsetx = width/2 - img.width/2;
    offsety = menuHeight;
    // Here we are creating points and drawing triangles when we can close them
    noStroke();
    colorMode(HSB,TWO_PI,saturationRange,luminosityRange);
    for (int i = 0; i < vertices.size();i++){
      // Creating triangles
      if ((i+1) >= 3 && (i+1) % 3 == 0){
        // Setting the color for the triangle stored in colors arrayList
        fill(colors.get((i+1)/3 - 1));
        // Creating the triangle with vertices stored in vertices arrayList
        triangle(vertices.get(i-2).x + offsetx,vertices.get(i-2).y + offsety,vertices.get(i-1).x + offsetx,vertices.get(i-1).y + offsety,vertices.get(i).x + offsetx,vertices.get(i).y + offsety);

        // Rendering the order of triangles in the centroid
        PVector center = getCentroid(vertices.get(i-2).x + offsetx,vertices.get(i-2).y + offsety,vertices.get(i-1).x + offsetx,vertices.get(i-1).y + offsety,vertices.get(i).x + offsetx,vertices.get(i).y + offsety);
        textSize(fontHeight/2);
        fill(0,0,0);
        text(str((i+1)/3), center.x, center.y);
        fill(255,255,255);
      }
    }
    // Points are shown with stroke -- after the triangles to actually we see the points
    for (int i = 0; i < points.size();i++){
      stroke(0xFF00FFFF);
      strokeWeight(4);
      point(points.get(i).x + offsetx,points.get(i).y + offsety);
      noStroke();
    }
  }
  // Enabling colorSelector "View"
  if(colorSelector){
    // Filling the background with black to make look like it changed
    background(0);
    noStroke();
    // Creating menubar again
    fill(0,0,0);
    rect(0,0,img.width,menuHeight);
    // Creating a rect representing the selected color
    colorMode(HSB, TWO_PI, saturationRange,luminosityRange);
    fill(usedColor);
    rect(25,menuHeight/4,50,50);
    // Creating a line representing the luminosity bar
    colorMode(RGB,255,255,255);
    stroke(255,255,255);
    line(100, menuHeight/4, 100 + luminosityRange,menuHeight/4);
    // Creating a simple visual slider
    fill(200,200,200);
    rectMode(CENTER);
    rect(100 + Luminosity, menuHeight/4, 5, 5);
    rectMode(CORNER);
    noStroke();

    // Creating visual output for values
    fill(255,255,255);
    textSize(fontHeight);
    text("Luminosity: " + str(Luminosity),200,menuHeight/4-fontHeight/2);
    text("Saturation: " + str(Saturation),260,menuHeight/2 + fontHeight);
    if(!debug){
      text("Matiz: " + str(degrees(Matiz)),100, menuHeight/2 + fontHeight);
    }
    noStroke();

    // Creating a colorSelector to store as a triangle background;
    viewport.beginDraw();
    viewport.colorMode(HSB, TWO_PI, saturationRange,luminosityRange);

    for(int x=0; x < circleDiameter; x++){
      for(int y=0; y < circleDiameter; y++){

        float tempSaturation = dist(x,y,saturationRange,saturationRange);

        if(tempSaturation <= saturationRange){
          float tempMatiz = atan2(saturationRange-y,saturationRange-x)+PI;
          viewport.stroke(tempMatiz, tempSaturation, Luminosity);
          viewport.point(x,y);
        }

      }

    }
    viewport.endDraw();
    // Blitting image in the window
    imageMode(CENTER);
    image(viewport,width/2, menuHeight + (height - menuHeight)/2);
    imageMode(CORNER);

    // Code to debug center of colorSelector distance to the mouse
    if(debug){
      if(dist(mouseX,mouseY,width/2, (height-menuHeight)/2 + menuHeight)<150){
        float cx =  width/2;
        float cy =  menuHeight + (height - menuHeight)/2;
        float dx = mouseX - cx;
        float dy = mouseY - cy;
        float dMatiz = atan2(-dy,-dx)+PI;
        text("Matiz: " + str(degrees(dMatiz)),100, menuHeight/2 + fontHeight);
        stroke(0);
        strokeWeight(2);
        /* line(mouseX,mouseY,width/2, (height-menuHeight)/2 + menuHeight); */
        line(mouseX,mouseY,cx, cy);
        noStroke();
      }
    }
  }
}

void mousePressed(){
  // Adding vector and colors vector
  if(mouseButton == LEFT && colorSelector == false){
    PVector temp = new PVector(mouseX - width/2 + img.width/2 ,mouseY - menuHeight);
    vertices.add(temp);
    points.add(temp);
    if (vertices.size() % 3 == 0){
      colorMode(HSB,TWO_PI,saturationRange,luminosityRange);
      color tempColor = usedColor;
      colors.append(tempColor);
    }
  }
  // Removing vertices and colors from vectors
  if(mouseButton == RIGHT && colorSelector == false){
    if(vertices.size() % 3 == 0){
      colors.remove(colors.size()-1);
    }
    vertices.remove(vertices.size()-1);
    points.remove(points.size()-1);
  }
  // changingState
  if(mouseButton == CENTER){
    colorSelector = !colorSelector;
  }
  if(mouseButton == LEFT && colorSelector == true){
    // Selecting matiz and saturation color from the colorSelector
    if(dist(mouseX,mouseY,width/2, (height-menuHeight)/2 + menuHeight) <= saturationRange){
      float cx =  width/2;
      float cy =  menuHeight + (height - menuHeight)/2;
      float dx = cx - mouseX;
      float dy = cy - mouseY;
      Saturation = floor(dist(mouseX,mouseY, width/2, (height-menuHeight)/2 + menuHeight));
      Matiz = atan2(dy,dx)+PI;
      colorMode(HSB,TWO_PI,saturationRange,luminosityRange);
      usedColor = color(Matiz,Saturation,Luminosity);
    }
  }
}

void mouseDragged(){
  if(colorSelector){
    if(mouseY <= menuHeight/4+10 && mouseY >= menuHeight/4-10){
      Luminosity = constrain((mouseX-100),0,300);
    }
  }
}

void keyPressed(){
  if(key == 'b'){
    debug = !debug;
  }
  if(key == 'p'){
    saveData();
  }
  if(key == 'e'){
    colorSelector = !colorSelector;
  }
}

void fileSelected(File selection){
  if (selection == null){
    /* println("Window was closed or the user hit cancel."); */
    worked = false;
  } else {
    String path = selection.getAbsolutePath();/* println ("User selected" + selection.getAbsolutePath()); */
    img = loadImage(path);
    worked = true;
    int tempWidth = img.width;
    int tempHeight = img.height;
    if (tempWidth <= 410){
      tempWidth = 410;
      if(tempHeight <= 300){
        tempHeight = 300;
      }
    }
    surface.setSize(tempWidth, menuHeight + tempHeight);
  }
}

PVector getCentroid(float x1, float y1, float x2, float y2, float x3, float y3){
  float xc = (x1 + x2 + x3)/3;
  float yc = (y1 + y2 + y3)/3;
  return new PVector(xc,yc);
}

void saveData(){
  PrintWriter output = createWriter("triangulos.txt");
  colorMode(HSB,TWO_PI,150,300);
  output.println("// COLORMODE");
  output.println("colorMode(HSB,TWO_PI,150,300);");
  int triangulo = 0;
  for (int i = 0; i < vertices.size(); i++){
    if((i+1)%3 == 0){
      triangulo++;
      output.println("// [Triangulo]: " + str(triangulo));
      output.println("// -- Cor --");
      output.println("fill(" + str(hue(colors.get(triangulo-1))) + ", " + str(saturation(colors.get(triangulo-1))) + ", " + str(brightness(colors.get(triangulo-1))) + ");");
      output.println("// -- Vertices do triangulo --");
      output.println("triangle(" + str(vertices.get(i-2).x) + ", " + str(vertices.get(i-2).y) + ", " + str(vertices.get(i-1).x) + ", " + str(vertices.get(i-1).y) + ", " + str(vertices.get(i).x) + ", " + str(vertices.get(i).y) + ");");
    }
  }
  output.flush();
  output.close();
}

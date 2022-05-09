float rectWidth;
int nKeys;
int[] vector;


void setup(){
  size(800,800);
  setupAlgorithm(400);
}

void draw(){
  background(0);
  for ( int i = 0; i < nKeys; i++){
    int value = vector[i];
    fill(255);
    rect(i * rectWidth, height - value, rectWidth, value);
  }
}

void setupAlgorithm(int quantity){
  rectWidth = width/quantity;
  nKeys = quantity;
  vector = new int[quantity];
  for (int i = 0; i < quantity; i++){
    vector[i] = int(random(100,quantity*2));
  }
}

void insertion_sort(int[] vector, int n){
  for (int i = 1; i < n; i++){
    int value = vector[i];
    int j = i - 1;
    while (j >= 0 &&  vector[j] > value){
      vector[j+1] = vector[j];
      j -= 1;
    }
    vector[j + 1] = value;

  }
}

void keyReleased(){
  if(key == ' '){
    insertion_sort(vector,nKeys);
    for (int i = 0; i < nKeys; i++){
      print(vector[i] + ",");
    }
    println();
  }
}



// Bandeira da Suiça

void setup(){
  size(800,800);
}

void draw(){
  background(0);
  bandeira(mouseX);
}

void bandeira(float largura){
 float modulo = largura/5.33; 
 float modulo2 = modulo + modulo/6.0;
 float altura = largura;  
 
 fill(255,0,0);
 noStroke();
 rect(0,0,largura,altura);
  
 fill(255);
 
 
 rect(modulo, modulo + modulo2, 2 * modulo2 + modulo, modulo);
 rect(modulo + modulo2, modulo, modulo, 2 * modulo2 + modulo);
 

}

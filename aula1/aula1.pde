int width = 640;
int height = 640;
int background = 255;
int brushcolor = 0;

void setup(){
}
void settings(){
  size(width,height); // Tamanho da Tela

}

void draw(){
  background(background); // Cor do Plano de Fundo
  noStroke();
  fill(brushcolor);
  triangle(0,height/2,width/2,0,width/2,height/2);
  triangle(width/2,0,width,0,width,height/2);
  triangle(0,height/2,0,height,width/2,height);
  triangle(width/2,height/2,width,height/2,width/2,height);

}
 	// cmd:               C:\Program Files\OpenJDK\openjdk-8u275-b01\bin\java.exe -Declipse.application=org.eclipse.jdt.ls.core.id1 -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product -Dlog.protocol=true -Dlog.level=ALL -Xms1g -Xmx2G -jar D:\Code\Configurations\nvim\nvim-data\lsp_servers\jdtls\plugins\org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar -configuration D:\Code\Configurations\nvim\nvim-data\lsp_servers\jdtls\config_windows -data D:\Code\Configurations\\workspace --add-modules=ALL-SYSTEM --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED

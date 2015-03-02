
My3DBox input3DBox;
My3DPoint eye;
float scaleFactor = 1.0;
float rotateX = 0.0;
float rotateY = 0.0;

void setup() {
  size(1000,800, P2D);
  eye = new My3DPoint(0, 0, -5000);
  //noLoop();
  //frameRate(1);
}

  
void draw() {

  background(255.0, 255.0, 255.0);
  
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  input3DBox = new My3DBox(origin, 100, 150, 300);
  
  // scaling
  float[][] scaleMatrix = overallScaleMatrix(scaleFactor);
  input3DBox = transformBox(input3DBox, scaleMatrix);
  
  // rotation around X axis
  float[][] rotateXMatrix = rotateXMatrix(rotateX);
  input3DBox = transformBox(input3DBox, rotateXMatrix);
  
  // rotation around Y axis
  float[][] rotateYMatrix = rotateYMatrix(rotateY);
  input3DBox = transformBox(input3DBox, rotateYMatrix);
  
  projectBox(eye, input3DBox).render();
 
}

void mouseDragged() {
  float diffMouseY = mouseY - pmouseY;
  if(diffMouseY < 0) {
    scaleFactor -= 0.1;
  } else if (diffMouseY > 0) {
    scaleFactor += 0.1;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      rotateX -= 0.1;
    } else if (keyCode == DOWN) {
      rotateX += 0.1;
    } 
    else if (keyCode == LEFT) {
      rotateY += 0.1;
    } 
    else if (keyCode == RIGHT) {
      rotateY -= 0.1;
    } 
  } 
}


void printMatrix(float[][] matrix) {
 for (int i = 0; i < matrix.length ; ++i) {
   print("{");
    for (int j = 0; j < matrix[0].length ; ++j ) {
       print(matrix[i][j]);
       if (j < matrix[0].length - 1) print(", ");  
    }
    print("}");
    println();
 } 
}

float[][] multiplyMatrix(float[][] matrixA, float[][] matrixB) {
  
  int n = matrixA.length;
  int m = matrixA[0].length;
  int p = matrixB[0].length;
  
  if (m != matrixB.length) {
    println("[multiplyMatrix] input matrix dimensions are wrong");
    return new float[0][0];
  }
  
  float[][] matrixC = new float[n][p];
  
  for (int i = 0; i < matrixA.length ; ++i) {
    for (int j = 0; j < matrixB[0].length ; ++j ) {
      for (int k = 0; k < matrixA[0].length; ++k) {
        matrixC[i][j] = matrixC[i][j] + matrixA[i][k] * matrixB[k][j];
      }
    }
  } 
  
  return matrixC;
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
    float[][]  T = { {1, 0, 0 , -eye.x},
                     {0, 1, 0 , -eye.y},
                     {0, 0, 1 , -eye.z},
                     {0, 0, 0 , 1}
                   };
    
    float[][]  P = { {1, 0, 0 , 0},
                     {0, 1, 0 , 0},
                     {0, 0, 1 , 0},
                     {0, 0, -1/eye.z , 0}
                   };
                 
    if(false) {              
      float[][] PT = multiplyMatrix(P, T);
      float[][] point = {{p.x}, {p.y}, {p.z}, {1}};
      float[][] projectedPoint = multiplyMatrix(PT, point);
      
      printMatrix(projectedPoint);
      
      float w = (-p.z / eye.z) + 1;
      
      float x  = projectedPoint[0][0] / w;
      float y  = projectedPoint[1][0] / w;
      
      return new My2DPoint(x, y);   
      
    } else {
       
      float w = (-p.z / eye.z) + 1;
      
      float x  = (p.x - eye.x) / w;
      float y  = (p.y - eye.y) / w;
      
      return new My2DPoint(x, y);   
      
    }
    
                
}



My2DBox projectBox(My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[box.p.length];
 
  for (int i = 0; i < box.p.length; ++i) {
     s[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(s);
}

float[] homogeneous3DPoint(My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0, 0, 0},
                        {0, cos(angle), sin(angle), 0},
                        {0, -sin(angle), cos(angle), 0},
                        {0, 0, 0, 1}});  
}

float[][] rotateYMatrix(float angle) {
 return(new float[][] {{cos(angle), 0, -sin(angle), 0},
                        {0, 1, 0, 0},
                        {sin(angle), 0, cos(angle), 0},
                        {0, 0, 0, 1}});     
}

float[][] rotateZMatrix(float angle) {
 return(new float[][] {{cos(angle), -sin(angle), 0, 0},
                        {sin(angle), cos(angle), 0, 0},
                        {0, 0, 1, 0},
                        {0, 0, 0, 1}});     
}

float[][] overallScaleMatrix(float scaleFactor) {
  return(new float[][] {{scaleFactor, 0, 0, 0},
                        {0, scaleFactor, 0, 0},
                        {0, 0, scaleFactor, 0},
                        {0, 0, 0, 1}});       
}

float[][] localScaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}});       
}

float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0, x},
                        {0, 1, 0, y},
                        {0, 0, 1, z},
                        {0, 0, 0, 1}});    
}

float[] matrixProduct(float[][] a, float[] b) {
  
  if (a.length != 4 || a[0].length != 4 || b.length != 4) {
     println("[matrixProduct] input matrix dimensions are wrong");
     return new float[0]; 
  }
  
  float[] matrixProduct = new float[a.length];
  for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j  ) {
        matrixProduct[i] += a[i][j] * b[j];
      }
   }
   
  return matrixProduct;
}


My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] transformedPoints = new My3DPoint[box.p.length];
  for (int i = 0; i < box.p.length; ++i) {
    float[] point = homogeneous3DPoint(box.p[i]);
    My3DPoint my3Dpoint = euclidian3DPoint( matrixProduct(transformMatrix, point) );
    transformedPoints[i] = my3Dpoint;
  }
  
  return new My3DBox(transformedPoints);
}

My3DPoint euclidian3DPoint(float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

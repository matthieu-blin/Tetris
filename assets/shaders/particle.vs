#version 330 core
layout (location = 0) in vec2 squareVertices;
layout (location = 1) in vec4 xywh; 
layout (location = 2) in float angle; 
layout (location = 3) in vec4 color; 
layout (location = 4) in vec4 tex; 
const float PI = 3.14159265359;
out vec2 UV;
out vec4 particlecolor;


mat2 rotationMatrix(float angle)
{
	angle *= PI / 180.0;
    float s=sin(angle), c=cos(angle);
    return mat2( c,-s, s, c );
}

void main()
{
	vec2 vpos = xywh.xy + vec2( squareVertices.xy * rotationMatrix(angle))  *  xywh.zw ;

	// Output position of the vertex
    gl_Position = vec4(vpos, 0.0, 1.0);

	//vertex from {-0.5,-0.5}->{0.5,0.5} to tex coordinate {0,0}->{1,1}
	UV = squareVertices.xy ;
	UV += vec2(0.5, 0.5) ;
	//in case of atlas use w ratio and h ratio
	UV.x *= tex.z;
	UV.y *= tex.w;
	//add offset 
	UV += tex.xy ;


	particlecolor = color;
}
// Interpolated values from the vertex shaders
in vec2 UV;
in vec4 particlecolor;

// Ouput data
out vec4 color;

uniform sampler2D tx;
uniform bool wireframe;

void main(){
    if(wireframe)
         color = vec4(0.2f, 1.0f, 0.2f, 1.0f);
    else
        // Output color = color of the texture at the specified UV
        color = texture( tx, UV )  * particlecolor;

}
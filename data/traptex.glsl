
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform float c1;
uniform float c2;
uniform float time;
uniform int calibrate;

varying vec4 vertColor;
varying vec4 vertTexCoord;

vec3 getTex(vec2 p)
{
     p *=0.7;
     p += vec2(0.5);
     vec3 col = texture2D(texture, p).rgb;
     // float mag = dot(col,vec3(.21, .72, .07));
     // mag = floor(mag*16.)/16.;
     //col *= mag > .3 ? 1. : 0.;
     return col;
     //return vec4(vec3(mag),1.);
}

float mask(vec2 p)
{
     //float ex = .5;
     //return length(p) < ex;
     //return getTex(p).x != 0. && length(p) < .5;
     p *= vec2(3.0,1.);
     return smoothstep(0.45, 0.40, length(p));
     // return length(p) < .5 ? 1.0 : 0.0;
}

mat2 rotate(float a){
     return mat2(cos(a), -sin(a), sin(a), cos(a));
}

vec3 trapCoord(vec2 p)
{
     vec3 acc = vec3(0.0);
     float alpha = 0.0;
     vec2 offset = vec2(0.);
     vec2 z = p;
     for (int i = 0; i < 50; i++)
     {
          float r = z.x * z.x - z.y * z.y + c1;
          float j = 2. * z.x * z.y - c2;
          z.x = r;
          z.y = j;
          vec2 look = rotate(time)*z;
          if(mask(look) != 0.0 && i >= 0) {
               float bias = (1.0 - alpha) * mask(look);
               alpha += bias;
               acc += getTex(look) * bias;
          }
     }
     return acc;
}

void main() {
     vec2 p = vertTexCoord.st;
     p *=2.;
     p -= vec2(1.);
     p *= 1.0;
     vec3 col;
     if(calibrate == 0){
          col = trapCoord(p);
     }
     else{
          col = getTex(p*vec2(-1.0,1.0))*mask(p);
     }
     gl_FragColor = vec4(col, 1);
}


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform float c1;
uniform float c2;

varying vec4 vertColor;
varying vec4 vertTexCoord;

vec4 getTex(vec2 p)
{
        p *=0.7;
        p += vec2(0.5);
        vec3 col = texture2D(texture, p).rgb;
        // float mag = dot(col,vec3(.21, .72, .07));
        // mag = floor(mag*16.)/16.;
//col *= mag > .3 ? 1. : 0.;
        return vec4(col,1.);
//return vec4(vec3(mag),1.);
}

bool isInside(vec2 p)
{
//float ex = .5;
//return length(p) < ex;
//return getTex(p).x != 0. && length(p) < .5;
        p *= vec2(3.0,1.);
        return length(p) < .5;
}

vec4 trapCoord(vec2 p)
{
        float found = 0.;
        vec2 offset = vec2(0.);
        vec2 z = p;
        int index = 0;
        for (int i = 0; i < 50; i++)
        {
                float r = z.x * z.x - z.y * z.y + c1;
                float j = 2. * z.x * z.y - c2;
                z.x = r;
                z.y = j;
                if(isInside(z) && i >= 1) {
                        found = 1.;
                        index = i;
                        offset = z;
                        break;
                }
        }
        return vec4(found, offset, float(index));
}

void main() {
        vec2 p = vertTexCoord.ts;
        p *=2.;
        p -= vec2(1.);
        p *= 1.0;
        vec4 trap = trapCoord(p);
        vec3 col = getTex(trap.yz).xyz;
        col *= trap.x;
        float r = pow(1.1, trap.w);
        float g = pow(1., trap.w);
        float b = pow(1., trap.w);
        col *= vec3(r,g,b);
        gl_FragColor = vec4(col.xyz, 1);
}

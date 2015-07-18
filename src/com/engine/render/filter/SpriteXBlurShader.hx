package com.engine.render.filter;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import flash.geom.Matrix3D;
import com.engine.Game;

/**
 * ...
 * @author djoker
 */
class SpriteXBlurShader extends Shader
{

 
private var grayUniform:Dynamic;
private var _blur:Float;

	
public function new() 
{
	super();
	
	_blur = 1;

 var textureVertexShader=
"
attribute vec3 aVertexPosition;
attribute vec2 aTexCoord;
attribute vec4 aColor;

varying vec2 vTexCoord;
varying vec4 vColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
void main(void) 
{
vTexCoord = aTexCoord;
vColor = aColor;
gl_Position = uProjectionMatrix * uModelViewMatrix *  vec4 (aVertexPosition, 1.0);

}";


	
 var textureFragmentShader = 
 #if !desktop
"precision mediump float;" +
#end
  "     varying vec2 vTexCoord;
        varying vec4 vColor;
        uniform float blur;
        uniform sampler2D uImage0;

        void main(void) {
           vec4 sum = vec4(0.0);

           sum += texture2D(uImage0, vec2(vTexCoord.x - 4.0*blur, vTexCoord.y)) * 0.05;
           sum += texture2D(uImage0, vec2(vTexCoord.x - 3.0*blur, vTexCoord.y)) * 0.09;
           sum += texture2D(uImage0, vec2(vTexCoord.x - 2.0*blur, vTexCoord.y)) * 0.12;
           sum += texture2D(uImage0, vec2(vTexCoord.x - blur, vTexCoord.y)) * 0.15;
           sum += texture2D(uImage0, vec2(vTexCoord.x, vTexCoord.y)) * 0.16;
           sum += texture2D(uImage0, vec2(vTexCoord.x + blur, vTexCoord.y)) * 0.15;
           sum += texture2D(uImage0, vec2(vTexCoord.x + 2.0*blur, vTexCoord.y)) * 0.12;
           sum += texture2D(uImage0, vec2(vTexCoord.x + 3.0*blur, vTexCoord.y)) * 0.09;
           sum += texture2D(uImage0, vec2(vTexCoord.x + 4.0*blur, vTexCoord.y)) * 0.05;

           gl_FragColor = sum;
        }";

var vertexShader = GL.createShader (GL.VERTEX_SHADER);
GL.shaderSource (vertexShader, textureVertexShader);
GL.compileShader (vertexShader);
if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
{
throw (GL.getShaderInfoLog(vertexShader));
}

var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
GL.shaderSource (fragmentShader, textureFragmentShader);
GL.compileShader (fragmentShader);

if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {

 throw(GL.getShaderInfoLog(fragmentShader));

}

shaderProgram = GL.createProgram ();
GL.attachShader (shaderProgram, vertexShader);
GL.attachShader (shaderProgram, fragmentShader);
GL.linkProgram (shaderProgram);

if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) 
{
throw "Unable to initialize the shader program.";
}

vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
texCoordAttribute = GL.getAttribLocation (shaderProgram, "aTexCoord");
colorAttribute = GL.getAttribLocation (shaderProgram, "aColor");
projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");
imageUniform = GL.getUniformLocation (shaderProgram, "uImage0");
grayUniform= GL.getUniformLocation (shaderProgram, "blur");


 		
	}

	public var blur(get, set):Float;
	private function get_blur():Float { return _blur; }
	private function set_blur(value:Float):Float 
	{
		_blur = value;
		return value;
	}
	
	public override function Enable():Void
	{
	   super.Enable();
	   GL.enableVertexAttribArray (texCoordAttribute);
	   GL.uniform1f (grayUniform, _blur);
	}
	public override function Disable():Void
	{
       GL.disableVertexAttribArray (texCoordAttribute);
	   super.Disable();
	}
	
	
}
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
class SpriteSepiaShader extends Shader
{

 
private var grayUniform:Dynamic;
private var _gray:Float;

	
public function new() 
{
	super();
	
	_gray = 1;

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
  " 
        varying vec2 vTexCoord;
        varying vec4 vColor;
        uniform float sepia;
        uniform sampler2D uImage0;

        const mat3 sepiaMatrix = mat3(0.3588, 0.7044, 0.1368, 0.2990, 0.5870, 0.1140, 0.2392, 0.4696, 0.0912);

        void main(void) {
           gl_FragColor = texture2D(uImage0, vTexCoord);
           gl_FragColor.rgb = mix( gl_FragColor.rgb, gl_FragColor.rgb * sepiaMatrix, sepia);
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
grayUniform= GL.getUniformLocation (shaderProgram, "sepia");


 		
	}

	public var sepia(get, set):Float;
	private function get_sepia():Float { return _gray; }
	private function set_sepia(value:Float):Float 
	{
		_gray = value;
		return value;
	}
	
	public override function Enable():Void
	{
	   super.Enable();
	   GL.enableVertexAttribArray (texCoordAttribute);
	   GL.uniform1f (grayUniform, _gray);
	}
	public override function Disable():Void
	{
       GL.disableVertexAttribArray (texCoordAttribute);
	   super.Disable();
	}
	
	
}
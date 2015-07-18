package com.engine.render.filter;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;

import flash.geom.Matrix;
import flash.geom.Point;

import com.engine.render.filter.Filter;


/**
 * ...
 * @author djoker
 */
class PrimitiveShader extends Shader
{


	
	public function new() 
	{
    super();

	

 var colorVertexShader=
"
attribute vec3 aVertexPosition;
attribute vec4 aColor;

varying vec4 vColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
void main(void) 
{
vColor = aColor;
gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
}";


 var colorFragmentShader=

#if !desktop
"precision mediump float;" +
#end
"

varying vec4 vColor;
void main(void)
{
	gl_FragColor =  vColor;
}";


var vertexShader = GL.createShader (GL.VERTEX_SHADER);
GL.shaderSource (vertexShader, colorVertexShader);
GL.compileShader (vertexShader);

if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
{

throw (GL.getShaderInfoLog(vertexShader));

}


var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
GL.shaderSource (fragmentShader, colorFragmentShader);
GL.compileShader (fragmentShader);

if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {

 throw(GL.getShaderInfoLog(fragmentShader));

}

shaderProgram = GL.createProgram ();
GL.attachShader (shaderProgram, vertexShader);
GL.attachShader (shaderProgram, fragmentShader);
GL.linkProgram (shaderProgram);

if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {


throw "Unable to initialize the shader program.";
}

vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
colorAttribute = GL.getAttribLocation (shaderProgram, "aColor");
projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");

 		
	}


}
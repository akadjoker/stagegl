package com.engine.render.filter;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import flash.geom.Matrix3D;
import com.engine.Game;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Shader implements IShader
{
 public var vertexAttribute :Int;
 public var colorAttribute :Int;
 public var imageUniform:Dynamic;
 public var texCoordAttribute:Int;
 private var shaderProgram:GLProgram;
 public var projectionMatrixUniform:Dynamic;
 public var modelViewMatrixUniform:Dynamic;
 

	public function new() 
	{
		
	}
	public  function Enable():Void
	{
	   GL.useProgram (shaderProgram);
       GL.enableVertexAttribArray (vertexAttribute);
       GL.enableVertexAttribArray (colorAttribute);
	}
	public function Disable():Void
	{
       GL.disableVertexAttribArray (vertexAttribute);
  	   GL.disableVertexAttribArray (colorAttribute);
	   GL.useProgram (null);
	
	}
	public function setTexture(tex:Texture):Void
	{
 	 if (tex!=null) tex.Bind();
     if (imageUniform!=null)GL.uniform1i (imageUniform, 0);
	}

	public function dispose():Void
	{
	GL.deleteProgram(shaderProgram);
	}
}
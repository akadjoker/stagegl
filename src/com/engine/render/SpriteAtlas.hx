package com.engine.render;

import com.engine.components.Camera;
import com.engine.Game;
import com.engine.misc.Clip;
import com.engine.misc.BlendMode;
import com.engine.render.filter.Shader;
import flash.geom.Matrix;
import flash.geom.Point;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;

import com.engine.render.filter.Filter;
import com.engine.render.filter.SpriteShader;
/**
 * ...
 * @author djoker
 */
class SpriteAtlas extends Render
{

	private var capacity:Int;
	private var numVerts:Int;
	private var numIndices:Int; 
	private var vertices:Float32Array;
	private var indices:Int16Array;
	private var lastIndexCount:Int;
	private var drawing:Bool;
	private var currentBatchSize:Int;
	private var currentBlendMode:Int;
	private var currentBaseTexture:Texture;
    private var vertexBuffer:GLBuffer;
    private var indexBuffer:GLBuffer;
    private var invTexWidth:Float = 0;
    private var invTexHeight:Float = 0;
	public var vertexStrideSize:Int;
    public var shader:Shader;


	public function new(texture:Texture,capacity:Int,shaderrender:Shader) 
	{
		super();
	   this.shader = shaderrender;
		this.capacity = capacity;
        vertexStrideSize =  (3+2+4) *4; // 9 floats (x, y, z,u,v, r, g, b, a)
 
	   numVerts = capacity * vertexStrideSize;
       numIndices = capacity * 6;
      vertices = new Float32Array(numVerts);

        this.indices = new Int16Array(numIndices); 
		var length = Std.int(this.indices.length/6);
		
		for (i in 0...length) 
		{
			var index2 = i * 6;
			var index3 = i * 4;
			this.indices[index2 + 0] = index3 + 0;
			this.indices[index2 + 1] = index3 + 1;
			this.indices[index2 + 2] = index3 + 2;
			this.indices[index2 + 3] = index3 + 0;
			this.indices[index2 + 4] = index3 + 2;
			this.indices[index2 + 5] = index3 + 3;
		};
		

    drawing = false;
    currentBatchSize = 0;
	currentBlendMode = BlendMode.NORMAL;
    this.currentBaseTexture = texture;
    invTexWidth  = 1.0 / texture.texWidth;
    invTexHeight = 1.0 / texture.texHeight;

	
	 // create a couple of buffers
    vertexBuffer = GL.createBuffer();
    indexBuffer = GL.createBuffer();


    //upload the index data
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);

    GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
	
	indices = null;
	shader = new SpriteShader();

	}
	
  

	
	
inline public function RenderNormal(x:Float, y:Float)
{
	
 var u:Float = 0;
 var v:Float = 1;
 var u2:Float = 1;
 var v2:Float = 0;
 var fx2:Float = x + currentBaseTexture.width;
 var fy2:Float = y + currentBaseTexture.height;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


    currentBatchSize++;

	}
	
	inline public function RenderClip(x:Float, y:Float,clip:Clip)
{
	

				
 var u:Float  = clip.x * invTexWidth;
 var u2:Float = (clip.x + clip.width) * invTexWidth;
 
 var v:Float  = (clip.y + clip.height) * invTexHeight;
 var v2:Float = clip.y * invTexHeight;	
	

 var fx2:Float = x + clip.width;
 var fy2:Float = y + clip.height;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


    currentBatchSize++;

	}
	
	public function Begin()
	{
	 currentBatchSize = 0;
	 shader.Enable();
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
     GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, vertexStrideSize, 0);
     GL.vertexAttribPointer(shader.texCoordAttribute  , 2, GL.FLOAT, false, vertexStrideSize, 3 * 4);
     GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, vertexStrideSize, (3+2) * 4);
     
    }
	public function End()
	{
	if (currentBatchSize==0) return;
	shader.setTexture(currentBaseTexture);
	BlendMode.setBlend(currentBlendMode);
	 GL.uniformMatrix4fv(shader.projectionMatrixUniform, false,new Float32Array(camera.projMatrix.rawData));
     GL.uniformMatrix4fv(shader.modelViewMatrixUniform, false,new  Float32Array(camera.viewMatrix.rawData));
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    GL.drawElements(GL.TRIANGLES, currentBatchSize * 6, GL.UNSIGNED_SHORT, 0);
    currentBatchSize = 0;
    shader.Disable();
	}
 public function dispose():Void 
{
	    GL.deleteBuffer(indexBuffer);
		GL.deleteBuffer(vertexBuffer);

}



}
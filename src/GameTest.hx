package ;


import com.engine.components.text.BitmapFont;
import com.engine.components.text.Font;
import com.engine.components.text.ImageFont;
import com.engine.components.Camera;
import com.engine.components.text.Text;
import com.engine.components.Tilemap;
import com.engine.input.Keys;
import com.engine.misc.BlendMode;
import com.engine.misc.Clip;
import com.engine.misc.Polygon;
import com.engine.misc.SpriteSheet;
import com.engine.misc.Util;
import com.engine.render.BatchRender;
import com.engine.render.filter.SpriteBlurShader;
import com.engine.render.filter.SpriteGrayShader;
import com.engine.render.filter.SpriteInvertShader;
import com.engine.render.filter.SpritePixelateShader;
import com.engine.render.filter.SpriteSepiaShader;
import com.engine.render.filter.SpriteShader;
import com.engine.render.BatchPrimitives;
import com.engine.render.filter.SpriteStepColorShader;
import com.engine.render.filter.SpriteXBlurShader;
import com.engine.render.filter.SpriteYBlurShader;
import com.engine.render.SpriteBatch;
import com.engine.render.SpriteAtlas;
import com.engine.render.SpriteCloud;
import com.engine.render.Texture;
import com.engine.Screen;
import com.engine.misc.Transitions;
import com.engine.misc.Tween;
import com.game.Room;
import com.game.Scene;
import com.game.Sprite;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import flash.Lib;
import openfl.Assets;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class GameTest extends Screen
{
	var times:Array<Float>;

	
    public var primitives:BatchPrimitives;
	public var batch:SpriteBatch;
	var terrain:Texture;
	var shader:SpriteShader;
	var iFont:Text;
	public var camera:Camera;
	var mouse:Point;
var game_width:Float = 100; 
var game_height = 50;
var aspetc_ratio:Float;



        var worldWidth:Float;
		var worldHeight:Float;
		
	  

		var room:Room;
		var scene:Scene;
		
	
	override public function show()
	{
		  times = [];
		 
iFont = new Text("assets/tinyfont.fnt", "Luis Santos");
	//	var g = new Graphic();
		
		aspetc_ratio =  height  / width;
		
		
		//worldWidth =  game_width * aspetc_ratio;
		//worldHeight =  game_height;
	
	    var w:Int =  game.screenWidth ;
		var h:Int =  game.screenHeight ;
		
		
		
		
		camera = new Camera(w,h,640,480);
		camera.update();
		
	
		
		 
		primitives = new BatchPrimitives(1500);
		primitives.camera = camera;
		
		
		
		
		
		 room = new Room(4000,4000,640,480,200,200);
		 room.addScene(new Menu());
		 room.addScene(new MainGame());
		 room.goto_first();
		 room.go_to("GameLoop");
		 
	
		
		batch = new SpriteBatch(1500,new SpriteShader());
		batch.camera = camera;

	
		mouse = new Point();
		
	}
	
	override public function update(dt:Float) 
	{
		
		room.update(dt);
	}
		
	override public function render() 
	{ 
		
	  var now = Lib.getTimer () / 1000;
      times.push(now);
      while(times[0]<now-1)
         times.shift();
		 iFont.text = "\nFPS:" + times.length + "- Obj:" + room.room_current.count+"- View:"+room.room_current.numRender;
      
		
		 
		
		camera.update();
		

			batch.Begin();
		
		
		room.render(batch);
	
		
			iFont.print(batch, 10, 10);
	
			
			batch.End();
		
		
		primitives.begin();
		
	#if debug	room.debug(primitives); #end
	
	//primitives.rect(0, 0, width, height, 1, 0, 0, 1);
	//primitives.rect(0, 0, 800, 600,1,0,0,1);
	

		
		primitives.end();
		
	
		
	}
	  override public function resize(width:Int, height:Int) 
	{ 
	    camera.resize(width, height, true);
	}
	
	/*
	public function setScreenBounds ( screenX:Int,  screenY:Int,  screenWidth:Int,  screenHeight:Int) :Void
	{
		camera.setViewPort(screenX, screenY, screenWidth, screenHeight);
	   	camera.resize(Std.int(worldWidth),Std.int( worldHeight));
	}
	
	
	  override public function resize(width:Int, height:Int) 
	{ 
	    var scaled:Point = apply(true,worldWidth, worldHeight,width, height);
		var viewportWidth = Math.round(scaled.x);
		var viewportHeight = Math.round(scaled.y);
  	    setScreenBounds(Std.int((width - viewportWidth) / 2),Std.int( (height - viewportHeight) / 2), viewportWidth, viewportHeight);
	}
	public function apply (fit:Bool, sourceWidth:Float,  sourceHeight:Float,  targetWidth:Float,  targetHeight:Float):Point
	{
	//	fit
	if (fit)
	{
			var targetRatio:Float = targetHeight / targetWidth;
			var sourceRatio:Float = sourceHeight / sourceWidth;
			var scale:Float = targetRatio > sourceRatio ? targetWidth / sourceWidth : targetHeight / sourceHeight;
			return new Point(sourceWidth * scale, sourceHeight * scale);
	} else
	{
		
	//	fill
			var targetRatio:Float = targetHeight / targetWidth;
			var sourceRatio:Float = sourceHeight / sourceWidth;
			var scale:Float = targetRatio < sourceRatio ? targetWidth / sourceWidth : targetHeight / sourceHeight;
			return new Point(sourceWidth * scale, sourceHeight * scale);
	}
	}*/

   override public function keyDown(key:Int) 
   {
	  
	   
	 
   }
   
	override public function keyUp(key:Int) 
	{ 
		
		
		
	}
	
		
	override public function mouseDown(mousex:Float, mousey:Float) 
	{
	
		
	}		
	override public function mouseMove(mousex:Float, mousey:Float) 
	{
		

	

	}
	override public function mouseUp(mousex:Float, mousey:Float) 
	{
	
	
	}
		
}
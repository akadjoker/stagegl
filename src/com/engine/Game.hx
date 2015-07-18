package com.engine;



import com.engine.components.Camera;
import com.engine.render.Texture;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import openfl.display.OpenGLView;
import openfl.gl.GL;

import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;




/**
 * ...
 * @author djoker

 */
class Game extends OpenGLView
{


public static var game:Game;
public static var now:Int = 0;
public static var then:Int = 0;
public static var frameStart:Int = 0;
public static var fps:Int = 0;
public static var dt:Float = 0;
public static var frames:Int = 0;
public static var fixedTimestep:Bool=true;

public var mouse_x:Int=0;
public var mouse_y:Int=0;
public var mouse_down:Bool = false;
public var mouse_released:Bool = false;
public var mouse_pressed:Bool = false;
private var  key_down:Array<Bool>;
private var  key_pressed:Array<Bool>;
private var  key_released:Array<Bool>;
private var  keys_pressed:Array<Int>;
private var  keys_released:Array<Int>;

private var  vkeys:Array<Int>;
private var  touchs:Array<Point>;
private var touch_count:Int = 0;


	
	private var ready:Bool;
	public var deltaTime:Float;
    private var prevFrame:Int;
    private var nextFrame:Int; 
	private var mMultiTouch:Bool;
	private var screen:Screen = null;
	public var container:Sprite;
	//value from the windows resize
	public var screenWidth:Int = 0;
	public var screenHeight:Int = 0;
	public var viewWidth:Int = 0;
	public var viewHeight:Int = 0;


	
	private var rescale:Bool = false;
	private var enableDepth:Bool;
    public var red:Float;
    public var green:Float;
    public var blue:Float;
	private var textures:Map<String,com.engine.render.Texture>;
	private var requestedFramerate:Int;
		




	public function new() 
	{
	super();
	Game.game = this;
	ready = false;
    this.render = renderView;
   
	  key_down = [];
	  key_pressed = [];
      key_released = [];
	  keys_pressed = [];
      keys_released = [];

      vkeys= [];
      touchs= [];
      touch_count = 0;

	 for (i in 0...256)
	{
	key_down[i] = false;
	key_released[i] = false;
	key_pressed[i] = false;
	}

	
	
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		requestedFramerate = Std.int(Lib.current.stage.frameRate);
	    viewWidth = screenWidth;
		viewHeight = screenHeight;

		
	
		textures= new  Map<String,Texture>();
	
		trace(screenWidth  + "x " + screenHeight);
	
	

	stage.addEventListener(Event.RESIZE, onResize);
	stage.addEventListener(Event.ADDED, focusGained);
	stage.addEventListener(Event.DEACTIVATE, focusLost);
	
	
	container = new Sprite();
	container.addEventListener(Event.ADDED_TO_STAGE, addedToStage);		
	stage.addChild(container);
	prevFrame = Lib.getTimer();
	
	

	
	}
	
	public function setDeph(v:Bool)
	{
		enableDepth = v;
		if (v == true)
		{
		 GL.disable(GL.DEPTH_TEST);
		} else
		{
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.FASTEST);
    	}
	}
	public function clarColor(r:Float, g:Float, b:Float)
	{
		red = r;
		green = g;
		blue = b;
	}
	
	public	function removeChild(child : DisplayObject)
	{
		container.removeChild(child);
	}
	
	public function addChild(child : DisplayObject) 
  {
	  container.addChild(child);
  }
		
  
  
	private function addedToStage(e:Event)
	{
  	
	mMultiTouch = Multitouch.supportsTouchEvents;
    if (mMultiTouch) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
  //  trace("Using multi-touch : " + mMultiTouch);
	
	
	
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, doMouseDown);
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_MOVE, doMouseMove);
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, doMouseUp);
    Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
	Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
	//Lib.current.stage.addEventListener (Event.ENTER_FRAME, onEnterFrame);
	
		
	
	if (mMultiTouch)
	{
	Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, doTouchDown);
    Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, doTouchMove);
    Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, doTouchUp);
	}
	
			
 
 		  
		   //
    GL.disable(GL.CULL_FACE);
    GL.enable(GL.BLEND);
	GL.blendFunc(GL.SRC_ALPHA,GL.DST_ALPHA );
	GL.pixelStorei(GL.PACK_ALIGNMENT, 2);
    setDeph(true);
	clarColor(0, 0, 0.4);
	GL.clearColor(red, green, blue, 1);
	GL.depthMask(true);
	GL.colorMask(true, true, true, true);
	GL.activeTexture(GL.TEXTURE0);
		 
	
	  

		begin(); 
		ready = true; 
	
	}
	public function focusGained(e:Event) 
	{ 
		
	
	  
	
	}

	private function stage_onKeyDown (event:KeyboardEvent):Void 
	{
	  var keycode = event.keyCode;
	  if (!key_down[keycode])
	  {
		  key_pressed[keycode] = true;
		  keys_pressed.push(keycode);
		  
	  }
	  key_down[keycode] = true;
	  

		keyDown(event.keyCode);
		if (screen != null) screen.keyDown(event.keyCode);
		event.preventDefault();
	}
	
	
	private function stage_onKeyUp (event:KeyboardEvent):Void
	{
      var keycode = event.keyCode;
	  if (key_down[keycode])
	  {
		  key_released[keycode] = true;
		  keys_released.push(keycode);
	  }
	  key_down[keycode] = false;
	  keyUp(event.keyCode);
		if (screen != null) screen.keyUp(event.keyCode);
		event.preventDefault();
	}
	
	private function doMouseDown (event:MouseEvent):Void 
	{
	if (!mouse_down) mouse_pressed = true;
	mouse_down = true;
	mouse_x =Std.int( event.localX);
	mouse_y =Std.int( event.localY);
	mouseDown(event.localX, event.localY);
	if (screen != null) screen.mouseDown(event.localX, event.localY);
	}
	private function doMouseUp (event:MouseEvent):Void 
	{
	if (mouse_down) mouse_released = true;
	mouse_down = false;
	mouseUp(event.localX, event.localY);
	if (screen != null) screen.mouseUp(event.localX, event.localY);
	}
    private function doMouseMove (event:MouseEvent):Void 
	{
		mouse_x =Std.int( event.localX);
		mouse_y =Std.int( event.localY);
		
	mouseMove(event.localX, event.localY);
	if (screen != null) screen.mouseMove(event.localX, event.localY);

	}

	private function doTouchDown (event:TouchEvent):Void 
	{
	
	}
	private function doTouchUp (event:TouchEvent):Void 
	{
		
	}
    private function doTouchMove (event:TouchEvent):Void 
	{
		

	}

    private function focusLost(e:Event) 
	{
		//ready = false; 
	//	end(); 
	//	for (tex in this.textures)
	//	{
	//		tex.dispose();
	//	}
		
	//	textures = null;
	}
	private function onResize(e:Event) 
	{
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		resize(screenWidth, screenHeight);
		
	//	trace(screenWidth  + "x " + screenHeight);
	//	trace(viewWidth + " x " + viewHeight);
		
	}
	
	public function begin() {  }
	public function end()   {  }
	public function resize(width:Int, height:Int) 
	{
	if (screen != null) screen.resize(width, height);
	}
	public function onUpdate(dt:Float) 
	{
	
	}
	
	public function onRender() 
	{
		
		 
	
	
	if (screen != null) screen.update(dt);	
	if (screen != null) screen.render();
	
	
	for (k in 0...keys_pressed.length)
	{
		key_pressed[keys_pressed[k]] = false;
	}
	for (k in 0... keys_released.length)
	{
		key_released[keys_released[k]] = false;
	}
	keys_pressed = [];
	keys_released = [];
	mouse_pressed = false;
	mouse_released = false;
	
	}
	
    public function keyDown(key:Int) { };
	public function keyUp(key:Int) { };

	public function mouseMove(mousex:Float, mousey:Float) { };
	public function mouseUp(mousex:Float, mousey:Float) { };
	public function mouseDown(mousex:Float, mousey:Float) { };
	
	public function setScreen ( screen:Screen) 
	{
		if (this.screen != null) this.screen.dispose();
		this.screen = screen;
		this.screen.game = this;
		if (this.screen != null)
		{
			this.screen.width  = screenWidth;
			this.screen.height = screenHeight;
			this.screen.show();
			this.screen.resize(screenWidth, screenHeight);
			
		}
	}
	
	
private function onEnterFrame (event:Event):Void 
{
onUpdate(dt);
}
	
		
private function renderView(rect:Rectangle):Void 
{ 
	
    updateTimer();
	
	
    var timer:Int = getTimer();
	viewWidth   = Std.int(rect.width);
	viewHeight  = Std.int(rect.height);
	
	



	
   
	nextFrame = Lib.getTimer();
    deltaTime = (nextFrame - prevFrame) * 0.001;
    GL.clearColor(red, green, blue, 1);
	
	if (enableDepth == true)
	{
	 GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	} else
	{
	GL.clear(GL.COLOR_BUFFER_BIT );	
	}

 



	if (ready)
	{
		
	  onRender();
    }
	

 GL.bindBuffer (GL.ARRAY_BUFFER, null);	
 GL.useProgram (null);	
 GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
 
 
//

timer = getTimer();
prevFrame = nextFrame;
}
	
public function getTexture(url:String, ?flip:Bool = false ):Texture 
{
	if (textures.exists(url))
	{
		return textures.get(url);
	} else
	{	
	var tex = new Texture();
	tex.load(url, flip);
	textures.set(url,tex);
	return tex;
	}
}
private  function updateTimer()
{
then = now;
now = getTimer();
dt = then == 0 ? 0 : (now - then) / 1000;
if (fixedTimestep) {
dt = 1 / requestedFramerate;
}

frames++;
if (now - frameStart >= 1000) 
{
	fps = Std.int(Math.min(requestedFramerate, frames));
frames = 0;
frameStart = now;
}
}

public  function getTimer():Int
{
	return Lib.getTimer();
}

public function keyboard_check(_key:Int):Bool { return key_down[_key]; }
public function keyboard_check_pressed(_key:Int):Bool { return key_pressed[_key]; }
public function keyboard_check_released(_key:Int):Bool { return key_released[_key]; }

public function mouse_check():Bool { return mouse_down; }
public function mouse_check_pressed():Bool { return mouse_pressed; }
public function mouse_check_released():Bool { return mouse_released; }

}
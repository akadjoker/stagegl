package ;
 

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;


import com.engine.Game;


class Main extends Game 
{
override function begin() 
{
	

//this.setScreen(new TestePrimitives());
//this.setScreen(new MeshManual());
this.setScreen(new GameTest());
//this.setScreen(new ScreenResolution());
}

}
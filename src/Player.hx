package;

import com.engine.components.Emitter;
import com.engine.components.PexParticles;
import com.engine.Game;
import com.engine.misc.SpriteSheet;
import com.engine.misc.Util;
import com.engine.render.SpriteBatch;
import com.game.Actor;
import com.game.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

 
class Player extends Actor
{
	

	public var acc:Float;
	public var anim:Int;
	public var shootTime:Float;
	var shootDelay:Float;
	var bLeft:Bool;
	var particles:PexParticles;
	var emitter:Emitter;
	
	
	var spr:SpriteSheet;

	public function new(sprites:SpriteSheet) 
	{
		super();
		
		spr = sprites;
		
		x =  640 / 2;
		y =  480 / 2;
		
		addGraphic(new Sprite(sprites.image, 64, 64, 
		64/2,64/2 ,
		2, 
		20, -24, 24, -24, 24,
		sprites.getClips("sprite_8_")));
		
		type = "player";
		
		centerx = 64 / 2;
		centery = 64 / 2;
		
		speed = 5;
		acc = 1;
		anim = 0;
		
		  bLeft = true;
		  
		  shootDelay = 0.2;
		  shootTime = 0;
			
		  
		 particles = new PexParticles("assets/exahust.pex", "assets/");
		 emitter = particles.createEmitter();
		 emitter.duration = 0.1;
		
		graphic.image_frame = 10;
	}
	
	override function update(dt:Float):Void
	{
	
		speed *= 0.98;
		
	
		if (keyboard_check(SPACE))
		{
			if (shootTime < 0)
			{
			bLeft =  !bLeft;
			shootTime = shootDelay;

			if(bLeft)
			{
			var p= getRealPoint(new Point( 8, 12));
			var b:Bullet = new Bullet(spr, p.x, p.y, angle);
			scene.add(b);
		    } else
			{
			   var p= getRealPoint(new Point( 8, -14));
			   var b:Bullet = new Bullet(spr, p.x, p.y, angle);
			   scene.add(b);
			}
			}
		}
		
		
		if (keyboard_check(UP))
		{
			acc = 100;
			emitter.enabled = true;
			
			emitter.duration = -1;
		} else
		{
			acc = 0;
			emitter.duration = 1.0;
		}
		
		
		if (anim > 0)
		{
			anim -= 1;
		}
		if (anim < 0)
		{
			anim += 1;
		}
		
		
		
		
		if (keyboard_check(LEFT))
		{
			direction += 2;
			anim -= 1;
			
		}
		if (keyboard_check(RIGHT))
		{
		    anim += 1;	
			direction -= 2;
		} 
	
		
		
	
		
		if (anim >= 3)
		{
			anim = 3;
		} 
		if (anim <= -3)
		{
			anim = -3;
		}
		
		graphic.image_frame = 10 + anim;
		
		angle = direction;
		speed += acc; 
		if (speed >= 400) speed = 400;
		if (speed <= -400) speed = -400;
		
		
		advance(speed,dt );
		
		shootTime-= dt;
		
		emitter.update(dt);
	
	}
	override public function render(batch:SpriteBatch):Void 
	{
		super.render(batch);
		
			
		var p= getRealPoint(new Point(-30, 0));
			
			emitter.angle = angle-180;
		
		emitter.render(p.x-room.viewport_x,p.y-room.viewport_y,batch);
	//	emitter.render(new Matrix();
	}
	
}
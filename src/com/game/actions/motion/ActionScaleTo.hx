package com.game.actions.motion;

import com.engine.misc.Ease;
import com.engine.misc.Util;
import com.game.actions.ActionInterval;
import openfl.geom.Point;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

 class ActionScaleTo extends ActionInterval
{
	

	 private var m_positionDelta:Point;
	 private var m_from:Point;
	 private var m_move:Point;
	 private var time:Float;
	 private var _ease:Float -> Float;


	
	public function new(targetDelta:Point,targetDuration:Float,?ease:Float -> Float) 
	{
		super(targetDuration);
		m_positionDelta = targetDelta;
		time = 0;
		_ease = ease;
	}

	     public override function  Start():Void
        {
            super.Start();
			m_from = new Point(target.xscale, target.yscale);
			time = 0;
			m_move = new Point(m_positionDelta.x - m_from.x, m_positionDelta.y - m_from.y);
		}
		
        public override function Step(dt:Float):Void
        {
			time += dt ;
			
            var d:Float =  time / duration;
			if (_ease != null && d > 0 && d < 1) d = _ease(d);
			

	        target.xscale = m_from.x + m_move.x  * d;
			target.yscale = m_from.y + m_move.y  * d;

        }
		
		
}


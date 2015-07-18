package com.game;
import com.engine.Game;
import com.engine.misc.Util;
import com.engine.render.Texture;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Api
{
	public  var ANY = -1;

	public  var LEFT = 37;
	public  var UP = 38;
	public  var RIGHT = 39;
	public  var DOWN = 40;

	public  var ENTER = 13;
	public  var COMMAND = 15;
	public  var CONTROL = 17;
	public  var SPACE = 32;
	public  var SHIFT = 16;
	public  var BACKSPACE = 8;
	public  var CAPS_LOCK = 20;
	public  var DELETE = 46;
	public  var END = 35;
	public  var ESCAPE = 27;
	public  var HOME = 36;
	public  var INSERT = 45;
	public  var TAB = 9;
	public  var PAGE_DOWN = 34;
	public  var PAGE_UP = 33;
	public  var LEFT_SQUARE_BRACKET = 219;
	public  var RIGHT_SQUARE_BRACKET = 221;
	public  var TILDE = 192;

	public  var A = 65;
	public  var B = 66;
	public  var C = 67;
	public  var D = 68;
	public  var E = 69;
	public  var F = 70;
	public  var G = 71;
	public  var H = 72;
	public  var I = 73;
	public  var J = 74;
	public  var K = 75;
	public  var L = 76;
	public  var M = 77;
	public  var N = 78;
	public  var O = 79;
	public  var P = 80;
	public  var Q = 81;
	public  var R = 82;
	public  var S = 83;
	public  var T = 84;
	public  var U = 85;
	public  var V = 86;
	public  var W = 87;
	public  var X = 88;
	public  var Y = 89;
	public  var Z = 90;

	public  var F1 = 112;
	public  var F2 = 113;
	public  var F3 = 114;
	public  var F4 = 115;
	public  var F5 = 116;
	public  var F6 = 117;
	public  var F7 = 118;
	public  var F8 = 119;
	public  var F9 = 120;
	public  var F10 = 121;
	public  var F11 = 122;
	public  var F12 = 123;
	public  var F13 = 124;
	public  var F14 = 125;
	public  var F15 = 126;

	public  var DIGIT_0 = 48;
	public  var DIGIT_1 = 49;
	public  var DIGIT_2 = 50;
	public  var DIGIT_3 = 51;
	public  var DIGIT_4 = 52;
	public  var DIGIT_5 = 53;
	public  var DIGIT_6 = 54;
	public  var DIGIT_7 = 55;
	public  var DIGIT_8 = 56;
	public  var DIGIT_9 = 57;

	public  var NUMPAD_0 = 96;
	public  var NUMPAD_1 = 97;
	public  var NUMPAD_2 = 98;
	public  var NUMPAD_3 = 99;
	public  var NUMPAD_4 = 100;
	public  var NUMPAD_5 = 101;
	public  var NUMPAD_6 = 102;
	public  var NUMPAD_7 = 103;
	public  var NUMPAD_8 = 104;
	public  var NUMPAD_9 = 105;
	public  var NUMPAD_ADD = 107;
	public  var NUMPAD_DECIMAL = 110;
	public  var NUMPAD_DIVIDE = 111;
	public  var NUMPAD_ENTER = 108;
	public  var NUMPAD_MULTIPLY = 106;
	public  var NUMPAD_SUBTRACT = 109;
	public   var r2d:Float = -180 / Math.PI;
	public   var d2r:Float = Math.PI / -180;
	
	

	
		//room_background_color_show = true, room_background_color_red = 0, 
	//room_background_color_green = 0, room_background_color_blue = 0,

	
    public var game:Game;
	public function new() 
	{
		game = Game.game;
	}
	
	
public  inline function randf(max:Float, min:Float ):Float
{	
     return Math.random() * (max - min) + min;
}
public  inline function randi(max:Int, min:Int ):Int
{
	return Std.int(Math.random() * (max - min) + min);
     
}


   public inline function clamp(value:Float, min:Float, max:Float):Float
	{
		return value < min ? min : (value > max ? max : value);
	}
	
public  inline function deg2rad(deg:Float):Float
    {
        return  deg * d2r; 
    }
public  inline function rad2deg(rad:Float):Float
    {
        return rad * r2d;       
    }

	

	
	public inline function lengthdir_x(length:Float, direction:Float) { return length * Math.cos(direction * d2r); }
	public inline function lengthdir_y(length:Float, direction:Float) { return length * Math.sin(direction * d2r); }
	public inline function point_distance(x1:Float, y1:Float, x2:Float, y2:Float) { return Math.sqrt(Math.pow((x1 - x2), 2) + Math.pow((y1 - y2), 2)); }
	public inline function point_direction(x1:Float,y1:Float, x2:Float, y2:Float) { return Math.atan2(y2 - y1, x2 - x1) * r2d; }	
	


public  inline function collide_bbox_bbox(l1:Float, t1:Float, r1:Float, b1:Float, l2:Float, t2:Float, r2:Float, b2:Float) :Bool
{
	return !(b1 <= t2 || t1 >= b2 || r1 <= l2 || l1 >= r2);
}
// BBox <> Point
public  inline function collide_bbox_point(l1:Float, t1:Float, r1:Float, b1:Float, x2:Float, y2:Float) :Bool
{
	return (x2 > l1 && x2 < r1 && y2 > t1 && y2 < b1);
}
// BBox <> Circle
public  inline function collide_bbox_circle(l1:Float, t1:Float, r1:Float, b1:Float, x2:Float, y2:Float, r2:Float) :Bool
{
	var dx = (x2 < l1 ? l1 : x2 > r1 ? r1 : x2) - x2, 
		dy = (y2 < t1 ? t1 : y2 > b1 ? b1 : y2) - y2;
	return (dx * dx + dy * dy < r2 * r2);
}
// Circle <> Range
public  inline function collide_circle_range(dx:Float, dy:Float, dr:Float):Bool
{
	return (dx * dx + dy * dy < dr * dr);
}
// Circle <> Circle
public  inline function collide_circle_circle(x1:Float, y1:Float, r1:Float, x2:Float, y2:Float, r2:Float) :Bool
{
	return collide_circle_range(x1 - x2, y1 - y2, r1 + r2);
}
// Circle <> Point
public  inline function collide_circle_point(x1:Float, y1:Float, r1:Float, x2:Float, y2:Float) :Bool
{
	return collide_circle_range(x1 - x2, y1 - y2, r1);
}

// BBox <> SpriteBox
// (left, top, right, bottom, instX, instY, scaleX, scaleY, sprite, ofsX, ofsY)
public  inline function collide_bbox_sbox(l1:Float, t1:Float, r1:Float, b1:Float, x2:Float, y2:Float, h2:Float, v2:Float,s2: Sprite) 
{
	return
	!( b1 <= y2 + v2 * (s2.collision_top - s2.yoffset)
	|| t1 >= y2 + v2 * (s2.collision_bottom - s2.yoffset)
	|| r1 <= x2 + h2 * (s2.collision_left - s2.xoffset)
	|| l1 <= x2 + h2 * (s2.collision_right - s2.xoffset));
}
// SpriteBox <> BBox
public  inline function collide_sbox_point(x2:Float, y2:Float, h2:Float, v2:Float, s2:Sprite, x1:Float, y1:Float):Bool 
{
	return
	!( y1 <= y2 + v2 * (s2.collision_top - s2.yoffset)
	|| y1 >= y2 + v2 * (s2.collision_bottom - s2.yoffset)
	|| x1 <= x2 + h2 * (s2.collision_left - s2.xoffset)
	|| x1 <= x2 + h2 * (s2.collision_right - s2.xoffset));
}
// SpriteBox <> Circle
public  inline function collide_sbox_circle(x2:Float, y2:Float, h2:Float, v2:Float, s2:Sprite, x1:Float, y1:Float, r1:Float):Bool
{
	var u, v, dx, dy;
	u = x2 + h2 * (s2.collision_left - s2.xoffset);
	v = x2 + h2 * (s2.collision_right - s2.xoffset);
	dx = (x2 < u ? u : x2 > v ? v : x2) - x2;
	u = y2 + v2 * (s2.collision_top - s2.yoffset);
	v = y2 + v2 * (s2.collision_bottom - s2.yoffset);
	dy = (y2 < u ? u : y2 > v ? v : y2) - y2;
	return (dx * dx + dy * dy < r1 * r1);
}
	
	public inline function getTexture(url:String):Texture{return game.getTexture(url, false);}
	public inline function getTimer():Int{return game.getTimer();}
	public inline function keyboard_check(key:Int):Bool { return game.keyboard_check(key); }
	public inline function keyboard_check_pressed(key:Int):Bool { return  game.keyboard_check_pressed(key); }
	public inline function keyboard_check_released(key:Int):Bool { return game.keyboard_check_released(key);}
	public inline function mouse_check():Bool { return game.mouse_check(); }
	public inline function mouse_check_pressed():Bool { return game.mouse_check_pressed(); }
	public inline function mouse_check_released():Bool { return game.mouse_check_released(); }
}
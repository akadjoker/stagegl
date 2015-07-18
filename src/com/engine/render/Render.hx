package com.engine.render;
import com.engine.components.Camera;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Render
{
	private var _camera:Camera;
	
	public function new() 
	{
		_camera = null;
	}
	
	public var camera(get, set):Camera;
	
	private function get_camera():Camera 
	{
		return _camera;
	}
	
	private function set_camera(value:Camera):Camera 
	{
		_camera = value;
		return value;
	}
	
}
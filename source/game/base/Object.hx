package game.base;

import flixel.math.FlxRect;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Object extends FlxSprite
{
	public var center(get, never):FlxPoint;
	public function get_center()
		return cast origin;

	public var hitbox:FlxRect = FlxRect.get();
	public var hitboxArray:Array<Float> = [
		0.0, 0.0, 0.0, 0.0
	];
	public var radiusRect:FlxRect = FlxRect.get();
	public var radiusArray:Array<Float> = [
		0.0, 0.0, 0.0, 0.0
	];
	public static final MLEFT:Int = 0;
	public static final MRIGHT:Int = 1;
	public static final MTOP:Int = 2;
	public static final MBOTTOM:Int = 3;

	public var speed:FlxPoint = new FlxPoint();

	public function new()
	{
		super();
	}

	public function move(elapsed:Float = 1.66)
	{
		x += (speed.x * 60) * elapsed;
		y += (speed.y * 60) * elapsed;
	}

	override function destroy() {
		super.destroy();

		hitbox.destroy();
		hitboxArray = null;
		radiusRect.destroy();
		radiusArray = null;

		restDestroy();
	}

	function restDestroy():Void {}
}
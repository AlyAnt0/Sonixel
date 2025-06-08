package game.base;

import flixel.math.FlxRect;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * Originally created in 04.23.2025.
 */
class Object extends FlxSprite
{
	public var center:FlxPoint = FlxPoint.get();
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
		x += speed.x;
		y += speed.y;
	}

	override function destroy() {
		super.destroy();

		speed.put();
		center.put();
		hitbox.destroy();
		hitboxArray = null;
		radiusRect.destroy();
		radiusArray = null;

		restDestroy();
	}

	function restDestroy():Void {}
}
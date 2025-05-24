package game.util;

import flixel.math.FlxRect;

class PlayerUtils
{
	public static function getPlayerRect(x:Float, y:Float, anim:String):FlxRect
	{
		switch(anim)
		{
			case 'idle' | 'walk':
				return new FlxRect(x + 16, y + 8, 16, 40);
			case 'spinning' | 'crouch' | 'sonicBall':
				return new FlxRect(x + 12, y + 20, 23, 28);
			default:
				return new FlxRect(x + 16, y + 8, 16, 40);
		}

		return null;
	}
}
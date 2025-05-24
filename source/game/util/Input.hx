package game.util;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Input
{
	static function getKeyFrom(key:Key = null):FlxKey
	{
		switch (key)
		{
			case LEFT:
				return FlxKey.LEFT;
			case RIGHT:
				return FlxKey.RIGHT;
			case UP:
				return FlxKey.UP;
			case DOWN:
				return FlxKey.DOWN;
			case A:
				return FlxKey.A;
		}
		
		return FlxKey.NONE;
	}

	public static function isPressed(key:Key = null):Bool
	{
		return FlxG.keys.checkStatus(getKeyFrom(key), PRESSED);
	}

	public static function isJustPressed(key:Key = null):Bool
	{
		return FlxG.keys.checkStatus(getKeyFrom(key), JUST_PRESSED);
	}

	public static function isReleased(key:Key = null):Bool
	{
		return FlxG.keys.checkStatus(getKeyFrom(key), RELEASED);
	}

	public static function isJustReleased(key:Key = null):Bool
	{
		return FlxG.keys.checkStatus(getKeyFrom(key), JUST_RELEASED);
	}
}

private enum Key
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
	A;
}
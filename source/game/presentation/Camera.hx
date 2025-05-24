package game.presentation;

import flixel.FlxObject;
import game.object.Player;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxCamera;

private enum CameraBoundSide
{
	MLEFT;
	MRIGHT;
	MTOP;
	MBOTTOM;
}

class Camera extends FlxObject
{
	public var center:FlxPoint = FlxPoint.get(FlxG.width / 2, FlxG.height / 2);
	public var cameraBounds:Map<CameraBoundSide, Float> = [
		MLEFT => 0, MRIGHT => 0,
		MTOP => 0, MBOTTOM => 0,
	];

	// for debug
	public var screenCameraBounds:Map<CameraBoundSide, Float> = [
		MLEFT => 0, MRIGHT => 0,
		MTOP => 0, MBOTTOM => 0,
	];
	public var followPlayer:Bool = true;

	public var speed:FlxPoint = FlxPoint.get();

	public var player:Player = null;

	public function new(playerNew:Player):Void
	{
		super(0, 0, 1, 1);

		player = playerNew;
		
		updateCameraBounds(false);
	}

	public function step():Void
	{
		updateCameraBounds(true);

		if (player != null && followPlayer)
		{
			if ((player.x + player.origin.x) > cameraBounds[MRIGHT])
				speed.x = player.speed.x;
		}

		moveCamera();
	}

	function moveCamera():Void
	{
		x += speed.x;
		y += speed.y;
	}

	function updateCameraBounds(update:Bool):Void
	{
		if (update)
		{
			cameraBounds[MLEFT] 	= (FlxG.camera.scroll.x + center.x) - 16;
			cameraBounds[MRIGHT] 	= (FlxG.camera.scroll.x + center.x) + 16;
			cameraBounds[MTOP] 		= (FlxG.camera.scroll.y + center.y) - 32;
			cameraBounds[MBOTTOM] 	= (FlxG.camera.scroll.y + center.y) + 32;
		}
		else
		{
			screenCameraBounds[MLEFT] 	= center.x - 16;
			screenCameraBounds[MRIGHT]	= center.x + 16;
			screenCameraBounds[MTOP]	= center.y - 32;
			screenCameraBounds[MBOTTOM]	= center.y + 32;
		}
	}
}
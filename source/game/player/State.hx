package game.player;

import flixel.FlxG;
import game.object.Player;

/**
 * Originally created in 07.05.2024.
 */
class State
{
	public var player:Player = null; // the host player is get by his own state machine that he belongs to
	public var id:String = '';

	final MLEFT:Int = 0;
	final MRIGHT:Int = 1;
	final MTOP:Int = 2;
	final MBOTTOM:Int = 3;

	public function new() {}

	public function init():Void {}

	public function update(elapsed:Float):Void 
	{
		if(Input.isJustPressed(DEBUG_MODE))
			if(player != null)
				player.stateMachine.switchState('debug');
	}
}
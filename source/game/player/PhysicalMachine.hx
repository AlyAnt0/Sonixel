package game.player;

import flixel.util.FlxSignal;
import game.object.Player;

/**
 * Originally created in 07.09.2024.
 */
class PhysicalMachine
{
	public var host:Player = null;
	public var curState:State = null;

	public var states:Map<String, State> = new Map<String, State>();

	public var changeToNormalSignal:FlxSignal;
	public var changeToRollSignal:FlxSignal;
	public var changeToAirSignal:FlxSignal;

	public function new(host:Player)
	{
		if (host != null)
			this.host = host;

		changeToNormalSignal = new FlxSignal();
		changeToNormalSignal.addOnce(changeToNormal);

		changeToAirSignal = new FlxSignal();
		changeToAirSignal.addOnce(changeToAirbone);

		changeToRollSignal = new FlxSignal();
		changeToRollSignal.addOnce(changeToRoll);
	}

	public function add(stateName:String, stateInstance:State):Void 
	{
		states.set(stateName, stateInstance);
	}
	
	public function switchState(state:String)
	{
		if (curState != states[state])
		{
			curState = states[state];
			curState.player = host;
	
			curState.init();
	
			trace('state switched: ${curState.id}');
		}
	}

	public function update(del:Float):Void
	{
		if (curState != null)
			curState.update(del);
	}
	
	function changeToNormal():Void
	{
		switchState('normal');
	}

	function changeToAirbone():Void
	{
		switchState('airbone');
	}
	
	function changeToRoll():Void
	{
		switchState('roll');
	}
}
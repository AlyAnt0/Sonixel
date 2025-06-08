package game.player.states.physical;

import game.collision.Sensor;
import game.collision.Sensor.SensorTag;

class AirboneState extends State
{
	public function new()
	{
		super();

		id = 'AIRBONE';
	}

	override function update(elapsed:Float)
	{
		player.move(elapsed);

		player.applyGravity();

		player.airCollide();
		
		if(player.grounded)
		{
			player.stateMachine.switchState('normal');
			return;
		}
	}
}
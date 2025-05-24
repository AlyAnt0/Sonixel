package game.player.states.physical;

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

		player.groundCheck();
		if(player.grounded)
		{
			player.stateMachine.switchState('normal');
			return;
		}

		trace(player.grounded);
	}
}
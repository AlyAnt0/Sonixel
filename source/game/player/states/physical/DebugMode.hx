package game.player.states.physical;

class DebugMode extends State
{
	public function new()
	{
		super();

		id = 'DEBUG';
	}
	override function init() {
		super.init();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		final movex = -binaryBool(Input.isPressed(LEFT)) + binaryBool(Input.isPressed(RIGHT));
		final movey = -binaryBool(Input.isPressed(UP)) + binaryBool(Input.isPressed(DOWN));

		final vel = 1;

		player.speed.x = vel * movex;
		player.speed.y = vel * movey;
	}
}
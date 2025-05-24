package game.player.states.physical;

import flixel.FlxG;
import flixel.effects.FlxFlicker;

class HurtState extends State
{
	public function new()
	{
		super();

		id = 'HURT';
	}

	override function init():Void
	{
		player.grounded = false;

		player.animation.play("hurt");
		final dir = player.flipX ? 1 : -1;
		player.speed.x = player.hurtForceX * dir;
		player.speed.y = player.hurtForceY;
	}

	override function update(elapsed:Float)
	{
		player.move(elapsed);
		player.groundCheck();

		player.applyGravity();	

		trace(player.grounded);

		if (player.grounded)
		{
			FlxFlicker.flicker(player, 1, 0.08, true, false);
			player.stateMachine.switchState('normal');

			return;
		}

		if (FlxG.keys.justPressed.ONE)
			player.stateMachine.switchState('normal');
	}
}
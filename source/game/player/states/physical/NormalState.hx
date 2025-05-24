package game.player.states.physical;

import flixel.util.FlxTimer;
import flixel.util.FlxSignal;
import flixel.FlxG;
import flixel.math.FlxMath;

class NormalState extends State
{
    // https://app.milanote.com/1Srk3d1rWBKxck/game-loop

	// Normal State code execution order:

	/**
	 * Check for special animations that prevent control (such as balancing).
	 * Check for starting a spindash while crouched.
	 * * Adjust Ground Speed based on current Ground Angle (Slope Factor).
	 * Check for starting a jump.
	 * * Update Ground Speed based on directional input and apply friction/deceleration.
	 * Check for starting crouching, balancing on ledges, etc.
	 * Push Sensor collision occurs.
	 * * Which sensors are used varies based on the the sensor activation.
	 * * This occurs before the Player's position physically moves, meaning they might not actually be touching the wall yet, the game accounts for this by adding the Player's X Speed and Y Speed to the sensor's position.
	 * Check for starting a roll.
	 * Handle camera boundaries (keep the Player inside the view and kill them if they touch the kill plane).
	 * Move the Player object
	 * * Calculate X Speed and Y Speed from Ground Speed and Ground Angle.
	 * * Updates X Position and Y Position based on X Speed and Y Speed.
	 * Grounded Ground Sensor collision occurs.
	 * * Updates the Player's Ground Angle.
	 * * Align the Player to surface of terrain or become airborne if none found.
	 * Check for slipping/falling when Ground Speed is too low on walls/ceilings.
	 */

	 var markCamPos:FlxSignal;

	public function new()
	{
        super();

		id = 'NORMAL';

		markCamPos = new FlxSignal();
		markCamPos.addOnce(markLastCameraPosition);
	}

	var canWalk:Bool = false;
	var stand:Bool = false;

	var cameraTimer:Int = 120;
	var cameraDirection:Int = 0;
	var canMoveCamera:Bool = true;

	final camera = FlxG.camera;

	override function init():Void
	{
		// ele imediatamente se encaixa no chao
		final currentResult = player.giveWinSensor().getTileVertical(PlayState.inst.worldCollisionLayer);
		player.groundSensorCollision(currentResult);
	}

	override function update(elapsed:Float):Void
	{
		if (player != null)
		{
			//checkSpindash();

			//align to the block surface
			if(player.grounded)
			{
				final currentResult = player.giveWinSensor().getTileVertical(PlayState.inst.worldCollisionLayer);
				player.groundSensorCollision(currentResult);
			}
			// ja que o codigo do estado atual e apenas ativo quando esta no chao, entao o codigo e escrito como se o jogador estivesse no chao
			player.calculateSpeedWithAngle();

			processInput();

			if (FlxG.keys.justPressed.ONE)
			{
				player.grounded = false;
				if (player.speed.x != 0)
				{
					player.groundSpeed = 0;
					player.speed.x = 0;
				}
				player.stateMachine.switchState('hurt');
			}

			player.move(elapsed);
		}
	}

	var lastCameraPos:Float = 0;

	function processInput():Void
	{
		if (player.grounded)
		{
			if (Input.isPressed(LEFT) && !Input.isPressed(RIGHT))
			{
				player.animation.play('walk');

				if(player.groundSpeed > -player.topSpeed)
					player.groundSpeed -= player.accelerationSpeed;
			}
			else if (Input.isPressed(RIGHT) && !Input.isPressed(LEFT))
			{
				player.animation.play('walk');

				if(player.groundSpeed < player.topSpeed)
					player.groundSpeed += player.accelerationSpeed;							
			}
			else
			{
				player.groundSpeed -= Math.min(Math.abs(player.groundSpeed), player.frictionSpeed) * FlxMath.signOf(player.groundSpeed);
				if(player.groundSpeed == 0)
					player.animation.play('idle');
			}

			if(player.animation.curAnim != null){
				if(player.animation.curAnim.name == 'walk'){	
					player.animation.curAnim.frameRate = 4+Math.floor(((Math.abs(player.groundSpeed)*100)/40));
					// trace(player.animation.curAnim.frameRate);
				}
				//trace(player.animation.curAnim.name);
			}
		}

		if (player.grounded)
		{
			if (Input.isPressed(DOWN))
			{
				// change to roll state
				if (player.speed.x < -0.125 || player.speed.x > 0.125){
					player.animation.play("roll");
					player.stateMachine.changeToRollSignal.dispatch();
				}else{
					if (player.speed.x == 0 && player.speed.y == 0)
					{
						canWalk = false;

						markCamPos.dispatch();
						player.animation.play("lookDown");
					}
				}
			}
			else
			{
				if (player.animation.curAnim.name == "lookDown")
				{
					player.animation.curAnim.reverse();
					if (player.animation.curAnim.finished)
						player.animation.play("idle");
				}
			}
	
			if (Input.isPressed(UP))
			{
				canWalk = false;
				player.animation.play("lookUp");
			}
	
			if (player.animation.curAnim != null)
			{
				final anim = player.animation.curAnim.name;
	
				if (anim == "lookDown" || anim == "lookUp")
					markCamPos.dispatch();
	
				if(anim == "lookDown")
					processCamera(anim);
				else if(anim == "lookUp")
					processCamera(anim);
			}
		}
	}

	function processCamera(anim:String):Void
	{
		if (anim == "lookDown" || anim == "lookUp")
			cameraTimer -= 1;
		
		if (cameraTimer < 0)
		{
			if (anim == "lookDown")
				if (camera.scroll.y < lastCameraPos + 88)
					camera.scroll.y += Global.CAMERA_SPEED;

			else if (anim == "lookUp")
				if (camera.scroll.y > lastCameraPos + 104)
					camera.scroll.y -= Global.CAMERA_SPEED;
		}
	}

	function markLastCameraPosition():Void
	{
		lastCameraPos = camera.scroll.y;

		trace('last position' + lastCameraPos);
	}
}
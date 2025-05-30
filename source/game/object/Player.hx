package game.object;

import game.player.states.physical.DebugMode;
import game.base.Object;
import flixel.util.FlxColor;
import game.player.states.physical.HurtState;
import game.player.states.physical.RollState;
import game.player.states.physical.AirboneState;
import game.player.states.physical.NormalState;
import game.player.PhysicalMachine;
import game.const.PlayerConst;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import game.collision.Sensor.SensorTag;
import game.collision.Sensor;

using flixel.util.FlxSpriteUtil;

////USE FOR FLOOR MODE
enum CollisionMode
{
	FLOOR;
	CEILING;
	LEFT_WALL;
	RIGHT_WALL;
}

enum StateMachine
{
	AIR;
	SPINING;
	GROUNDED;
	JUMP;
	FALL;
}

enum StateEnum
{
	IDLE;
	GROUNDED;
	JUMP;
	ROLLING;
}

//TODO
//main collision, and so much other stuff

class Player extends Object
{
	public var spr:FlxSprite;

	public var playerID:PlayerID = PlayerID.SONIC;
	public var state:StateEnum = IDLE;
	public var animationStuff:Array<Dynamic> = [
		// name, frames, framerate, loop
		["idle", [0], 12, true],
		["lookUp", [1, 2], 4, false],
		["lookDown", [3, 4], 4, false],
		["lookOnYOUFirstF", [5, 6], 8, false],
		["lookOnYOU", [7, 8, 9], 4, true],
		["chillS", [14, 10, 11], 8, false],
		["chill", [12, 13], 4, true],
		["walk", [15, 16, 17, 18, 19, 20, 21], 1, true],
		["run", [23, 24, 25, 26], 1, false],
		["roll", [27, 28, 29, 30], 1, true],
		["jump", [27, 28, 29], 1, true],
		["hurt", [56], 1, true]
	];

	public var developerView:Bool = false;
	public var debugMode:Bool = true;

	public var sensors:Map<SensorTag, Sensor> = new Map<SensorTag, Sensor>();

	public var floorMode:CollisionMode = FLOOR; // floor mode

	public var grounded:Bool = false;

	public var groundSpeed:Float = 0;
	public var groundAngle:Float = 0;

	public var accelerationSpeed:Float = 0.046875;
	public var decelerationSpeed:Float = 0.5;
	public var frictionSpeed:Float = 0.046875;
	public var topSpeed:Float = 6;
	public var gravityForce:Float = 0.21875;
	public var airAccelerationSpeed:Float = 0.09375;

	public var slopeFactorNormal:Float = 0.125;
	public var slopeFactorRollUp:Float = 0.078125;
	public var slopeFactorRollDown:Float = 0.3125;
	public var rollFrictionSpeed:Float = 0.0234375;
	public var rollDecelerationSpeed:Float = 0.125;

	public var jumpForce:Float = 4;
	public var jumpReleaseForce:Float = -4;

	public var hurtForceX:Float = 2;
	public var hurtForceY:Float = -4;

	public var jumpin:Bool = false;

	public var controlLock:Int = 0;
	public var jumpLock:Int = 0;
	public var maxJumpLock:Int = 30;

	public var text:FlxText;
	public var debugText:String = '';

	public var stateMachine:PhysicalMachine;


	var originPoints:Array<FlxPoint> = [
		FlxPoint.get(24, 28), // stand
		FlxPoint.get(24, 33) // spin
	];

	public function new(playerID:PlayerID):Void
	{
		super();
		loadGraphic('assets/images/Sonic.png', true, 48, 48);
		for(i in 0...animationStuff.length)
			animation.add(animationStuff[i][0], animationStuff[i][1], animationStuff[i][2]);
		animation.play("idle");
		antialiasing = false;

		origin.set(24, 28);

		setupSensors();

		stateMachine = new PhysicalMachine(this);
		stateMachine.add('normal', new NormalState());
		stateMachine.add('airbone', new AirboneState());
		stateMachine.add('roll', new RollState());
		stateMachine.add('hurt', new HurtState());
		stateMachine.add('debug', new DebugMode());
		stateMachine.switchState('airbone');

		// final radWidth = PlayerConst.RADIUSES[playerID][0][0]*2;
		// final radHeight = PlayerConst.RADIUSES[playerID][0][1]*2;	

		//rspr = new FlxSprite(radiusArray[0], radiusArray[2]).makeGraphic(Std.int(radWidth), Std.int(radHeight), 0x6ee1ff00);
		move();
	}

	function sensorSprite(x:Float = 0, y:Float = 0):FlxSprite
	{
		return new FlxSprite(x, y).makeGraphic(1,1,FlxColor.WHITE);
	}

	public function updateOriginPoint(anim:String):Void
	{
		final isStandAnim:Bool = 
			(anim == "idle" || anim == "lookUp" || anim == "lookOnYOUFirstF" ||
				anim == "lookOnYOU" || anim == "chillS" || anim == "chill" ||
				anim == "walk" || anim == "run");
		var usedOrigin:FlxPoint = FlxPoint.get();

		final index = isStandAnim ? 0 : 1;
		usedOrigin.set(originPoints[index].x, originPoints[index].y);

		origin.set(usedOrigin.x, usedOrigin.y);
	}

	public function updateRadius(anim:String, centerX:Float, centerY:Float)
	{
		final isStandRadius:Bool = 
			(anim == "idle" || anim == "lookUp" || anim == "lookOnYOUFirstF" ||
				anim == "lookOnYOU" || anim == "chillS" || anim == "chill" ||
				anim == "walk" || anim == "run");
		final state:Int = !isStandRadius ? 1 : 0;
		final currentRadius = PlayerConst.RADIUSES[playerID][state];
	
		final radWidth:Int = currentRadius[0];
		final radHeight:Int = currentRadius[1];

		final radiusLeft:Float = centerX - radWidth;
		final radiusRight:Float = centerX + radWidth;

		final radiusTop:Float = centerY - radHeight;
		final radiusBottom:Float = centerY + radHeight-1;

		radiusArray[MLEFT] = radiusLeft;
		radiusArray[MRIGHT] = radiusRight;
		radiusArray[MTOP] = radiusTop;
		radiusArray[MBOTTOM] = radiusBottom;

		//trace(Math.floor(centerX/16), Math.floor(centerY/16));
	}

	public function getSensorPositionsArray(anim:String):Array<FlxPoint>
	{
		if (radiusArray != null)
		{
			final isStandRadius:Bool = 
				(anim == "idle" || anim == "lookUp" || anim == "lookOnYOUFirstF" ||
				anim == "lookOnYOU" || anim == "chillS" || anim == "chill" ||
				anim == "walk" || anim == "run");

			// A, B, C, D, E, F
			final sensorPosStand:Array<FlxPoint> = [
				FlxPoint.get(radiusArray[MLEFT]+1, radiusArray[MBOTTOM]),
				FlxPoint.get(radiusArray[MRIGHT]-1, radiusArray[MBOTTOM]),
				FlxPoint.get(radiusArray[MLEFT], radiusArray[MTOP]),
				FlxPoint.get(radiusArray[MRIGHT], radiusArray[MTOP]),
				FlxPoint.get(radiusArray[MLEFT]-1, radiusArray[MBOTTOM]/2),
				FlxPoint.get(radiusArray[MRIGHT]+1, radiusArray[MBOTTOM]/2),
			];
			final sensorPosRoll:Array<FlxPoint> = [
				FlxPoint.get(radiusArray[MLEFT], radiusArray[MBOTTOM]),
				FlxPoint.get(radiusArray[MRIGHT], radiusArray[MBOTTOM]),
				FlxPoint.get(radiusArray[MLEFT], radiusArray[MTOP]),
				FlxPoint.get(radiusArray[MRIGHT], radiusArray[MTOP]),
				FlxPoint.get(radiusArray[MLEFT]-2, radiusArray[MBOTTOM]/2),
				FlxPoint.get(radiusArray[MRIGHT]+2, radiusArray[MBOTTOM]/2),
			];

			return isStandRadius ? sensorPosStand : sensorPosRoll;
		}

		return null;
	}

	public function updateSensorsPositions(anim:String):Void
	{
		final tags:Array<Dynamic> = [
			A, B, C, D, E, F
		];
		final sensorsArray = getSensorPositionsArray(anim);
		for (i in 0...tags.length)
		{
			sensors[tags[i]].position.set(sensorsArray[i].x, sensorsArray[i].y);
			sensors[tags[i]].spr.setPosition(sensorsArray[i].x, sensorsArray[i].y);
		}
	}
	
	public function setupSensors():Void
	{
		final tags:Array<Dynamic> = [
			[A, LEFT],
			[B, RIGHT],
			[C, UP],
			[D, UP],
			[E, LEFT],
			[F, RIGHT]
		];
		for (i in 0...tags.length)
		{
			sensors.set(tags[i][0], new Sensor(0, 0, tags[i][0], tags[i][1]));
			FlxG.state.add(sensors.get(tags[i][0]).spr);
		}
	}

	// public function reposition_all_sensors():Void
	// {
	// 	final center_x:Int = Std.int(origin.x), center_y = Std.int(origin.y);
	// 	for (type in sensors.keys())
	// 	{
	// 		if (radius != null && sensors[type] != null)
	// 		{
	// 			final radius_x:Int = Std.int(x + 24), radius_y:Int = Std.int(y + 28);
	// 			final radius_width:Int = 16, radius_height:Int = 39;
	// 
	// 			radius.setPosition(radius_x, radius_y);
	// 			radius.setSize(radius_width, radius_height);
	// 
	// 			//ground
	// 			sensors[A].position.set(radius_x, radius_y + radius_height);
	// 			sensors[B].position.set(radius_x + radius_width, radius_y + radius_height);
	// 
	// 			// ceiling
	// 			sensors[C].position.set(radius_x, radius_y);
	// 			sensors[D].position.set(radius_x + radius_width, radius_y);
	// 
	// 			//wall sensors
	// 			sensors[E].position.set(radius_x - 2, radius_y + (Std.int(radius_height / 2) - 1));
	// 			sensors[F].position.set((radius_x + radius_width) + 2, (Std.int(radius_height / 2) - 1));
	// 		}
	// 	}
	// }

	// just stuff that you dont have to care about
	override function update(elapsed:Float){
		if(FlxG.keys.justPressed.F1)
		{
			developerView = !developerView;
			trace(developerView);
		}

		super.update(elapsed);
	}

	override function draw():Void
	{
		super.draw();

		//white
		color = 0xFFFFFFFF;
		if(developerView)
			color = 0xFF7C7C7C; //// grey
	}

	// state step update function is that you will REALLY worry about
	public function player_update(elapsed:Float){
		primallyUpdate();
		
		stateMachine.update(elapsed);
	}

	function primallyUpdate():Void
	{
		// will flip sonics sprite horizontally
		if(Input.isJustPressed(LEFT) && !Input.isJustPressed(RIGHT))
			flipX = true;
		else if(Input.isJustPressed(RIGHT) && !Input.isJustPressed(LEFT))
			flipX = false;
	}
	
	public function calculateSpeedWithAngle():Void
	{
		speed.x = groundSpeed *  Math.cos(Calculations.degreesToRadians(groundAngle));
		speed.y = groundSpeed * -Math.sin(Calculations.degreesToRadians(groundAngle));	
	}

	override function move(elapsed:Float = 1.66):Void
	{
		super.move(elapsed);
		// ALIGN THE STUFF
		updateOriginPoint(animation.curAnim.name);

		final centerX:Float = (x + origin.x);
		final centerY:Float = (y + origin.y);
		updateRadius(animation.curAnim.name, centerX, centerY);
		updateSensorsPositions(animation.curAnim.name);

		if ((x+16) < 0)
		{
			speed.x = 0;
			x = -16;
		}

		FlxG.watch.addQuick("Players's Position", [Math.floor(x), Math.floor(y)]);

		FlxG.watch.addQuick("Player's XSpeed", speed.x);
		FlxG.watch.addQuick("Player's YSpeed", speed.y);

		//rspr.setPosition(radiusArray[0], radiusArray[2]);
	}

	public function applyGravity():Void
	{
		speed.y += gravityForce;
		if (speed.y > 16) speed.y = 16;
	}

	public function groundCheck():Void
	{
		final sensorResult = giveWinSensor().getTileVertical(PlayState.inst.worldCollisionLayer);
		if (sensorResult[2] > 0)
		{
			grounded = true;
			groundSensorCollision(sensorResult);
		}
		
		FlxG.watch.addQuick("Player's Grounded", grounded);
	}

	public function giveWinSensor():Sensor
	{
		final sensorA:Sensor = sensors[A];
		final sensorB:Sensor = sensors[B];

		var winSensor:Sensor = null;
		
		final colors:Array<FlxColor> = [FlxColor.WHITE, FlxColor.RED];
		if(sensorA.checkTheresATile() && !sensorB.checkTheresATile())
		{
			winSensor = sensorA;
			sensorA.spr.color = colors[1];
			sensorB.spr.color = colors[0];
		}
		else if (sensorB.checkTheresATile() && !sensorA.checkTheresATile())
		{
			winSensor = sensorB;
			sensorB.spr.color = colors[1];
			sensorA.spr.color = colors[0];
		}
		else
			winSensor = sensorA;
		
		return winSensor;
	}

	public function groundSensorCollision(result:Array<Dynamic>):Void
	{
		if (grounded)
		{
			speed.y = 0;
			final tilePos = [result[5], result[6]];
			if (tilePos[0] != 0 && tilePos[1] != 0 && result[0] != 0)
			{
				final anchorY = tilePos[ARRAY_Y]+TILE_SIZE;
				y = (anchorY - result[4]) - this.height;
			}
		}
	}

	private function airCollisionLevel():Void
	{
		var move:String = "";
		if (Math.abs(speed.x) > Math.abs(speed.y))
			move = speed.x < 0 ? "left" : "right";
		else 
			move = speed.y < 0 ? "up" : "down";

		switch (move)
		{
			case "left":

			case "right":

			case "up":

			case "down":
				
		}
		
	}
}

abstract PlayerID(Int) from Int to Int
{
	public static final SONIC:PlayerID = 0;
	public static final TAILS:PlayerID = 1;
	public static final KNUX:PlayerID = 2;
}
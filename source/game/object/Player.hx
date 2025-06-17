package game.object;

import game.collision.Tile;
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

/**
 * The exact original creation date is unknown.
 */
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

	public function new(playerID:PlayerID, level:Tilemap):Void
	{
		super(level);

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
		this.level = level;
		move();
	}

	override function setPositionFromTilemap() {
		trace("level uid" + level.ldtkLevel.uid);
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
			final pushRadius = 10;
			final standRadiusWidth = 9, standHeightRadius = 19;
			// A, B, C, D, E, F
			final sensorPosStand:Array<FlxPoint> = [
				FlxPoint.get(center.x-standRadiusWidth, center.y+standHeightRadius),
				FlxPoint.get(center.x+standRadiusWidth, center.y+standHeightRadius),
				FlxPoint.get(center.x-standRadiusWidth, center.y-standHeightRadius),
				FlxPoint.get(center.x+standRadiusWidth, center.y-standHeightRadius),
				FlxPoint.get(center.x-pushRadius, center.y+8),
				FlxPoint.get(center.x+pushRadius, center.y+8),
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
			sensors[tags[i]].updateSpritePosition();
		}
	}
	
	public function setupSensors():Void
	{
		final tags:Array<Dynamic> = [
			[A, DOWN],
			[B, DOWN],
			[C, UP],
			[D, UP],
			[E, LEFT],
			[F, RIGHT]
		];
		for (i in 0...tags.length)
		{
			sensors.set(tags[i][0], new Sensor(0, 0, tags[i][0], tags[i][1], level));
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
		if(animation.curAnim != null)
		{
			if(animation.curAnim.name != "hurt")
			{
				if(speed.x < 0)
					flipX = true;
				else if(speed.x > 0)
					flipX = false;
			}
		}
	}
	
	public function calculateSpeedWithAngle():Void
	{
		if(groundAngle != 0)
		{
			speed.x = groundSpeed * -Math.cos(Calculations.degreesToRadians(groundAngle));
			speed.y = groundSpeed * -Math.sin(Calculations.degreesToRadians(groundAngle));
		}
		else
		{
			speed.x = groundSpeed;
			speed.y = groundSpeed * -Math.sin(Calculations.degreesToRadians(groundAngle));
		}
		trace(groundAngle);
	}

	override function move(elapsed:Float = 1.66):Void
	{
		super.move(elapsed);
		// ALIGN THE STUFF
		updateOriginPoint(animation.curAnim.name);
		final centerX:Float = (x + origin.x);
		final centerY:Float = (y + origin.y);
		center.x = centerX;
		center.y = centerY;

		updateRadius(animation.curAnim.name, center.x, center.y);
		updateSensorsPositions(animation.curAnim.name);

		if ((x+16) < 0)
		{
			speed.x = 0;
			x = -16;
		}

		FlxG.watch.addQuick("Players's Position", FlxPoint.get(this.x, this.y).toString());
		FlxG.watch.addQuick("Player's Center", center.toString());

		FlxG.watch.addQuick("Player's XSpeed", speed.x);
		FlxG.watch.addQuick("Player's YSpeed", speed.y);

		//rspr.setPosition(radiusArray[0], radiusArray[2]);
	}

	public function applyGravity():Void
	{
		speed.y += gravityForce;
		if (speed.y > 16) speed.y = 16;
	}

	public function wallCollide():Void
	{

	}

	public function groundCollide():Void
	{
		final sensorA = sensors[A];
		final sensorB = sensors[B];

		final tileLeftCoord = Tile.getTargetTileCoordinate(sensorA.cX, sensorA.cY, LEFT, level);
		final tileRightCoord = Tile.getTargetTileCoordinate(sensorB.cX, sensorB.cY, RIGHT, level);

		final nearA = Tile.getTargetTileCoordinate(sensorA.cX, sensorA.cY, DOWN, level);
		final nearB = Tile.getTargetTileCoordinate(sensorB.cX, sensorB.cY, DOWN, level);
		
		if (level.checkTheresTile(nearA.x, nearA.y) || level.checkTheresTile(nearB.x, nearB.y))
		{
			final resolutionLeftA = Tile.getTileHorizontal(sensorA.position.x, sensorA.position.y, tileLeftCoord.x, nearA.y, LEFT, level);
			final resolutionRightB = Tile.getTileHorizontal(sensorB.position.x, sensorB.position.y, tileLeftCoord.x, nearB.y, LEFT, level);
		
			final sensorUsed = sensorB;
			final nearUsed = sensorUsed.tag == B ? nearB : nearA;
			final direction = sensorUsed.tag == B ? RIGHT : LEFT;
			final definitiveCollisionResolutionHorizontal = Tile.getTileHorizontal(sensorUsed.position.x, sensorUsed.position.y, sensorUsed.cX, nearUsed.y, direction, level);
			final definitiveCollisionResolutionVertical  = Tile.getTileVertical(sensorUsed.position.x, sensorUsed.position.y, sensorUsed.cX, nearUsed.y, level);
			if(definitiveCollisionResolutionVertical.distance > -6 && definitiveCollisionResolutionVertical.distance < 14)
			{
				//trace('align ${floor(definitiveCollisionResolutionVertical.distance)} pixels');
				y = floor(definitiveCollisionResolutionVertical.tileSurfaceY - this.height)+1;
				groundAngle = definitiveCollisionResolutionVertical.tileAngle;
			}
		}
		
		FlxG.watch.addQuick("Player's Grounded", this.grounded);
	}

	public function groundSensorCollision(result:Dynamic):Void
	{
		if(result != null)
		{
			if (result.solidity != EMPTY)
			{
				if(result.distance >= 0)
				{
					trace('aligned to ${result.distance} pixels to the ground');
					groundAngle = result.tileAngle;
					y -= result.distance;
					grounded = true;
				}
			}
			else
			{
				return;
			}
		}
	}
	public function giveWinSensorGround():Sensor
	{
		final sensorA:Sensor = sensors[A];
		final sensorB:Sensor = sensors[B];

		var winSensor:Sensor = null;
		final senAcellX = Math.floor(sensorA.position.x / TILE_SIZE); final senAcellY = Math.floor(sensorA.position.y / TILE_SIZE);
		final senBcellX = Math.floor(sensorB.position.x / TILE_SIZE); final senBcellY = Math.floor(sensorB.position.y / TILE_SIZE);
		var targetTileInA:Bool = Tile.checkTheresATile(senAcellX, senAcellY, PlayState.inst.worldCollisionLayer); 
		var targetTileInB:Bool = Tile.checkTheresATile(senBcellX, senBcellY, PlayState.inst.worldCollisionLayer);
		// trace([targetTileInA, targetTileInB]);

		final colors:Array<FlxColor> = [FlxColor.WHITE, FlxColor.RED];
		// scrapped and very broken system
		// if(sensorA.checkTheresATile() && !sensorB.checkTheresATile())
		// {
		// 	winSensor = sensorA;
		// 	sensorA.spr.color = colors[1];
		// 	sensorB.spr.color = colors[0];
		// }
		// else if (sensorB.checkTheresATile() && !sensorA.checkTheresATile())
		// {
		// 	winSensor = sensorB;
		// 	sensorB.spr.color = colors[1];
		// 	sensorA.spr.color = colors[0];
		// }
		// else
		// 	winSensor = sensorA;

		//REAL WINNER SENSOR ALGORYTHM
		final world = PlayState.inst.worldCollisionLayer;
		if(targetTileInA)
		{
			//the position of sensor A can be the target tile
			final tileResA = Tile.getTileHorizontal(sensorA.position.x, sensorA.position.y, senAcellX, senAcellY, LEFT, level);
			final tileResB = Tile.getTileHorizontal(sensorB.position.x, sensorB.position.y, senAcellX, senAcellY, LEFT, level);

			if(tileResA != null || tileResB != null)
			{
				FlxG.watch.addQuick("Sensor A Ground Distance", tileResA.distance);
				FlxG.watch.addQuick("Sensor B Ground Distance", tileResB.distance);
				
				//check if the distance of sensor A is greater than B
				if (tileResA.distance > tileResB.distance)
				{
					winSensor = sensorA;
					sensorA.spr.color = colors[1];
					sensorB.spr.color = colors[0];
				}
				else
				{
					winSensor = sensorB;
					sensorB.spr.color = colors[1];
					sensorA.spr.color = colors[0];
				}
			}
		}
		else if(targetTileInB)
		{
			//the position of sensor B can be the target tile 
			final tileResB = Tile.getTileHorizontal(sensorB.position.x, sensorB.position.y, senBcellX, senBcellY, RIGHT, level);
			final tileResA = Tile.getTileHorizontal(sensorA.position.x, sensorA.position.y, senBcellX, senBcellY, RIGHT, level);
			if(tileResB != null || tileResA != null)
			{
				FlxG.watch.addQuick("Sensor A Ground Distance", tileResA.distance);
				FlxG.watch.addQuick("Sensor B Ground Distance", tileResB.distance);
				
				//check if the distance of sensor B is greater than A
				if (tileResB.distance > tileResA.distance)
				{
					winSensor = sensorB;
					sensorB.spr.color = colors[1];
					sensorA.spr.color = colors[0];
				}
				else
				{
					winSensor = sensorA;
					sensorA.spr.color = colors[1];
					sensorB.spr.color = colors[0];
				}
			}
		}
		else
			winSensor = sensorA;

		FlxG.watch.addQuick('Winner', winSensor.tag.getName());

		return winSensor;
	}

	public function airCollide()
	{
		//air collision			
		final orientationMove:Orientation = abs(speed.x) > abs(speed.y) ? HORIZONTAL : VERTICAL;
		final horizontalMoveDirection:SensorDirection = speed.x > 0 ? RIGHT : LEFT;
		final verticalMoveDirection:SensorDirection	  = speed.y > 0 ? DOWN  : UP;

		if(orientationMove == VERTICAL)
		{
			final senA_CX:Int = floor(sensors[A].position.x / TILE_SIZE);
			final senA_CY:Int = floor(sensors[A].position.y / TILE_SIZE);

			final senB_CX:Int = floor(sensors[B].position.x / TILE_SIZE);
			final senB_CY:Int = floor(sensors[B].position.y / TILE_SIZE);

			final sensorPositionA = sensors[A].position;
			final sensorPositionB = sensors[B].position;
			switch(verticalMoveDirection)
			{
				case UP:
					// TODO
				case DOWN:
					final nearestCoordA = Tile.getTargetTileCoordinate(senA_CX, senA_CY, DOWN, level);
					final nearestTileA = Tile.getTileVertical(sensorPositionA.x, sensorPositionA.y, nearestCoordA.x, nearestCoordA.y, level);

					final nearestCoordB = Tile.getTargetTileCoordinate(senB_CX, senB_CY, DOWN, level);
					final nearestTileB = Tile.getTileVertical(sensorPositionB.x, sensorPositionB.y, nearestCoordB.x, nearestCoordB.y, level);

					if(nearestTileA.solidity != EMPTY || nearestTileB.solidity != EMPTY)
					{
						// who is the winner?
						trace("should have a winner sensor!");
						final nearestLeft = Tile.getTargetTileCoordinate(senA_CX, senA_CY, LEFT, level);
						final nearestRight = Tile.getTargetTileCoordinate(senB_CX, senB_CY, RIGHT, level);

						final touchDistance:Int = floor(-(speed.y+8));
						trace(touchDistance);
						if(nearestTileA.distance >= touchDistance || nearestTileB.distance >= touchDistance)
						{
							trace("the touch distance should be added to the player y!");
							y += abs(touchDistance);
							groundAngle = nearestTileB.distance >= touchDistance ? nearestTileB.tileAngle : nearestTileA.tileAngle;
							grounded = true;
						}
					}
				// they're out of question
				case LEFT | RIGHT:
					return;
			}
		}
	}

	function nearestTileCheckNull(hi:{x:Int, y:Int}):Bool
	{
		return hi.x == -1 && hi.y == -1;
	}
}

abstract PlayerID(Int) from Int to Int
{
	public static final SONIC:PlayerID = 0;
	public static final TAILS:PlayerID = 1;
	public static final KNUX:PlayerID = 2;
}

enum Orientation
{
	HORIZONTAL;
	VERTICAL;
}
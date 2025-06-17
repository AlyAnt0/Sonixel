package game.states.testing;

import game.collision.Tile;
import flixel.math.FlxPoint;
import flixel.FlxG;
import game.collision.Sensor;
import game.base.Object;
import flixel.FlxState;

class PlayerCloneTerrainAlign extends FlxState
{
	public var level:Tilemap;
	public var player:SimplePlayerClone;

	override function create()
	{
		super.create();

		level = new Tilemap(Main.ldtkProject.all_worlds.Default.all_levels.PLAYER_SENSOR_TEST);
		add(level.collisionLayerDebug);

		player = new SimplePlayerClone(level);
		add(player);
		player.addAllSensorsSprites();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		player.player_update();
	}
}

enum State
{
	NORMAL;
	AIRBONE;
}

class SimplePlayerClone extends Object
{
	public var grounded:Bool = false;

	public var groundSpeed:Float = 0;
	public var groundAngle:Float = 0;

	public var accelerationSpeed:Float = 0.046875;
	public var decelerationSpeed:Float = 0.5;
	public var frictionSpeed:Float = 0.046875;
	public var gravityForce:Float = 0.21875;
	public var topSpeed:Float = 6;

	public var stateMachine:State = AIRBONE;

	public function new(level:Tilemap) {
		super(level);

		makeGraphic(48, 48, 0x3FFF0000);
		origin.set(24,28);
		setupSensors();
	}

	override function setPositionFromTilemap() {
		
		final playerX = level.ldtkLevel.l_ENTITIES.all_PLAYERCLONEDEBUG[0].pixelX;
		final playerY = level.ldtkLevel.l_ENTITIES.all_PLAYERCLONEDEBUG[0].pixelY;

		this.setPosition(playerX, playerY);
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

	public function addAllSensorsSprites():Void
	{
		final tags:Array<SensorTag> = [A,B,C,D,E,F];
		for(tag in tags)
		{
			if(FlxG.state != null)
				FlxG.state.add(sensors.get(tag).spr);
		}
	}

	function updateSensorsPositions():Void
	{
		final tags:Array<SensorTag> = [
			A, B, C, D, E, F
		];

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

		for(i in 0...tags.length)
		{
			sensors[tags[i]].position.set(sensorPosStand[i].x, sensorPosStand[i].y);
			sensors[tags[i]].updateSpritePosition();
		}
	}

	override function move(elapsed:Float = 1.66) {
		super.move(elapsed);

		final centerX:Float = (x + origin.x);
		final centerY:Float = (y + origin.y);
		center.x = centerX;
		center.y = centerY;

		updateSensorsPositions();

		FlxG.watch.addQuick("Players's Position", FlxPoint.get(this.x, this.y).toString());
		FlxG.watch.addQuick("Player's Center", center.toString());

		FlxG.watch.addQuick("Player's XSpeed", speed.x);
		FlxG.watch.addQuick("Player's YSpeed", speed.y);
	}

	public function applyGravity():Void
	{
		speed.y += gravityForce;
		if (speed.y > 16) speed.y = 16;
	}

	public function calculateSpeedWithAngle():Void
	{
		speed.x = groundSpeed *  Math.cos(Calculations.degreesToRadians(groundAngle));
		speed.y = groundSpeed * -Math.sin(Calculations.degreesToRadians(groundAngle));	
	}

	public function player_update():Void
	{
		switch(stateMachine)
		{
			case NORMAL:
				stateNormal();
			case AIRBONE:
				stateAirbone();
		}
	}

	function stateNormal():Void
	{

	}

	function stateAirbone():Void
	{
		//https://info.sonicretro.org/SPG:Slope_Collision#While_Airborne
		move();

		applyGravity();

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
					final currentTileA = Tile.getTileVertical(sensorPositionA.x, sensorPositionA.x, senA_CX, senA_CY, level);
					final nearestTileA = Tile.getTileVertical(sensorPositionA.x, sensorPositionA.y, nearestCoordA.x, nearestCoordA.y, level);

					final nearestCoordB = Tile.getTargetTileCoordinate(senB_CX, senB_CY, DOWN, level);
					final currentTileB = Tile.getTileVertical(sensorPositionB.x, sensorPositionB.x, senB_CX, senB_CY, level);
					final nearestTileB = Tile.getTileVertical(sensorPositionB.x, sensorPositionB.y, nearestCoordB.x, nearestCoordB.y, level);

					if(nearestTileA.solidity != EMPTY || nearestTileB.solidity != EMPTY)
					{
						// who is the winner?
						trace("should have a winner sensor!");
						final nearestLeft = Tile.getTargetTileCoordinate(senA_CX, senA_CY, LEFT, level);
						final nearestRight = Tile.getTargetTileCoordinate(senB_CX, senB_CY, RIGHT, level);

						final touchDistance = -(speed.y+8);
						trace(touchDistance);
						if(nearestTileA.distance >= touchDistance || nearestTileB.distance >= touchDistance)
						{
							trace("the winner distance should be added to the player y!");
							y += abs(touchDistance);
							stateMachine = NORMAL;
						}
						// else if(!nearestTileCheckNull(nearestLeft))
						// {
						// 	final winnerDistance = 0;
						// 	// lets see who is the winner for the tile in the left..
						// 	final distanceA = Tile.getTileHorizontal(
						// 		sensorPositionA.x, sensorPositionA.y, 
						// 		nearestLeft.x, nearestLeft.y,
						// 		LEFT, level);
						// 	final distanceB = Tile.getTileHorizontal(
						// 		sensorPositionB.x, sensorPositionB.y, 
						// 		nearestLeft.x, nearestLeft.y,
						// 		LEFT, level);
						// 	trace("left tile winner determination pendent!");
						// }
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

enum Orientation
{
	HORIZONTAL;
	VERTICAL;
}
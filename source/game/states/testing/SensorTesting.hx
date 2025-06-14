package game.states.testing;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import game.collision.Tile;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import game.collision.Sensor;

/**
 * Orignally created in 04.26.24.
 */
class SensorTesting extends FlxState
{
	public var level:Tilemap;

	var testSensor:Sensor;
	var sensorSpr:FlxSprite;

	var surfaceDot:FlxSprite;
	final TILESET_PATH:String = 'assets/images/tileset.png';

	override function create():Void
	{
		final sensor_x:Int = Std.int(FlxG.width / 2), sensor_y:Int = Std.int(FlxG.height / 2); 

		testSensor = new Sensor(sensor_x, sensor_y, A, DOWN);

		sensorSpr = new FlxSprite(testSensor.position.x, testSensor.position.y).makeGraphic(1, 1, 0xFFFFFFFF);
		add(sensorSpr);

		level = new Tilemap(Main.ldtkProject.all_worlds.Default.all_levels.TESTSENSOR);
		add(level.collisionLayerDebug);

		//for seeing if the surface is working, AND THIS IS A PROGRESS!
		placeDotsAtSurface();

		surfaceDot = createDot(-1, -1, 1, FlxColor.BLUE);
		add(surfaceDot);

		FlxG.camera.zoom = 3;
		super.create();
	}

	function placeDotsAtSurface():Void
	{
		final tile = level.collisionTilesTable[getMultipliedCoords(9,6)];
		final surface = tile.heightArray;
		for(x in 0...TILE_SIZE)
		{
			//trace('surface now ' + tile.heightArray[x]);
				
			//the anchor is in bottom
			final anchorY = (tile.posY * TILE_SIZE) + TILE_SIZE-1;
			final finalY = anchorY-surface[x];
			addDot((tile.posX*TILE_SIZE)+x,finalY,1,FlxColor.RED);
		}
		trace(surface);
	}

	override function update(elapsed:Float):Void
	{
		final left:Bool  = FlxG.keys.pressed.LEFT;
		final right:Bool = FlxG.keys.pressed.RIGHT;
		final up:Bool    = FlxG.keys.pressed.UP;
		final down:Bool  = FlxG.keys.pressed.DOWN;

		// gml in haxe
		var mov_x:Int = -binaryBool(left) + binaryBool(right);
		var mov_y:Int = -binaryBool(up) + binaryBool(down);

		var speed:Float = 0.5;

		testSensor.position.x += ((speed)*mov_x);
		testSensor.position.y += ((speed)*mov_y);

		sensorSpr.setPosition(testSensor.position.x, testSensor.position.y);

		distance();

		super.update(elapsed);
	}

	function distance():Void
	{
		final cellX = Math.floor(testSensor.position.x / TILE_SIZE);
		final cellY = Math.floor(testSensor.position.y / TILE_SIZE);
		final scanResult = Tile.getTileVertical(testSensor.position.x, testSensor.position.y, cellX, cellY, level);

		if (level.checkTheresTile(Math.floor(testSensor.position.x / TILE_SIZE), Math.floor(testSensor.position.y / TILE_SIZE)))
		{
			surfaceDot.x = Math.floor(testSensor.position.x);
			surfaceDot.y = scanResult.tileSurfaceY;
		}
		else
		{
			surfaceDot.setPosition(-1,-1);
		}
	}
}
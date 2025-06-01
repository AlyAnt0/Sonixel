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

class SensorTesting extends FlxState
{
	public var worldCollisionLayer:Map<Int, Tile> = [];
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

		var ldtk = Main.ldtkProject;

		final tiles = ldtk.all_worlds.Default.all_levels.testsensor.l_collision;
		final collisionLayerDebug:FlxSpriteGroup = new FlxSpriteGroup();
		for(xx in 0...tiles.cWid)
		{
			for(yy in 0...tiles.cHei)
			{
				if(tiles.hasAnyTileAt(xx, yy))
				{
					//trace('tru');
					for (tiledata in tiles.getTileStackAt(xx, yy))
					{
						// the tile data
						var newCollision = new Tile(xx, yy, tiledata.flipBits & 1 != 0, tiledata.flipBits & 2 != 0, tiledata.tileId);
						worldCollisionLayer[newCollision.posX * newCollision.posY] =  newCollision;
						trace(newCollision.posX);
						trace(newCollision.posY);

						// now the sprite itself
						var tile = new FlxSprite(xx * Global.TILE_SIZE, yy * Global.TILE_SIZE);
						tile.frames = FlxTileFrames.fromBitmapAddSpacesAndBorders(TILESET_PATH, FlxPoint.get(Global.TILE_SIZE, Global.TILE_SIZE));
						tile.frame = tile.frames.frames[tiledata.tileId];
						collisionLayerDebug.add(tile);
					}
				}
			}
		}
		trace('check existence');
		add(collisionLayerDebug);

		//for seeing if the surface is working, AND THIS IS A PROGRESS!
		placeDotsAtSurface();

		surfaceDot = createDot(-1, -1, 1, FlxColor.BLUE);
		add(surfaceDot);

		FlxG.camera.zoom = 3;
		super.create();
	}

	function placeDotsAtSurface():Void
	{
		final tile = worldCollisionLayer[getMultipliedCoords(9,6)];
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
		final scanResult = testSensor.getTileVertical(worldCollisionLayer);

		if (worldCollisionLayer.exists(getMultipliedCoords(Math.floor(testSensor.position.x / TILE_SIZE), Math.floor(testSensor.position.y / TILE_SIZE))))
		{
			surfaceDot.x = Math.floor(testSensor.position.x);
			surfaceDot.y = scanResult[3];
		}
		else
		{
			surfaceDot.setPosition(-1,-1);
		}
	}
}
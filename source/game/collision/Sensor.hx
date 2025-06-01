package game.collision;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import game.object.Player;

enum SensorTag 
{
	A;
	B;
	C;
	D;
	E;
	F;
}

enum SensorFunctions
{
	GROUND;
	LEFT_WALL;
	RIGHT_WALL;
	CEILING;
}

enum SensorDirection
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
}

class Sensor
{
	public var tag:SensorTag = null;
	public var direction:SensorDirection = null;

	public var host:Player;
	public var position:FlxPoint = new FlxPoint();

	public var active:Bool = false;
	public var detectedTile:Bool = false;

	public var spr:FlxSprite;

	public function new(anchor_x:Float, anchor_y:Float, tag:SensorTag = null, direction:SensorDirection)
	{
		this.position.set(anchor_x, anchor_y);
		this.tag = tag;
		this.direction = direction;

		spr = createDot(1,1,1,FlxColor.WHITE);
	}

	public function checkTheresATile(x:Float = 0, y:Float = 0):Bool
	{
		final gridx:Int = Std.int(Math.floor(x)/TILE_SIZE);
		final gridy:Int = Std.int(Math.floor(y)/TILE_SIZE);

		return PlayState.inst.currentLevel.l_collision.hasAnyTileAt(gridx, gridy);
	}

	// it will gets the tile ID, tile angle and the surface distance in width array
	public function getTileHorizontal(x:Float=0, y:Float=0, world:Map<Int, Tile>):Array<Dynamic>
	{
		final tx = x;
		final ty = y;
		final gridx:Int = Std.int(Math.floor(tx)/TILE_SIZE);
		final gridy:Int = Std.int(Math.floor(ty)/TILE_SIZE);

		if(world.exists(getMultipliedCoords(gridx,gridy)))
		{
			final tile = world[getMultipliedCoords(gridx,gridy)];

			final tilePixelsX = tile.posX * TILE_SIZE;
			final tilePixelsY = tile.posY * TILE_SIZE;

			final widthIndex:Int = Math.floor(Math.abs(ty - (tilePixelsY - 1)) - 1);
			final anchorX = tilePixelsX + TILE_SIZE-1;
			final surfaceX = tile.widthArray[widthIndex];
			final finalX = anchorX-surfaceX;

			final distance = position.x-finalX;

			// this is the most crazy array ive made in my programming career
			return [tile.tileIndex, tile.tileAngle, distance, finalX, surfaceX, tilePixelsX, tilePixelsY];
		}

		return [];
	}

	// it will gets the tile ID, tile angle and the surface distance in height array
	public function getTileVertical(x:Float=0, y:Float=0, world:Map<Int, Tile>):Array<Dynamic>
	{
		final tx = x;
		final ty = y;
		final gridx:Int = Std.int(Math.floor(tx)/TILE_SIZE);
		final gridy:Int = Std.int(Math.floor(ty)/TILE_SIZE);

		if(world.exists(getMultipliedCoords(gridx,gridy)))
		{
			final tile = world[getMultipliedCoords(gridx,gridy)];

			final tilePixelsX = tile.posX * TILE_SIZE;
			final tilePixelsY = tile.posY * TILE_SIZE;

			final heightIndex:Int = Math.floor(Math.abs(tx - (tilePixelsX - 1)) - 1);
			final anchorY = tilePixelsY + TILE_SIZE-1;
			final surfaceY = tile.heightArray[heightIndex];
			final finalY = anchorY-surfaceY;

			final distance = position.y-finalY;

			// this is the most crazy array ive made in my programming career
			return [tile.tileIndex, tile.tileAngle, distance, finalY, surfaceY, tilePixelsX, tilePixelsY];
		}

		return [];
	}

	public function getTileHorizontalDouble(x:Float=0, y:Float=0, world:Map<Int,Tile>):Array<Dynamic>
	{
		final tile1 = this?.getTileHorizontal(x, y, world);
		final tile2 = this.direction == RIGHT ? this?.getTileHorizontal(x + TILE_SIZE, y, world) : this?.getTileHorizontal(x - TILE_SIZE, y, world);
		var completeArray = [tile1, tile2];

		return completeArray;
	}

	public function getTileVerticalDouble(x:Float=0, y:Float=0, world:Map<Int,Tile>):Array<Dynamic>
	{
		final tile1 = this?.getTileVertical(x, y, world);
		final tile2 = this.direction != DOWN ? this?.getTileVertical(x, y - TILE_SIZE, world) : this?.getTileVertical(x, y + TILE_SIZE, world);
		var completeArray = [tile1, tile2];

		return completeArray;
	}
}
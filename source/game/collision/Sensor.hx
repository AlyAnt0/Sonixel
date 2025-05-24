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

	public function checkTheresATile(xoffset:Int = 0, yoffset:Int = 0):Bool
	{
		final gridx:Int = Std.int(Math.floor(position.x+xoffset)/TILE_SIZE);
		final gridy:Int = Std.int(Math.floor(position.y+yoffset)/TILE_SIZE);

		return PlayState.inst.currentLevel.l_collision.hasAnyTileAt(gridx, gridy);
	}

	// it will gets the tile ID, tile angle and the surface distance
	public function getTileVertical(world:Map<Int, Tile>):Array<Dynamic>
	{
		final tx = position.x;
		final ty = position.y;
		final gridx:Int = Std.int(Math.floor(tx)/TILE_SIZE);
		final gridy:Int = Std.int(Math.floor(ty)/TILE_SIZE);

		if(world.exists(getMultipliedCoords(gridx,gridy)))
		{
			final tile = world[getMultipliedCoords(gridx,gridy)];

			final tilePixelsX = tile.posX * TILE_SIZE;
			final tilePixelsY = tile.posY * TILE_SIZE;

			final heightIndex:Int = Math.floor(Math.abs(position.x - (tilePixelsX - 1)) - 1);
			final anchorY = tilePixelsY + TILE_SIZE-1;
			final surfaceY = tile.heightArray[heightIndex];
			final finalY = anchorY-surfaceY;

			final distance = position.y-finalY;

			// this is the most crazy array ive made in my programming career
			return [tile.tileIndex, tile.tileAngle, distance, finalY, surfaceY, tilePixelsX, tilePixelsY];
		}

		return [];
	}
}
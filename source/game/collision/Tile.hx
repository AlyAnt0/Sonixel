package game.collision;

import flixel.FlxG;
import game.data.TileData;

enum TileSolidity
{
	EMPTY;
	FULL_SOLID;
	TOP_ONLY;
	TOP_AND_BOTTOM;
}

/**
 * Originally created in 03.28.2024.
 */
class Tile
{
	public var posX:Int = 0;
	public var posY:Int = 0;

	public var solidity:TileSolidity = FULL_SOLID;
	public var tileIndex:Int = 0;
	public var widthArray:Array<Int> = [];
	public var heightArray:Array<Int> = [];
	public var tileAngle:Float = 0;
	public var isJumpThrough:Bool = false;

	public var flipX:Bool = false;
	public var flipY:Bool = false;

	/**
	 * Makes a tile.
	 * @param posX          X Position in 16x16 grid.
	 * @param posY          Y Position in 16x16 grid.
	 * @param index         Provided index to get the Tile Array.
	 */
	public function new(posX:Int, posY:Int, flipX:Bool, flipY:Bool, index:Int)
	{
		this.posX = posX;
		this.posY = posY;
		this.flipX = flipX;
		this.flipY = flipY;

		this.tileIndex = index;

		widthArray	= TileData.getWidthArray(index);
		heightArray = TileData.getHeightArray(index);
		tileAngle   = TileData.getTileAngle(index);

		if(this.flipX)
			heightArray.reverse();
		if(this.flipY)
		{
			//TODO: some algorythm for inverting the height array correctly in flipY
		}
	}

	public static function checkTheresATile(cellX:Int = 0, cellY:Int = 0, coll:Map<Int, Tile>):Bool
		return coll.exists(getMultipliedCoords(cellX, cellY));

	// it will gets the tile ID, tile angle and the surface distance in width array
	public static function getTileHorizontal(x:Float=0, y:Float=0, cellX:Int = 0, cellY:Int = 0, world:Map<Int,Tile>):{index:Int, tileAngle:Float, distance:Float, tileSurfaceX:Int, height:Int, tileX:Int, tileY:Int, solidity:TileSolidity}
	{
		if(world.exists(getMultipliedCoords(cellX, cellY)))
		{
			final tile = world[getMultipliedCoords(cellX, cellY)];

			final tilePixelsX = tile.posX * TILE_SIZE;
			final tilePixelsY = tile.posY * TILE_SIZE;

			final widthIndex:Int = Math.floor(Math.abs(y - (tilePixelsY - 1)) - 1);
			final anchorX = tilePixelsX + TILE_SIZE-1;
			final surfaceX = tile.widthArray[widthIndex];
			final finalX = anchorX-surfaceX;

			final distance = x-finalX;

			// this is the most crazy array ive made in my programming career
			return {
				index: tile.tileIndex,
				tileAngle: tile.tileAngle,
				distance: distance,
				tileSurfaceX: finalX,
				height: surfaceX,
				tileX: tilePixelsX,
				tileY: tilePixelsY,
				solidity: tile.solidity
			};
			// return [tile.tileIndex, tile.tileAngle, distance, finalX, surfaceX, tilePixelsX, tilePixelsY];
		}

		return Global.EMPTY_TILE_HORIZONTAL;
	}

	// it will gets the tile ID, tile angle and the surface distance in height array
	public static function getTileVertical(x:Float=0, y:Float=0, cellX:Int, cellY:Int, world:Map<Int,Tile>):{index:Int, tileAngle:Float, distance:Float, tileSurfaceY:Int, height:Int, tileX:Int, tileY:Int, solidity:TileSolidity}
	{
		if(world.exists(getMultipliedCoords(cellX, cellY)))
		{
			final tile = world[getMultipliedCoords(cellX,cellY)];

			final tilePixelsX = tile.posX * TILE_SIZE;
			final tilePixelsY = tile.posY * TILE_SIZE;

			final heightIndex:Int = Math.floor(Math.abs(x - (tilePixelsX - 1)) - 1);
			final anchorY = tilePixelsY + TILE_SIZE-1;
			final surfaceY = tile.heightArray[heightIndex];
			final finalY = anchorY-surfaceY;

			final distance = y-finalY;
			// this is the most crazy array ive made in my programming career
			return {
				index: tile.tileIndex,
				tileAngle: tile.tileAngle,
				distance: distance,
				tileSurfaceY: finalY,
				height: surfaceY,
				tileX: tilePixelsX,
				tileY: tilePixelsY,
				solidity: tile.solidity
			};
			// return [tile.tileIndex, tile.tileAngle, distance, finalY, surfaceY, tilePixelsX, tilePixelsY];
		}

		return Global.EMPTY_TILE_VERTICAL;
	}



	public static function getTileVerticalDouble(x:Float=0, y:Float=0, offsetx:Float, offsety:Float, world:Map<Int,Tile>)
	{
		var tile1 = Tile.getTileVertical(x, y, Math.floor(x / TILE_SIZE), Math.floor(y / TILE_SIZE), world);
		var tile2 = Tile.getTileVertical(x + offsetx, y + offsety, Math.floor(x / TILE_SIZE), Math.floor(y / TILE_SIZE) + 1, world);

		var nearest = null;
		var nearestString:String =  "";

		final tile1distance:Null<Float> = tile1.solidity != EMPTY ? tile1.distance : null;
		final tile2distance:Null<Float> = tile2.solidity != EMPTY ? tile2.distance : null;
	
		final generalCheck = tile1distance != null || tile2distance != null;

		if (tile1distance > tile2distance && generalCheck)
		{
			nearest = tile1;
			nearestString = "tile 1";
		}
		else if (tile2distance < tile1distance && generalCheck)
		{
			nearest = tile2;
			nearestString = "tile 2";
		}
		else
			return {
				near: null,
				nearStr: "EMPTY tile",
				tile1: null,
				tile2: null
			};
		FlxG.watch.addQuick("nearest", nearestString);

		return {
			near: nearest,
			nearStr: nearestString,
			tile1: tile1,
			tile2: tile2
		};
	}
}
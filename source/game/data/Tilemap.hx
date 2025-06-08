package game.data;

import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import game.collision.Tile;
import flixel.FlxSprite;

/**
 * Class for creating a tilemap instance.
 * 
 * Orignally created in 06.30.2024
 */
class Tilemap
{
	public var collisionTilesTable:Map<Int, Tile> = [];
	public var collisionLayerDebug:FlxSpriteGroup;
	public var ldtkLevel:LdtkProject_Level;

	final COLLISION_TILESET_PATH:String = 'assets/images/tileset.png';

	public function new(level:LdtkProject_Level)
	{
		this.collisionLayerDebug = new FlxSpriteGroup();
		this.ldtkLevel = level;

		if(level.isLoaded())
		{
			final tiles = level.l_COLLISION;
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
							collisionTilesTable[getMultipliedCoords(newCollision.posX, newCollision.posY)] =  newCollision;
	
							// now the sprite itself
							var tile = new FlxSprite(xx * Global.TILE_SIZE, yy * Global.TILE_SIZE);
							tile.frames = FlxTileFrames.fromBitmapAddSpacesAndBorders(COLLISION_TILESET_PATH, FlxPoint.get(Global.TILE_SIZE, Global.TILE_SIZE));
							tile.frame = tile.frames.frames[tiledata.tileId];
							tile.flipX = newCollision.flipX;
							tile.flipY = newCollision.flipY;
							collisionLayerDebug.add(tile);
						}
					}
				}
			}
		}
	}
}
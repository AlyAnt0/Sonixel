package;

import flixel.FlxSprite;
import game.collision.Tile;

/**
 * Originally created in 04.23.2024. 
 */
class Zone
{
	public var chunks:Array<{x:Float, y:Float, blocks: Array<Dynamic>}> = [];
	public var tiles:Array<Tile> = [];
	public var collisionTiles:Array<FlxSprite> = [];
	
	//[tile x, tile y]
	public var tilesPositions:Map<Array<Int>, FlxSprite> = [];
	
	public function load():Void
	{
		
	}
	
	public function sweetChunks():Void
	{
		// go for all the map for check if theres blocks
		/*
		for (xx in 0...Std.int(x + width)){
			for(yy in 0...Std.int(y + height)){
				var CHUNK_SIZE: Int = 128;

				var locationX:  Int = Std.int(xx / CHUNK_SIZE)*CHUNK_SIZE;
				var locationY:  Int = Std.int(yy / CHUNK_SIZE)*CHUNK_SIZE;
				
				//a fucking chunk is now set so we can put fucking blocks in there
				var chunkSetted = {x: locationX, y: locationY, blocks: []};
				//search for the blocks in that area to make the blocks now belongs the chunk
				for(blockx in locationX...Std.int(locationX + CHUNK_SIZE))
				{
					for(blocky in locationY...Std.int(locationY + CHUNK_SIZE))
					{
						// check all the blocks in all the zone
						for(block in tilesPositions)
						{
							var blockLocation:Array<Int> = [Std.int(blockx / 16), Std.int(blocky / 16)];
							//hey tilesPositions you have a block in 90, 32 in this chunk?
							//no
							//YOU FUCKING LIAR BLOCK
							if(tilesPositions.exists(blockLocation))
							{
								//set all the blocks in the chunk belongs to him
								if (blockLocation[0] > chunkSetted.x && blockLocation[0] < chunkSetted.x + CHUNK_SIZE &&
									blockLocation[1] > chunkSetted.y && blockLocation[1] < chunkSetted.y + CHUNK_SIZE)
										chunkSetted.blocks.push(tilesPositions.get(blockLocation));
							}
						}
					}
				}
			}
		}
		*/
	}
}
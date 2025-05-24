package;

import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

/**
 *	Main collision class. 
 */
class Collision
{
	// just suposition for how i will apply it
// 	// colliding with a tile that sensor A wins
// 	final tile = getTile(Math.floor(x / 16)-1, Math.floor(y / 16));
// 	if (tile != null)
// 	{
// 		if (tile.flipX)
// 			winSensor = sensors[A];
// 		else
// 			winSensor = sensors[B];
// 	}
// 
// 	// height and width array stuff
// 	final tile = getTile(Math.floor(winSensor.x/16)+2,Math.floor(winSensor[B].y/16));
// 
// 	//get tile height and width array
// 	final width  = TileData.getDataFromIndex(tile.index).widthArray;
// 	final height = TileData.getDataFromIndex(tile.index).heightArray;
// 
// 	// height
// 	final tilePosX = tile.x*Global.TILE_SIZE; // real pos
// 	
// 	if (winSensor.x > tilePosX && winSensor.x < tilePosX + Global.TILE_SIZE){
// 		final posX = Math.floor(player.x - tilePosX);
// 
// 		final detectedHeight = height[Std.int(posX)];
// 	}else{
// 		posX = tilePosX;
// 	}
}
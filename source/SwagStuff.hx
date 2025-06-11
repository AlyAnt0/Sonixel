package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
/**
 * A class for additional functions
 * @author AlyAnt0
 */

class SwagStuff
{

	public static final ARRAY_X:Int = 0;
	public static final ARRAY_Y:Int = 1;

	public static function binaryBool(bool:Bool):Int
	{
		switch (bool)
		{	
			case true:
				return 1;
			case false:
				return 0;
		}
		return 0;
	}
	
	/**
	 * Stolen from LDTK Haxe API.
	 * Credits go to DeepNight from Dead Cells.
	 */
	public static function getTileCoordinateIndex(xx:Int, yy:Int, currentLevelWidth:Int):Int
		return xx + yy * currentLevelWidth;

	/**
	 * Unused.
	 */
	public static function getMultipliedCoords(xx:Int, yy:Int):Int
		return xx * yy;

	public static function createDot(x:Int, y:Int, ?size:Int = 1, ?color:FlxColor = FlxColor.WHITE):FlxSprite
		return new FlxSprite(x,y).makeGraphic(size, size, color);

	public static function addDot(x:Int, y:Int, ?size:Int = 1, ?color:FlxColor = FlxColor.WHITE)
		if (FlxG.state != null)
			FlxG.state.add(createDot(x,y,size,color));

	/**
	 * SCRAPPED
	 * Load a Tiled Editor map
	 * NOTE: USE TILED EDITOR 1.9 AND MAKE THE TILES LAYER AS A OBJECT LAYER.
	 * @param player 
	 * @return FlxGroup
	 */
// 	public static function loadTiledMap(player:FlxPoint):FlxTilemap
// 	{
// 		var returnArray:FlxTilemapExt = new FlxTilemapExt();
// 
// 		var tileFile:TiledMap = new TiledMap('assets/data/b.tmx');
// 		var tilesLayer:TiledObjectLayer = cast tileFile.getLayer("tilemap");
// 
// 
// 		if(tileFile != null && tilesLayer != null){
// 			for(data in tilesLayer.objects)
// 			{
// 				trace('data: ' + data.x + ' ' + data.y);
// 			}
// 		}
// 
// 		if(tileFile != null){
// 			for(layer in tileFile.layers){
// 				if(layer.type == OBJECT)
// 				{
// 					final curLayer:TiledObjectLayer = cast tileFile.getLayer(layer.name);
// 					if(curLayer != null)
// 					{
// 						switch(curLayer.name)
// 						{
// 							case 'playerstart':
// 								if(player != null){
// 									for(objectData in curLayer.objects){
// 										if(objectData.name == 'player')
// 										{
// 											player.set(objectData.x, objectData.y);
// 											//
// 										}
// 									}
// 								}
// 						}
// 					}
// 				}
// 			}
// 		}
// 			
// 		trace('tiled editor file loaded sucessfully.');
// 		return returnArray;
// 	}
}
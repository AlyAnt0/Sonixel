package game.data;

import haxe.io.Bytes;
import sys.io.File;
import game.structs.TileStruct;

class TileData
{
	public static var widthArray:Array<Array<Int>> = [];
	public static var heightArray:Array<Array<Int>> = [];
	public static var anglesData:Array<Int> = [];
	public static function init(file:String):Void
	{
		function getFileArrays(returnArray:Array<Array<Int>>,bytesData:Bytes):Array<Array<Int>>
		{
			for (i in 0...bytesData.length)
			{
				if(i % 16 == 0)
				{
					final array:Array<Int> = [];
					for(j in 0...15)
						array.push(bytesData.getUInt16(i + j) >> 8); // convert to 8 bits number
					returnArray.push(array);
				}
			}
			return returnArray;
		}
		TileData.heightArray = getFileArrays(TileData.heightArray, File.getBytes("height.bin"));
	}

	/**
	 * Old function made for getting the Tile Array through the provided index, it was made manually without any binary data.
	 * @param index     Provided index to pick up the tile array.
	 * @return          As [Width Array, Height Array, Tile Angle] array.
	 */
	public static function getDataFromIndexManual(index:Int):Array<Dynamic>
	{
		var widthArray:Array<Int> = [];
		var heightArray:Array<Int> = [];
		var tileAngle:Float = 0;

		widthArray.resize(15);
		heightArray.resize(15);

		var tileStruct:TileStruct;

		switch (index)
		{
			case 1:
				widthArray = [0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8];
				heightArray = [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8];
				tileAngle = 0;

			case 153:
				widthArray = [0, 0, 0, 0, 0, 0, 0, 3, 4, 5, 7, 9, 10, 11, 13, 14];
				heightArray = [0, 0, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7, 8, 9, 9, 9];
				tileAngle = 33.75;

			case 221:
				widthArray = [16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16];
				heightArray = [16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16];
				tileAngle = 0;

			default:
				return null;
		}

		return [widthArray, heightArray, tileAngle];
	}

	public static function getTileAngle(tileIndex:Int):UInt
		return TileData.anglesData[tileIndex];
	public static function getWidthArray(tileIndex:Int):Array<UInt> 
		return TileData.widthArray[tileIndex];
	public static function getHeightArray(tileIndex:Int):Array<UInt>
		return TileData.heightArray[tileIndex];
}
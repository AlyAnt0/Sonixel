package game.data;

import game.structs.TileStruct;

class TileData
{
	/**
	 * For getting the Tile Array through the provided index.
	 * @param index     Provided index to pick up the tile array.
	 * @return          As [Width Array, Height Array, Tile Angle] array.
	 */
	public static function getDataFromIndex(index:Int):Array<Dynamic>
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
}
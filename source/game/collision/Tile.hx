package game.collision;

import game.data.TileData;

enum TileSolidity
{
	FULL_SOLID;
	TOP_ONLY;
	TOP_AND_BOTTOM;
}

class Tile
{
	public var posX:Int = 0;
	public var posY:Int = 0;

	public var solidity:TileSolidity = FULL_SOLID;
	public var tileIndex:Int = 0;
	public var widthArray:Array<Int> = [];
	public var heightArray:Array<Int>;
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

		if (index != 0)
		{
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
	}
}
package game.const;

import game.collision.Tile.TileSolidity;

/**
 * Originally created in 21.06.24.
 */
class Global
{
	// Game Initalization global variables.
	public static final WINDOW_NAME:String  = "Sonic Engine";
	public static final GAME_VERSION:String = "dev0.01";

	public static final GAME_WIDTH:Int  = 320;
	public static final GAME_HEIGHT:Int = 240;

	public static final FRAME_RATE:Int = 60;
	public static final GAME_ZOOM:Float = -1;

	public static final SKIP_FLIXEL_TRANSITION:Bool = true;
	public static final START_FULLSCREEN:Bool = false;

	// Tile global variables.
	public static final TILE_SIZE:Int = 16;
	public static final EMPTY_TILE_HORIZONTAL = {
				index: -1,
				tileAngle: 0.0,
				distance: 0.0,
				tileSurfaceX: 0,
				height: 0,
				tileX: -1,
				tileY: -1,
				solidity: TileSolidity.EMPTY
		};
	public static final EMPTY_TILE_VERTICAL = {
				index: -1,
				tileAngle: 0.0,
				distance: -999.0,
				tileSurfaceY: -1,
				height: -1,
				tileX: -1,
				tileY: -1,
				solidity: TileSolidity.EMPTY
		};

	public static final CURRENT_CHUNK_INDEX:Int = 1;
	public static final AVALIABLE_CHUNK_SIZES:Array<Int> = [128, 256];
	
	public static final CHUNK_SIZE:Int = AVALIABLE_CHUNK_SIZES[CURRENT_CHUNK_INDEX];

	public static final CAMERA_SPEED:Float = 2;

	public static final NORMAL_STATE:String = 'NORMAL';
	public static final ROLL_STATE:String = 'ROLL';
	public static final AIRBONE_STATE:String = 'AIRBONE';
	public static final HURT_STATE:String = 'HURT';
}
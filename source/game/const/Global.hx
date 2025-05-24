package game.const;

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
	public static final EMPTY_TILE:Array<Dynamic> = [-1, 0, 0, false];

	public static final CURRENT_CHUNK_INDEX:Int = 1;
	public static final AVALIABLE_CHUNK_SIZES:Array<Int> = [128, 256];
	
	public static final CHUNK_SIZE:Int = AVALIABLE_CHUNK_SIZES[CURRENT_CHUNK_INDEX];

	public static final CAMERA_SPEED:Float = 2;

	public static final NORMAL_STATE:String = 'NORMAL';
	public static final ROLL_STATE:String = 'ROLL';
	public static final AIRBONE_STATE:String = 'AIRBONE';
	public static final HURT_STATE:String = 'HURT';
}
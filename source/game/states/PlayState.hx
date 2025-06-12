package game.states;

import flixel.graphics.frames.FlxTileFrames;
import game.collision.Tile;
import flixel.group.FlxSpriteGroup;
import game.object.Player;
import game.object.BackgroundParallax;
import game.managers.PlayManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;

using flixel.util.FlxSpriteUtil;

/**
 * The original creation date is unknown.
 */
class PlayState extends FlxState
{
	public static var inst(get, never):PlayState;

	public var player:Player;
	
	public var currentLevel:Tilemap;
	public var worldCollisionLayer:Map<Int, Tile> = [];

	public var playManager:PlayManager = new PlayManager();

	public var groundY:Float = 560;
	final TILESET_PATH:String = 'assets/images/tileset.png';

	static function get_inst():PlayState
		return FlxG.state != null ? cast(FlxG.state, PlayState) : null;

	override public function create()
	{
		FlxG.camera.bgColor = 0xFF909090;

		super.create();
		
		#if debug
		createDebugTweaks();
		#end
		playManager.init();

		BackgroundParallax.setupBackground('TEST');

		currentLevel = new Tilemap(Main.ldtkProject.all_worlds.Default.all_levels.TESTLEVEL_S2);
		add(currentLevel.collisionLayerDebug);
		
		player = new Player(PlayerID.SONIC, currentLevel);
		player.setPosition(currentLevel.ldtkLevel.l_ENTITIES.all_PLAYER[0].pixelX, currentLevel.ldtkLevel.l_ENTITIES.all_PLAYER[0].pixelY);
		add(player);

		FlxG.camera.setScrollBoundsRect(0, 0, currentLevel.ldtkLevel.pxWid, currentLevel.ldtkLevel.pxHei);
		FlxG.camera.follow(player, LOCKON, 1);

		// tilemap = new TiledLevel('assets/data/www.tmx');
		// add(tilemap.foregroundTiles);
		// tilemap.loadObjects(inst);
	}
	override public function update(elapsed:Float)
	{
		player.player_update(elapsed);

		super.update(elapsed);

		#if debug
		debugTweaks(elapsed);
		#end
	}

	function createDebugTweaks():Void
	{
		#if STARTLOW
		FlxG.updateFramerate = FlxG.drawFramerate = 3;
		#elseif SENSOR_TEST
		FlxG.switchState(new game.states.testing.SensorTesting());
		#elseif SENSOR_TEST2
		FlxG.switchState(game.states.testing.DualSensorDetect.new);
		#end
	}

	var isLow:Bool = false;
	// a function for tweaks for analysis and bugfixes
	function debugTweaks(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.F5)
		{
			if(FlxG.keys.pressed.ALT)
			{
				FlxG.switchState(game.states.testing.DualSensorDetect.new);
			}
			else
			{
				FlxG.switchState(new game.states.testing.SensorTesting());
			}
			// TODO: another testing state but using differ of how i could making it
		}

		if(FlxG.keys.justPressed.F9)
		{
			isLow = !isLow;

			var FPS:Int = 60;
			if(isLow)
				FPS = 5;
			else
				FPS = 60;

			FlxG.updateFramerate = FlxG.drawFramerate = FPS;
		}
	}

// 	override function draw():Void
// 	{
// 		// debug overlay
// 		if(player.developerView)
// 		{
// 			final radius = player.radius;
// 			//draw radius
// 			debugOverlay.drawRect(radius.x, radius.y, radius.width, radius.height, 0xFFFF0000, {thickness: 2, color: 0xFF0000FF});
// 
// 			final style1:LineStyle = {thickness: 1, color: 0xfffffff};
// 
// 			//dots
// 			// debugOverlay.drawLine(player.sensors.get(A).position.x, player.sensors.get(A).position.y, player.sensors.get(A).position.x, player.sensors.get(A).position.y, style1);
// 			// debugOverlay.drawLine(player.sensors.get(B).position.x, player.sensors.get(B).position.y, player.sensors.get(B).position.x, player.sensors.get(B).position.y, style1);
// 			// debugOverlay.drawLine(player.sensors.get(C).position.x, player.sensors.get(C).position.y, player.sensors.get(C).position.x, player.sensors.get(C).position.y, style1);
// 			// debugOverlay.drawLine(player.sensors.get(D).position.x, player.sensors.get(D).position.y, player.sensors.get(D).position.x, player.sensors.get(D).position.y, style1);
// 			// debugOverlay.drawLine(player.sensors.get(E).position.x, player.sensors.get(E).position.y, player.sensors.get(E).position.x, player.sensors.get(E).position.y, style1);
// 			// debugOverlay.drawLine(player.sensors.get(F).position.x, player.sensors.get(F).position.y, player.sensors.get(F).position.x, player.sensors.get(F).position.y, style1);
// 		}
// 
// 		super.draw();
// 	}
}

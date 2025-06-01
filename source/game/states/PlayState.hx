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

class PlayState extends FlxState
{
	public static var inst(get, never):PlayState;

	public var player:Player;
	
	public var currentLevel:LdtkProject_Level;
	public var worldCollisionLayer:Map<Int, Tile> = [];

	public var playManager:PlayManager = new PlayManager();

	public var groundY:Float = 560;
	final TILESET_PATH:String = 'assets/images/tileset.png';

	static function get_inst():PlayState
		return FlxG.state != null ? cast(FlxG.state, PlayState) : null;

	override public function create()
	{
		FlxG.camera.bgColor = 0xFF909090;

		playManager.init();

		BackgroundParallax.setupBackground('TEST');

		final level = Main.ldtkProject.all_worlds.Default.all_levels.testlevel_s2;
		currentLevel = level;
		final tiles = level.l_collision;
		final collisionLayerDebug:FlxSpriteGroup = new FlxSpriteGroup();
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
						worldCollisionLayer[newCollision.posX * newCollision.posY] =  newCollision;

						// now the sprite itself
						var tile = new FlxSprite(xx * Global.TILE_SIZE, yy * Global.TILE_SIZE);
						tile.frames = FlxTileFrames.fromBitmapAddSpacesAndBorders(TILESET_PATH, FlxPoint.get(Global.TILE_SIZE, Global.TILE_SIZE), FlxPoint.get(2,2));
						tile.frame = tile.frames.frames[tiledata.tileId];
						tile.flipX = newCollision.flipX;
						tile.flipY = newCollision.flipY;
						collisionLayerDebug.add(tile);
					}
				}
			}
		}
		add(collisionLayerDebug);
		player = new Player(PlayerID.SONIC);
		player.setPosition(level.l_entities.all_player[0].pixelX, level.l_entities.all_player[0].pixelY);
		add(player);

		FlxG.camera.setScrollBoundsRect(0, 0, level.pxWid, level.pxHei);
		FlxG.camera.follow(player, LOCKON, 1);

		// tilemap = new TiledLevel('assets/data/www.tmx');
		// add(tilemap.foregroundTiles);
		// tilemap.loadObjects(inst);

		super.create();
	}
	override public function update(elapsed:Float)
	{
		player.player_update(elapsed);

		super.update(elapsed);

		#if debug
		debugTweaks(elapsed);
		#end
	}

	var isLow:Bool = false;
	// a function for tweaks for analysis and bugfixes
	function debugTweaks(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.F5)
		{
			FlxG.switchState(new game.states.testing.SensorTesting());
			if(FlxG.keys.pressed.ALT)
			{
				// TODO: another testing state but using differ of how i could making it
			}
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

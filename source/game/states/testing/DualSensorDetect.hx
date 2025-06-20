package game.states.testing;

import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import game.collision.Tile;
import flixel.FlxG;
import game.collision.Sensor;
import flixel.FlxState;

/**
 * Originally created in 06.07.2025.
 */
class DualSensorDetect extends FlxState
{
	public var level:Tilemap;
	public var testSensor:Sensor;

	public var tileDebug1:FlxSprite;
	public var tileDebug2:FlxSprite;

	public var debugText:FlxText;
	
	override function create() {
		super.create();

		var hudCam = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
		hudCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(hudCam, false);

		level = new Tilemap(Main.ldtkProject.all_worlds.Default.all_levels.TESTSENSOR_2);
		add(level.collisionLayerDebug);

		final square = new FlxSprite().makeGraphic(TILE_SIZE,TILE_SIZE,FlxColor.ORANGE);
		tileDebug1 = square.clone();
		tileDebug2 = square.clone();
		tileDebug1.alpha =  tileDebug2.alpha = 0.3;
		add(tileDebug1);
		add(tileDebug2);

		testSensor = new Sensor(176, 152, A, DOWN, level);
		add(testSensor.spr);

		debugText = new FlxText(2,2,FlxG.width,"Dual",8,true);
		debugText.alignment = LEFT;
		debugText.camera = hudCam;
		add(debugText);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		final left:Bool  = FlxG.keys.pressed.LEFT;
		final right:Bool = FlxG.keys.pressed.RIGHT;
		final up:Bool    = FlxG.keys.pressed.UP;
		final down:Bool  = FlxG.keys.pressed.DOWN;

		// gml in haxe
		var mov_x:Int = -binaryBool(left) + binaryBool(right);
		var mov_y:Int = -binaryBool(up) + binaryBool(down);

		var speed:Float = 0.5;

		testSensor.position.x += ((speed)*mov_x);
		testSensor.position.y += ((speed)*mov_y);

		testSensor.updateSpritePosition();

		final cellX = Math.floor(testSensor.position.x / TILE_SIZE); 
		final cellY = Math.floor(testSensor.position.y / TILE_SIZE);
		final senX = testSensor.position.x;
		final senY = testSensor.position.y;

		final tileCurrentPosition:Bool = level.checkTheresTile(cellX, cellY);

		//Collision Horizontal
		final tileLeft:Bool =  level.checkTheresTile(cellX-1, cellY);
		final tileRight:Bool = level.checkTheresTile(cellX+1, cellY);

		//Collision Vertical
		final tileAbove:Bool = 	level.checkTheresTile(cellX, cellY-1);
		final tileBelow:Bool = 	level.checkTheresTile(cellX, cellY+1);

		final targetCoordinate:{x:Int, y:Int} = Tile.getTargetTileCoordinate(cellX, cellY, testSensor.direction, level);
		trace(targetCoordinate);

		final tileH1 = Tile.getTileHorizontal(senX, senY, cellX, cellY, testSensor.direction, level);
		final tileH2 = Tile.getTileHorizontal(senX, senY, targetCoordinate.x, targetCoordinate.y, testSensor.direction, level);
		final tileV1 = Tile.getTileVertical(senX, senY, cellX, cellY, level);
		final tileV2 = Tile.getTileVertical(senX, senY, targetCoordinate.x, targetCoordinate.y, level);

		//visual debugging
		tileDebug1.setPosition(cellX * TILE_SIZE, cellY * TILE_SIZE);
		tileDebug2.setPosition(targetCoordinate.x * TILE_SIZE, targetCoordinate.y * TILE_SIZE);
		// debugText.text = Tile.checkTheresATile(testSensor.position.x, testSensor.position.y, level.collisionTilesTable) ? "Hey!" : "d";
		FlxG.watch.addQuick("Sensor Pos", testSensor.position);
		FlxG.watch.addQuick("Tile Horizontal 1", tileH1);
		FlxG.watch.addQuick("Tile Horizontal 2", tileH2);
		FlxG.watch.addQuick("Tile Vertical 1", tileV1);
		FlxG.watch.addQuick("Tile Vertical 2", tileV2);
		
		FlxG.watch.addQuick("Is there a tile?",			tileCurrentPosition);
		FlxG.watch.addQuick("Is theres a tile left?", 	tileLeft);
		FlxG.watch.addQuick("Is theres a tile right?", 	tileRight);
		FlxG.watch.addQuick("Is there a tile above?",	tileAbove);
		FlxG.watch.addQuick("Is there a tile below?",	tileBelow);
	}
}
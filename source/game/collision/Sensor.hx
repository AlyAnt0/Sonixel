package game.collision;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import game.object.Player;

enum SensorTag 
{
	A;
	B;
	C;
	D;
	E;
	F;
}

enum SensorFunctions
{
	GROUND;
	LEFT_WALL;
	RIGHT_WALL;
	CEILING;
}

enum SensorDirection
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
}

/**
 * Originally created in 04.25.2024.
 */
class Sensor
{
	public var tag:SensorTag = null;
	public var direction:SensorDirection = null;

	public var host:Player;
	public var position:FlxPoint = new FlxPoint();

	public var active:Bool = false;
	public var detectedTile:Bool = false;

	public var spr:FlxSprite;

	public var debugLayer:FlxSpriteGroup;

	public function new(anchor_x:Float, anchor_y:Float, tag:SensorTag = null, direction:SensorDirection)
	{
		this.position.set(anchor_x, anchor_y);
		this.tag = tag;
		this.direction = direction;

		spr = createDot(1,1,1,FlxColor.WHITE);

		debugLayer = new FlxSpriteGroup();
		debugLayer.visible = false;
		#if debug
		flixel.FlxG.state.add(debugLayer);
		#end
	}

	public function updateSpritePosition():Void
		spr.setPosition(this.position.x, this.position.y);

	public function getTileHorizontalDouble(x:Float=0, y:Float=0, offsetx:Float, offsety:Float, world:Map<Int,Tile>)
	{
		var tile1 = Tile.getTileHorizontal(x, y, world);
		var tile2 = Tile.getTileHorizontal(x + offsetx, y + offsety, world);

		final tile1distance:Float = tile1.distance;
		final tile2distance:Float = tile2.distance;

		// if (tile1distance < tile2distance)
		// 	return tile1;
		// else
		// 	return tile2;
		
		return {tile1: tile1, tile2: tile2};
	}
}
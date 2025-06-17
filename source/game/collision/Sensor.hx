package game.collision;

import flixel.FlxG;
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
	public var cX(get, never):Int;
	public var cY(get, never):Int;
	function get_cX():Int
		return floor(position.x / TILE_SIZE);
	function get_cY():Int
		return floor(position.y / TILE_SIZE);
	
	public var active:Bool = false;
	public var detectedTile:Bool = false;

	public var spr:FlxSprite;
	public var level:Tilemap;

	public var debugLayer:FlxSpriteGroup;

	public function new(anchor_x:Float, anchor_y:Float, tag:SensorTag = null, direction:SensorDirection, level:Tilemap)
	{
		this.position.set(anchor_x, anchor_y);
		this.tag = tag;
		this.direction = direction;

		spr = createDot(1,1,1,FlxColor.WHITE);

		debugLayer = new FlxSpriteGroup();
		debugLayer.visible = false;
	}

	public function updateSpritePosition():Void
	{
		spr.setPosition(this.position.x, this.position.y);
		if(this.tag == B)
			FlxG.watch.addQuick("Sensor Grid Position", [cX, cY]);
	}

	public function hasTileSensorPosition():Bool
		return level.hasTile(this.cX, this.cY);
}
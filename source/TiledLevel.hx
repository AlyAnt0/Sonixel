package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	inline static var c_PATH_LEVEL_TILESHEETS = "assets/data/";

	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	public var player:Sonic;

	var collidableTileLayers:Array<FlxTilemap>;

	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);

		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();

		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE)
				continue;
			var tileLayer:TiledTileLayer = cast layer;
			var tileSet:TiledTileSet = null;

			var processedPath = 'assets/data/tileset1.png';

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, 16, 16, OFF, tileSet.firstGID, 1, 1);

			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundTiles.add(tilemap);
			}
			else
			{
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}

	public function loadObjects(state:PlayState)
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var group:TiledObjectLayer = cast layer;

			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}

	function loadObject(o:TiledObject, g:TiledObjectLayer, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
		{
			y -= g.map.getGidOwner(o.gid).tileHeight;
		}

		switch (o.type.toLowerCase())
		{
			case "player_start":
				// define and set the player
				state.player.setPosition(o.x, o.y);
		}
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				// IMPORTANT: Always collide the map with objects, not the other way around.
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
				{
					return true;
				}
			}
		}
		return false;
	}
}
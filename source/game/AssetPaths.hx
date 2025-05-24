package game;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.system.System;
import openfl.utils.AssetCache;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
enum FileType
{
	IMAGE;
	SOUND;
	MUSIC;
	DATA;
	FONT;
	SHADER;
}


class AssetPaths // thats not that ass that i mean :man_facepalming:
{
	private static var assetTypeMap:Map<FileType, String> = [
		IMAGE => 'images/',
		SOUND => 'sounds/',
		MUSIC => 'musics/',
		DATA => 'data/',
		FONT => 'fonts/',
		SHADER => 'shaders/'
	];

	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory()
	{
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys())
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key))
			{
				// get rid of it
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null)
				{
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		// for (key in currentTrackedSounds.keys())
		// {
		// 	if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
		// 	{
		// 		// trace('test: ' + dumpExclusions, key);
		// 		openfl.Assets.cache.clear(key);
		// 		currentTrackedSounds.remove(key);
		// 	}
		// }
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	public static function getPath(path:String, type:FileType = IMAGE):String		
		return 'assets/' + assetTypeMap[type] + path;

	public static function image(path:String):FlxGraphicAsset
	{
		final imagePath:String = getPath(path + '.png', IMAGE);
		
		if (openfl.utils.Assets.exists(imagePath, IMAGE))
		{
			if (!currentTrackedAssets.exists(imagePath))
			{
				final graphic:FlxGraphic = FlxG.bitmap.add(imagePath, false, imagePath);
				graphic.persist = true;
				currentTrackedAssets.set(imagePath, graphic);
			}
			localTrackedAssets.push(imagePath);

			return currentTrackedAssets.get(imagePath);
		}

		trace('sad horn $path');
		return null;
	}

	public static function sparrowAtlas(path:String)
	{
		return FlxAtlasFrames.fromSparrow(image(path), getPath(path + '.xml'));
	}
}

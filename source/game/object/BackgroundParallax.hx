package game.object;

import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class BackgroundParallax
{
	public static function setupBackground(name:String):Void
	{
		switch(name)
		{
			case 'TEST':
			var gridbitmap = FlxGridOverlay.createGrid(16, 16, 32, 32, true, 0xFF8185BA, 0xFF222637); 

			var backdrop = new FlxBackdrop(gridbitmap, XY);
			add(backdrop);
		}
	}

	static function add(obj:FlxSprite):Void
		if (FlxG.state != null)
			FlxG.state.add(obj);
}
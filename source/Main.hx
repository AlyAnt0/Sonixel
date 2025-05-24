package;

import openfl.display.FPS;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
#if flxstudio
import flixel.addons.studio.FlxStudio;
#end

class Main extends Sprite
{
	public static var ldtkProject = new LdtkProject();
	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	
		setupGame();
	}

	private function setupGame():Void
	{
		addChild(new FlxGame(320, 240, PlayState, 60, 60, true));
		#if flxstudio
		FlxStudio.create();
		#end

		addChild(new FPS(5, 5, 0xFFFFFFFF));
	}
}

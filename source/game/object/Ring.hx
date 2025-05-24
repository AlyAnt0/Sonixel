package game.object;

import game.base.Object;
import game.managers.PlayManager;
import flixel.math.FlxRect;
import flixel.FlxSprite;

class Ring extends Object
{
	public function new(x:Int, y:Int)
	{
		final realX:Int = Math.floor(x * Global.TILE_SIZE), realY:Int = Math.floor(y * Global.TILE_SIZE);

		super();
		loadGraphic('assets/images/Ring.png', true, 16, 16);
		animation.add("idle", [0,1,2,3], 4, true);
		animation.add("get", [4,5,6,7], 4, false);
		animation.play("idle");
		animation.finishCallback = (name:String) -> {
			if(name == "get")
				this.destroy();
		};

		centerOrigin();

		setPosition(realX, realY);

		final ringHitboxPos:Int = 3;
		hitbox.setSize(10, 10);
		hitbox.setPosition(realX + ringHitboxPos, realY + ringHitboxPos);
	}

	public var ringWorth:Int = 1;
	public function onPlayerTouchRing():Void
	{
		if (PlayState.inst.playManager != null)
			PlayState.inst.playManager.info.rings += ringWorth;
		animation.play("get");
	}

	override function restDestroy() {
		super.restDestroy();


	}
}
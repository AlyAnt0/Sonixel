package game.managers;

class PlayManager
{
	public var initialized:Bool = false;
	public var canChange:Bool = false;

	public var curZoneBackground:String = "TEST";

	public var info:PlayInfo;

	public function new() {}

	public function init():PlayManager
	{
		initialized = true;
		canChange = true;

		info = new PlayInfo();

		return this;
	}

	public function setInfoFromLastCheckpoint():Void
	{
		
	}
}

class PlayInfo
{
	public var rings:Int = 0;
	public var score:Int = 0;
	public var time:Float = 0;

	public function new()
	{
		rings	= 0;
		score	= 0;
		time	= 0;
	}
}
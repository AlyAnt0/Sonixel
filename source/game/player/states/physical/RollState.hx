package game.player.states.physical;

class RollState extends State
{
	public function new()
	{
		super();

		id = 'ROLL';
	}

	override function update(elapsed:Float)
	{
		///trace('roll');

		player.move(elapsed);
		//ma brotha write fire code
		//zcvfzczdcafdzx\drsragzfcx\fzgfcxazxdfacxCDFGZXXFGSAVCplayer.move();
	}
}
package game;

/**
 * A class for the calculations and precision stuff.
 * 
 * Credits: https://info.sonicretro.org/SPG:Calculations
 */
class Calculations
{
	public static var SINCOSLIST = [0,6,12,18,25,31,37,43,49,56,62,68,74,80,86,92,97,103,109,115,120,126,131,136,142,147,152,157,162,167,171,176,181,185,189,193,197,201,205,209,212,216,219,222,225,228,231,234,236,238,241,243,244,246,248,249,251,252,253,254,254,255,255,255,
		256,255,255,255,254,254,253,252,251,249,248,246,244,243,241,238,236,234,231,228,225,222,219,216,212,209,205,201,197,193,189,185,181,176,171,167,162,157,152,147,142,136,131,126,120,115,109,103,97,92,86,80,74,68,62,56,49,43,37,31,25,18,12,6,
		0,-6,-12,-18,-25,-31,-37,-43,-49,-56,-62,-68,-74,-80,-86,-92,-97,-103,-109,-115,-120,-126,-131,-136,-142,-147,-152,-157,-162,-167,-171,-176,-181,-185,-189,-193,-197,-201,-205,-209,-212,-216,-219,-222,-225,-228,-231,-234,-236,-238,-241,-243,-244,-246,-248,-249,-251,-252,-253,-254,-254,-255,-255,-255,
		-256,-255,-255,-255,-254,-254,-253,-252,-251,-249,-248,-246,-244,-243,-241,-238,-236,-234,-231,-228,-225,-222,-219,-216,-212,-209,-205,-201,-197,-193,-189,-185,-181,-176,-171,-167,-162,-157,-152,-147,-142,-136,-131,-126,-120,-115,-109,-103,-97,-92,-86,-80,-74,-68,-62,-56,-49,-43,-37,-31,-25,-18,-12,-6];
	public static var ANGLELIST = [0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10,10,11,11,11,11,11,11,11,12,12,12,12,12,12,12,13,13,13,13,13,13,13,14,14,14,14,14,14,14,15,15,15,15,15,15,15,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,0];

	public static function subpixelToDecimal(pixel:Int, subpixel:Int)
	{
		return pixel + (subpixel / 256);
	}

	//Returns a sine value from -256 to 255 (this is done for precision in the original game, divide the result by 256 to get a typical -1 to 1 decimal result)
	public static function angleHexSin(hex_ang:Int)
	{
		var list_index = hex_ang % 256;
		return SINCOSLIST[list_index];
	}

	//Returns a cosine value from -256 to 255 (this is done for precision in the original game, divide the result by 256 to get a typical -1 to 1 decimal result)
	public static function angleHexCos(hex_ang:Int)
	{
		var list_index = (hex_ang + 64) % 256;
		return SINCOSLIST[list_index];
	}

	// Returns a hex angle representing a direction from one point to another. 
	// Effectively these points are represented by [0, 0] and [xdist, ydist]
	public static function angleHexPointDirection(xdist, ydist)
	{
		// Default
		if ((xdist == 0) && (ydist == 0))
			return 64;
			
		// Force positive
		var xx = Math.abs(xdist);
		var yy = Math.abs(ydist);
			
		var angle = 0;
			
		// Get initial angle
		if (yy >= xx)
		{
			final compare:Int = Math.floor((xx * 256) / yy);
			angle = 64 - ANGLELIST[compare];
		}
		else
		{
			final compare:Int = Math.floor((yy * 256) / xx);
			angle = ANGLELIST[compare];
		}
			
		// Check angle
		if (xdist <= 0)
		{
			angle = -angle;
			angle += 128;
		}
			
		if (ydist <= 0)
		{
			angle = -angle;
			angle += 256;
		}
			
		return angle;
	}

	// Returns a degree angle converted from a hex angle
	public static function angleHexToDegrees(hex_ang)
	{
		return ((256 - hex_ang) / 256) * 360;
	}
	
	// Returns a hex angle converted from a degree angle
	public static function angleDegreesToHex(deg_ang)
	{
		return Math.floor(((360 - deg_ang) / 360) * 256);
	}

	public static function radiansToDegrees(rad:Float):Float
	{
		return rad * Math.PI / 180;
	}

	public static function degreesToRadians(deg:Float):Float
	{
		return deg * 180 / Math.PI;
	}
}
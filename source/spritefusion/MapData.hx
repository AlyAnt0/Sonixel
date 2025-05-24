package spritefusion;

typedef MapData = {
	var tileSize:Int;
	var mapWidth:Int;
	var mapHeight:Int;
	var layers:Array<LayerData>;
}

typedef LayerData = {
	var name:String;
	var tiles:Array<TileData>;
	var collider:Bool;
}

typedef TileData = {
	var x:Int;
	var y:Int;
	var id:String;
}
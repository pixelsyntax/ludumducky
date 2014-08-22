package com.pixelsyntax.ducky;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.Assets;
import openfl.geom.Rectangle;

class GameMap extends Sprite {

	var tileSize : Int = 24;
	var tileColumns : Int = 8;
	var tileRows : Int = 8;

	var tileBMPDs : Array<BitmapData>;

	var mapSize : Point;
	var mapData : Array<Int>;

	function new() {

		super();

		loadMapGraphics("assets/tileset_test.png");
		loadMap("assets/maps/test5x5.map");
		drawMap();

	}

	//draw the map from mapData
	function drawMap() {

		for (iy in 0...Math.floor(mapSize.y)){
			for (ix in 0...Math.floor(mapSize.x)){
				var tileData = mapData[ix + iy * Math.floor(mapSize.x)];
				var tileBMPDIndex = getTileIndexFromMapDataByIndex(tileData);
				var tileBitmap = new Bitmap(tileBMPDs[tileBMPDIndex]);

				tileBitmap.x = ix * tileSize;
				tileBitmap.y = iy * tileSize;

				trace("added tile type " + tileBMPDIndex + " at " + tileBitmap.x + ", " + tileBitmap.y);

				addChild(tileBitmap);
			}
		}

	}
	
	function getTileIndexByPosition( tileX : Int, tileY : Int ){

		return tileX + tileY * mapSize.x;

	}


	function getTileIndexFromMapDataByIndex( index : Int ){

		var baseValue = mapData[index];
		

	}

	//load the map layout into mapData and populate mapSize
	function loadMap( mapFileName: String ) {

		mapData = new Array<Int>();
		mapSize = new Point(0,0);

		var mapString = Assets.getText(mapFileName);
		var mapLines = mapString.split('\n');

		//for each line of the mapfile		
		for (i in 0...mapLines.length){
			var mapLine = mapLines[i];
			//only load this if it is not a comment (/) line
			if (mapLine.charAt(0) != "/"){
				
				//update map size
				if (mapLine.length > mapSize.x)
					mapSize.x = mapLine.length;
				mapSize.y += 1;

				for (j in 0...mapLine.length){
					var d = Std.parseInt(mapLine.charAt(j));
					mapData.push(d);
				}
			}

		}

		trace("loaded map:\n"+mapData);

	}

	//load the map tile graphics
	function loadMapGraphics( tilesetFileName : String ) {

		var bitmapData = Assets.getBitmapData(tilesetFileName);
		tileBMPDs = new Array<BitmapData>();
				
		//for each tile in the tilesheet
		for (fy in 0...tileRows){
			for (fx in 0...tileColumns){
				//create a new bmpd
				var bmpd = new BitmapData(tileSize, tileSize, true);
				//copy the relevant section of the tilesheet
				bmpd.copyPixels(
					bitmapData,
					new Rectangle(fx * tileSize, fy * tileSize, tileSize, tileSize),
					new Point(0,0)
				);
	
				//save the tile into the tile bmpd array
				tileBMPDs.push(bmpd);
			}
		}
	}

	//cast an index to a tile type
	function getTileTypeFromIndex( index : Int ){

		switch(index){
			default:
				return tileVoid;
			case 1:
				return solidA;
			case 2:
				return solidB;
			case 3:
				return solidC;
			case 0:
				return empty;
		}

	}

	function getTileVariantIndex( ) {}

}

enum TileType {

	tileVoid;		//vacuum (no floor?) / edge of map / impassable
	solidA;		//normal solid walls, A, B, C, can be destroyed
	solidB;
	solidC;
	empty;		//empty space (with floor)

}
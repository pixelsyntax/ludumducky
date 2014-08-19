package com.pixelsyntax.ducky;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Character extends Sprite {

	var sprite : Sprite;
	var frames : Array<Bitmap>;

	function new(filename : String){

		super();

		loadGraphics(filename, 4, 4);

	}

	//Load ducky spritesheet and cut him up into frames
	function loadGraphics(filename : String, columns : Int, rows : Int){

		sprite = new Sprite();
		
		var bitmapData = Assets.getBitmapData(filename);
		frames = new Array<Bitmap>();
		
		var fsize = 24; //framesize
		for (fy in 0...rows){
			for (fx in 0...columns){
				var bmpd = new BitmapData(fsize, fsize, true);
				bmpd.copyPixels(
					bitmapData,
					new Rectangle(fx * fsize, fy * fsize, fsize, fsize),
					new Point(0,0)
				);
				var bitmap = new Bitmap(bmpd);
				frames.push(bitmap);
				sprite.addChild(bitmap);
				bitmap.visible = false;
			}
		}

		frames[0].visible = true;

	}

}
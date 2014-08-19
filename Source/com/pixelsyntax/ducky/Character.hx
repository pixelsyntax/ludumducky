package com.pixelsyntax.ducky;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Character extends Sprite {

	var framesPerAction = 4;
	var frames : Array<Bitmap>;
	var currentFrameIndex : Int;

	var characterAction : CharacterAction;

	function new(filename : String){

		super();

		currentFrameIndex = 0;
		loadGraphics(filename, framesPerAction, 4);

	}

	//Load ducky spritesheet and cut him up into frames
	function loadGraphics(filename : String, columns : Int, rows : Int){

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
				addChild(bitmap);
				bitmap.visible = false;
			}
		}

		showFrame(0);

	}

	//make the current frame invisible and show a new frame
	function showFrame(frameIndex : Int){

		if (frameIndex > frames.length-1){
			trace("Attempted to show an out of bounds frame");
			frameIndex = frameIndex % frames.length;
		}

		frames[currentFrameIndex].visible = false;
		frames[frameIndex].visible = true;
		currentFrameIndex = frameIndex;

	}

	public function setAction(newAction : CharacterAction){

		chararcterAction = newAction;

	}

	//get the base frame for a given action
	function getActionBaseFrameIndex(action:CharacterAction){

		switch(action){
			case idleRight:
				return 0;
			case idleLeft:
				return framesPerAction;
			case walkRight:
				return framesPerAction*2;
			case walkLeft:
				return framesPerAction*3;
		}

	}

}

enum CharacterAction {
	idleRight;
	idleLeft;
	walkRight;
	walkLeft;
}

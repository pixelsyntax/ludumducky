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
	var currentFrameIndex : Int; //current frame 0>x>framesPerAction
	var prevFrameIndex : Int;
	var facingRight : Bool; //remember if we were facing right last walk

	var characterAction : CharacterAction;

	function new(filename : String){

		super();

		characterAction = walkLeft;

		currentFrameIndex = 0;
		prevFrameIndex = 0;
		loadGraphics(filename, framesPerAction, 4);

		facingRight = true;

	}

	public function setIdle(){

		if (facingRight)
			setAction(idleRight);
		else
			setAction(idleLeft);

	}

	public function setAction(newAction : CharacterAction){

		characterAction = newAction;
		switch(newAction){
			case walkRight, idleRight: 
				facingRight = true;
			default:
				facingRight = false;
		}

	}

	//increment the frame index
	public function frameTick(){

		currentFrameIndex = (currentFrameIndex + 1) % framesPerAction;
		updateSprite();

	}

	//update the displayed bitmap for this sprite
	function updateSprite(){

		showFrame(getActionBaseFrameIndex(characterAction) + currentFrameIndex);

	}

	public function moveDelta(delta:Point){

		x += delta.x;
		y += delta.y;


		if (delta.x > 0)
			facingRight = true;
		if (delta.x < 0)
			facingRight = false;

		if (delta.x != 0 || delta.y != 0){
			setAction((facingRight) ? walkRight : walkLeft);
		} else {
			setIdle();
		}

	}

	//make the current frame invisible and show a new frame
	function showFrame(frameIndex : Int){

		if (frameIndex > frames.length-1){
			trace("Attempted to show an out of bounds frame");
			frameIndex = frameIndex % frames.length;
		}

		frames[prevFrameIndex].visible = false;
		frames[frameIndex].visible = true;
		prevFrameIndex = frameIndex;

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
	}

}

enum CharacterAction {
	idleRight;
	idleLeft;
	walkRight;
	walkLeft;
}

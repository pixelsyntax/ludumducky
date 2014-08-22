package com.pixelsyntax.ducky;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import com.pixelsyntax.ducky.Character;
import com.pixelsyntax.ducky.GameMap;


class Ducky extends Sprite {

	//graphics
	//dimensions
	var scale : Float = 2;
	var screenWidth : Int = 800;
	var screenHeight : Int = 600;
	//ducky
	var duckyBitmapData : BitmapData;
	var duckyFrames : Array<Bitmap>;
	var ducky : Character;
	//background
	var background : Sprite;
	var gameMap : GameMap;
	//layers
	var spriteLayer : Sprite; 		//holds normal sprites
	var reflections : Sprite; 		//inverted transparent sprites
	var reflectionMask : Sprite; 	//mask to cover non reflective areas of reflections layer

	//Controls
	//Input state
	var keyMoveUp : Bool = false;
	var keyMoveDown : Bool = false;
	var keyMoveLeft : Bool = false;
	var keyMoveRight : Bool = false;
	var keyEscape : Bool = false;
	var mouse1 : Bool = false;
	var mouse2 : Bool = false;
	//Input bindings
	var bindKeyUp : UInt;
	var bindKeyDown : UInt;
	var bindKeyLeft : UInt;
	var bindKeyRight : UInt;

	//workaround for add to stage event being fired an extra time due to parent
	//added to stage being passed to children
	var addToStage : Bool = false;

	function new () {

		super();

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		background = new Sprite();
		background.graphics.beginFill(0x663333);
		background.graphics.drawRect(0,0,screenWidth, screenHeight);
		addChild(background);

		gameMap = new GameMap();
		gameMap.scaleX = scale;
		gameMap.scaleY = scale;
		addChild(gameMap);

		spriteLayer = new Sprite();
		spriteLayer.scaleX = scale;
		spriteLayer.scaleY = scale;
		addChild(spriteLayer);

		reflections = new Sprite();
		reflections.scaleX = scale;
		reflections.scaleY = scale;
		addChild(reflections);

		reflectionMask = new Sprite();
		reflectionMask.scaleX = scale;
		reflectionMask.scaleY = scale;
		addChild(reflectionMask);

		keyboardSetup();

		ducky = new Character("assets/ducks.png");
		spriteLayer.addChild(ducky);

	}

	//placeholder hardcoded keyboard bindings
	function keyboardSetup () {

		bindKeyUp = Keyboard.W;
		bindKeyDown = Keyboard.S;
		bindKeyLeft = Keyboard.A;
		bindKeyRight = Keyboard.D;

	}

	function onEnterFrame (e:Event) {
		
		duckyInput();
		ducky.frameTick();

	}

	function duckyInput(){
		
		var delta = new Point(0,0);
		if (keyMoveRight){
			delta.x = 2;
		}
		if (keyMoveLeft){
			delta.x = -2;
		}
		if (keyMoveUp){
			delta.y = -2;
		}
		if (keyMoveDown){
			delta.y = 2;
		}
		
		ducky.moveDelta(delta);
	}


	//setup that can only take place once this object is on the stage and
	//the stage variable has been assigned
	function onAddedToStage(e:Event){

		if (!addToStage){
			addToStage = true;

			//added to stage setup
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			trace("Dimensions " + width + ", "+height);

		}

	}



	function onKeyDown(e:KeyboardEvent){

		switch(e.keyCode){
			case Keyboard.W:
				keyMoveUp = true;
			case Keyboard.S:
				keyMoveDown = true;
			case Keyboard.D:
				keyMoveRight = true;
			case Keyboard.A:
				keyMoveLeft = true;
			default:
				return;
		}

	}

	function onKeyUp(e:KeyboardEvent){

		switch(e.keyCode){
			case Keyboard.W:
				keyMoveUp = false;
			case Keyboard.S:
				keyMoveDown = false;
			case Keyboard.D:
				keyMoveRight = false;
			case Keyboard.A:
				keyMoveLeft = false;
			default: 
				return;
		}

	}

	function onMouseDown(e:MouseEvent){

	}

	function onMouseUp(e:MouseEvent){

	}

}


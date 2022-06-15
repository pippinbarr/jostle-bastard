package;


import org.flixel.FlxState;
import org.flixel.FlxG;

import org.flixel.util.FlxTimer;

import org.flixel.tweens.FlxTween;
import org.flixel.tweens.misc.VarTween;
import org.flixel.tweens.motion.LinearMotion;


class TitleState extends FlxState
{
	private static var TWEEN_TIME:Float = 0.5;
	private static var TITLE_TIME:Float = 1;

	private var jostle:FlxTextWithBG;
	private var bastard:FlxTextWithBG;
	private var pressSpaceText:FlxTextWithBG;
	private var pippin:FlxTextWithBG;

	private var timer:FlxTimer;

	private var jostleColour:Int = 0x00000000;
	private var bastardColour:Int = 0x00000000;

	private var currentTweenTarget:FlxTextWithBG;
	private var nextTweenTarget:FlxTextWithBG;
	private var currentTweenInComplete:Bool = false;
	private var tweeningIn:Bool = false;
	private var tweeningOut:Bool = false;

	private var frames:Int = 0;

	private var bgTimer:FlxTimer;
	private var bgIndex:Int = 0;

	private var changeCount:Int = 0;

	private static var SNARE:String = "assets/mp3/snare/2.mp3";
	private static var KICK:String = "assets/mp3/kick/2.mp3";

	private static var drumPattern:Array<String> = [KICK,"",SNARE,"",KICK,KICK,SNARE,""];
	private static var drumIndex:Int = 0;

	override public function create():Void
	{
		super.create();

		var colourIndex:Int = Math.floor(Math.random() * GameAssets.COLOURS.length);

		FlxG.bgColor = GameAssets.COLOURS[bgIndex];

		// jostle = new FlxTextWithBG(FlxG.width,200,FlxG.width,"JOSTLE",60,"center",0xFFFFFFFF,0xFF000000);
		jostle = new FlxTextWithBG(0,200,FlxG.width,"JOSTLE",60,"center",0xFFFFFFFF,0xFF000000);
		jostle.y = FlxG.height/2 - jostle.height * 1.25;
		jostle.visible = false;
		add(jostle);

		// bastard = new FlxTextWithBG(-FlxG.width,300,FlxG.width,"BASTARD",60,"center",0xFFFFFFFF,0xFF000000);
		bastard = new FlxTextWithBG(0,300,FlxG.width,"BASTARD",60,"center",0xFFFFFFFF,0xFF000000);
		bastard.y = FlxG.height/2 + jostle.height * 0.25;
		bastard.visible = false;
		add(bastard);

		pippin = new FlxTextWithBG(0,360,FlxG.width,"BY PIPPIN BARR",20,"center",0xFFFFFFFF,0xFF000000);
		// pippin.y = FlxG.height/2 + bastard.height * 0.25;
		pippin.visible = false;
		add(pippin);

		// pressSpaceText = new FlxTextWithBG(0,FlxG.height - 40,FlxG.width,"CLICK TO PLAY",18,"center",0xFFFFFFFF,0xFF000000);
		pressSpaceText = new FlxTextWithBG(0,FlxG.height - 40,FlxG.width,"PRESS SPACE TO PLAY",18,"center",0xFFFFFFFF,0xFF000000);
		pressSpaceText.visible = false;
		add(pressSpaceText);

		// bastardTweenIn();

		bgTimer = new FlxTimer();
		timer = new FlxTimer();

		titles();

		FlxG.keyMute = null;
		FlxG.keyVolumeDown = null;
		FlxG.keyVolumeUp = null;
	}


	private function changeBG(t:FlxTimer):Void
	{
		changeCount++;

		if (drumPattern[drumIndex] != "")
		{
			bgIndex = (bgIndex + 1) % GameAssets.COLOURS.length;
			FlxG.bgColor = GameAssets.COLOURS[bgIndex];
			FlxG.play(drumPattern[drumIndex]);
		}
		drumIndex = (drumIndex + 1) % drumPattern.length;

		bgTimer.start(0.125,1,changeBG);
	}


	override public function update():Void
	{
		super.update();

		// if (pressSpaceText.visible == true && FlxG.keys.justPressed("SPACE"))
		if (pressSpaceText.visible == true && FlxG.keys.SPACE)
		{
			pressSpaceText.visible = false;
			FlxG.fade(0xFF000000,0.5,false,fadeOutComplete);
		}
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	// private function bastardTweenIn():Void
	// {
	// 	var bastardTextVarTween:VarTween = new VarTween(bastardTweenInComplete,FlxTween.ONESHOT);
	// 	bastardTextVarTween.tween(jostle,"x",0,TWEEN_TIME);
	// 	var bastardTextTween:FlxTween = addTween(bastardTextVarTween);
	// }


	// private function bastardTweenInComplete():Void
	// {
	// 	bastard.visible = true;
	// 	var jostleTextVarTween:VarTween = new VarTween(jostleTweenInComplete,FlxTween.ONESHOT);
	// 	jostleTextVarTween.tween(bastard,"x",0,TWEEN_TIME);
	// 	var jostleTextTween:FlxTween = addTween(jostleTextVarTween);
	// 	// GameAssets.JOSTLE_MP3.play(true);
	// 	FlxG.play("assets/mp3/snare/2.mp3");
	// }

	// private function jostleTweenInComplete():Void
	// {
	// 	jostle.visible = true;
	// 	// GameAssets.JOSTLE_MP3.play(true);
	// 	var jostleTextVarTween:VarTween = new VarTween(jostleTweenInComplete,FlxTween.ONESHOT);
	// 	jostleTextVarTween.tween(bastard,"x",0,TWEEN_TIME);
	// 	var jostleTextTween:FlxTween = addTween(jostleTextVarTween);

	// 	FlxG.play("assets/mp3/snare/2.mp3");
	// 	pressSpaceText.visible = true;
	// 	bgTimer.start(TWEEN_TIME,1,changeBG);
	// }


	private function titles():Void
	{
		timer.start(TITLE_TIME,1,jostleIn);
	}

	private function jostleIn(t:FlxTimer):Void
	{
		jostle.visible = true;
		FlxG.play(SNARE);
		timer.start(TITLE_TIME,1,bastardIn);
	}

	private function bastardIn(t:FlxTimer):Void
	{
		bastard.visible = true;
		FlxG.play(SNARE);
		timer.start(TITLE_TIME,1,pippinIn);
	}

	private function pippinIn(t:FlxTimer):Void
	{
		pippin.visible = true;
		FlxG.play(SNARE);
		timer.start(TITLE_TIME,1,spaceIn);
	}

	private function spaceIn(t:FlxTimer):Void
	{
		pressSpaceText.visible = true;
		FlxG.play(SNARE);
		// timer.start(TITLE_TIME,1,titlesIn);
		bgTimer.start(1,1,changeBG);
	}



	private function fadeOutComplete():Void
	{
		FlxG.switchState(new AlleyState());
	}
}
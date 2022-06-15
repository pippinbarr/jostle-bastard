
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.misc.VarTween;
import org.flixel.tweens.motion.LinearMotion;


import org.flixel.util.FlxTimer;

import org.flixel.plugin.photonstorm.FlxCollision;

import flash.display.Sprite;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


enum State
{
	FADE_IN;
	TITLE;
	PLAY;
	EXITING;
	ARRESTED;
	STATS;
	COMPLETE;
	FADE_OUT;
}


class SceneState extends FlxState
{
	private static var TITLE_TIME:Float = 1.5;
	private static var TWEEN_TIME:Float = 0.25;
	private static var TITLE_MOVE_SPEED:Int = 3000;
	private static var COP_RESPONSE_TIME:Float = 20;

	public static var colourIndex:Int = 0;

	private var music:Music;

	public var bastard:Bastard;

	private var fadeInNow:Bool = true;

	public var bg:FlxGroup;
	public var display:FlxGroup;
	public var fg:FlxGroup;

	private var others:FlxGroup;
	private var cops:FlxGroup;
	private var furniture:FlxGroup;
	private var trees:FlxGroup;
	private var seats:FlxGroup;

	private var topBound:PhysicsSprite;

	private var groupThinkTimer:FlxTimer;

	private var copsCalled:Bool = false;
	private var copsSent:Bool = false;
	private var copTimer:FlxTimer;
	private var copTimerText:FlxTextWithBG;
	private var copsCalledText:FlxTextWithBG;
	private var copsCalledTimer:FlxTimer;

	private var avengerTimer:FlxTimer;
	private var avengersSent:Bool = false;
	private var avengerText:FlxTextWithBG;

	private var state:State;

	private var physicsEnabled:Bool = true;

	private var arrested:Bool = false;
	private var worked:Bool = false;
	private var served:Bool = false;
	private var fired:Bool = false;

	public static var score:Dynamic;


	private var titleTimer:FlxTimer;
	private var statsTimer:FlxTimer;


	// TEXTS

	private var sceneTitleText:FlxTextWithBG;
	private var sceneSubtitleText:FlxTextWithBG;

	private var sceneTitleString:String = "";
	private var sceneSubtitleString:String = "";

	private var statsRatingWord:FlxTextWithBG;
	private var statsRatingText:FlxTextWithBG;
	private var statsRankWord:FlxTextWithBG;
	private var statsRankText:FlxTextWithBG;
	private var statsBonusText:FlxTextWithBG;

	private var statsBonuses:Array<String>;
	private var bonusHeight:Float = 0;

	private var arrestText:FlxTextWithBG;
	private var successText:FlxTextWithBG;
	private var failText:FlxTextWithBG;
	private var pressSpaceText:FlxTextWithBG;

	private var canParticipate:Bool = true;

	// TWEENS

	private var currentTweenTarget:FlxTextWithBG;
	private var nextTweenTarget:FlxTextWithBG;
	private var currentTweenInComplete:Bool = false;
	private var tweeningIn:Bool = false;
	private var tweeningOut:Bool = false;

	private var tweenTimer:FlxTimer;

	// SCENES

	private var nextScene:Dynamic;
	private var thisSceneType:JostleEnums.SceneType;


	private var recoloured:Bool = false;


	public function new():Void
	{
		super();
	}



	override public function create():Void
	{		
		super.create();

		music = new Music();
		add(music);

		setupColours();

		bg = new FlxGroup();
		add(bg);

		display = new FlxGroup();
		add(display);

		fg = new FlxGroup();
		add(fg);

		others = new FlxGroup();
		cops = new FlxGroup();
		furniture = new FlxGroup();
		trees = new FlxGroup();
		seats = new FlxGroup();

		setupPhysics();

		score = new Score();

		copTimer = new FlxTimer();

		copTimerText = new FlxTextWithBG(0,20,FlxG.width,"COPS!",24,"center",0xFFFFFFFF,0xFF000000);
		// copTimerText.setFormat("Commodore",48,0xFF000000,"right");
		copTimerText.visible = false;
		add(copTimerText);

		copsCalledText = new FlxTextWithBG(-FlxG.width,200,FlxG.width,"THEY CALLED THE COPS",36,"center",0xFFFFFFFF,0xFF000000);
		fg.add(copsCalledText);

		copsCalledTimer = new FlxTimer();

		avengerTimer = new FlxTimer();
		var revengeText:String = "";
		var r:Float = Math.random();
		if (r < 0.2)
		{
			revengeText = "REVENGE!";
		}
		else if (r < 0.4)
		{
			revengeText = "REVENGE! REVENGE!";
		}
		else if (r < 0.6)
		{
			revengeText = "YOU PUSHED AROUND THE WRONG GUY!";
		}
		else if (r < 0.8)
		{
			revengeText = "TIME FOR SOME PAYBACK!";
		}
		else
		{
			revengeText = "NOW YOU'RE GOING TO PAY!";
		}

		avengerText = new FlxTextWithBG(0,FlxG.height - 20 - 24,FlxG.width,revengeText,24,"center",0xFFFFFFFF,0xFF000000);
		avengerText.visible = false;
		fg.add(avengerText);

		successText = new FlxTextWithBG(-FlxG.width,200,FlxG.width,"",48,"center",0xFFFFFFFF,0xFF000000);
		successText.y = FlxG.height/2 - successText.height/2;
		successText.visible = false;
		fg.add(successText);

		failText = new FlxTextWithBG(-FlxG.width,200,FlxG.width,"",48,"center",0xFFFFFFFF,0xFF000000);
		failText.y = FlxG.height/2 - failText.height/2;
		failText.visible = false;
		fg.add(failText);

		arrestText = new FlxTextWithBG(-FlxG.width,200,FlxG.width,"ARRESTED",48,"center",0xFFFFFFFF,0xFF000000);
		arrestText.visible = false;
		fg.add(arrestText);

		pressSpaceText = new FlxTextWithBG(0,FlxG.height - 40,FlxG.width,"PRESS SPACE",18,"center",0xFFFFFFFF,0xFF000000);
		pressSpaceText.visible = false;
		fg.add(pressSpaceText);

		state = FADE_IN;

		statsBonuses = new Array();

		statsTimer = new FlxTimer();
		tweenTimer = new FlxTimer();
		groupThinkTimer = new FlxTimer();

		physicsEnabled = false;

		Story.setupScene();

		// FlxG.mute = true;

		if (fadeInNow)
		{
			fadeIn();
		}
	}


	private function fadeIn():Void
	{		
		FlxG.fade(0xFF000000,0.5,true,fadeInComplete);
		music.fadeIn();
	}


	private function createWalls():Void
	{
		var topWall:Wall = new Wall(0,0,640,8);
		display.add(topWall);

		topBound = new PhysicsSprite(8,60,GameAssets.WALL_TOP_PNG,1,1,1000,false);

		var leftWall:Wall = new Wall(0,8,8,464);
		display.add(leftWall);

		var rightWall:Wall = new Wall(FlxG.width - 8,8,8,464);
		display.add(rightWall);

		var bottomWallLeft:Wall = new Wall(0,FlxG.height - 8,270,100);
		display.add(bottomWallLeft);

		var bottomWallRight:Wall = new Wall(FlxG.width - 270,FlxG.height - 8,271,100);
		display.add(bottomWallRight);
	}


	private function setupPhysics():Void
	{
		Physics.DEBUG_SPRITE = new Sprite();
		FlxG.stage.addChild(Physics.DEBUG_SPRITE);

		Physics.WORLD = new B2World (new B2Vec2 (0,0), true);
		Physics.DEBUG = new B2DebugDraw ();

		var contactListener:JostleContactListener = new JostleContactListener();
		Physics.WORLD.setContactListener(contactListener);

		Physics.DEBUG.setSprite(Physics.DEBUG_SPRITE);
		Physics.DEBUG.setDrawScale(1/Physics.SCALE);
		Physics.DEBUG.setFlags(B2DebugDraw.e_shapeBit);
		Physics.DEBUG_SPRITE.visible = true;

		Physics.WORLD.setDebugDraw(Physics.DEBUG);
	}


	private function showTitle():Void
	{		
		sceneTitleString = Story.getLocationTitle();
		sceneSubtitleString = Story.getRandomAddress();

		titleTimer = new FlxTimer();

		var align:String = "center";
		var color:UInt = 0xFFFFFFFF;

		sceneTitleText = new FlxTextWithBG(-FlxG.width,200,FlxG.width,sceneTitleString,48,align,color,0xFF000000);
		sceneSubtitleText = new FlxTextWithBG(-FlxG.width,sceneTitleText.y + sceneTitleText.height + 20,FlxG.width,sceneSubtitleString,24,align,color,0xFF000000);

		add(sceneTitleText);
		add(sceneSubtitleText);

		titleTweenIn();
	}



	override public function destroy():Void
	{
		// GameAssets.BASTARD = GameAssets.BASTARD_REPLACEMENT;
		// GameAssets.OTHER = GameAssets.OTHER_REPLACEMENT;
		// GameAssets.FURNITURE = GameAssets.FURNITURE_REPLACEMENT;
		// GameAssets.WALL = GameAssets.WALL_REPLACEMENT;
		// GameAssets.HIGHLIGHT = GameAssets.HIGHLIGHT_REPLACEMENT;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed("R"))
		{
			FlxG.switchState(new ApartmentState());					
		}

		switch (state)
		{
			case FADE_IN:
			
			case TITLE:

			case PLAY:
			updatePhysics();
			handleCops();
			handleWanderersSitting();
			handleBastardLeaving();
			handleMusic();

			case ARRESTED:
			if (FlxG.keys.justPressed("SPACE"))
			{
				state = FADE_OUT;
				FlxG.fade(0xFF000000,0.5,false,fadeOutComplete);
				music.fadeOut();
			}


			case EXITING:
			updatePhysics();
			bastard.moveDown();
			if (bastard.y > FlxG.height)
			{
				copTimerText.visible = false;
				score.calculateStats(others,furniture,trees);
				Story.updateAvengerProbability(score.people);
				showStats();
				music.playCompleted();
				state = STATS;
			}

			case STATS:

			case COMPLETE:
			if (FlxG.keys.justPressed("SPACE"))
			{
				state = FADE_OUT;
				FlxG.fade(0xFF000000,0.5,false,fadeOutComplete);
			}

			case FADE_OUT:
		}
	}

	private function handleBastardLeaving():Void
	{
		if (Physics.worldToScreen(bastard.body.getPosition().y) > FlxG.height)
		{
			state = EXITING;
			bastard.inputEnabled = false;
			cast(FlxG.getPlugin(org.flixel.plugin.TimerManager),org.flixel.plugin.TimerManager).clear();

		}
	}


	private function handleWanderersSitting():Void
	{
		for (i in 0...others.members.length)
		{			
			var o:Other = cast(others.members[i],Other);
			if (o == null || !o.active) continue;
			if (o.mode == PATH || o.mode == SEATED) continue;

			for (j in 0...seats.members.length)
			{
				var s:Seat = cast(seats.members[j],Seat);
				if (s == null || !s.active) continue;
				if (s.occupant != null) continue;

				if (Helpers.getDistance(o.hit.getMidpoint(),s.hit.getMidpoint()) < 40 &&
					o.mood == NORMAL && Math.random() < 0.04)
				{
					s.addOccupant(o);
				}
			}
		}
	}


	private function handleGroupThink(t:FlxTimer):Void
	{
		// Check a threshold
		if (score.currentJostleStrength() > 400 || score.people > 20)
		{
			for (i in 0...others.members.length)
			{
				var o:Other = cast(others.members[i],Other);
				if (o == null || !o.active) continue;

				if (Math.random() < 0.7) continue;

				if (o.mode == SEATED) o.seat.removeOccupant();
				if (Math.random() > 0.6) o.changeMood(SCARED);
				else if (Math.random() > 0.8 && o.mood != SCARED) o.changeMood(ANNOYED);
				else if (o.mood != SCARED) o.changeMood(ANGRY);
			}
		}

		t.finished = true;
		t.start(5,1,handleGroupThink);
	}


	private function fadeInComplete():Void
	{
		showTitle();
	}


	private function fadeOutComplete():Void
	{
		FlxG.switchState(Type.createInstance(Story.getNextScene(),[]));		
	}


	private function updatePhysics():Void
	{
		if (!physicsEnabled) return;

		Physics.WORLD.step(1 / 30, 20, 20);
		Physics.WORLD.clearForces();

		Physics.DRAW_DEBUG ? Physics.WORLD.drawDebugData() : true;
	}


	public function setupColours():Void
	{
		// GameAssets.BASTARD = GameAssets.BASTARD_REPLACEMENT;
		// GameAssets.OTHER = GameAssets.BASTARD_REPLACEMENT;
		// GameAssets.FURNITURE = GameAssets.BASTARD_REPLACEMENT;
		// GameAssets.WALL = GameAssets.BASTARD_REPLACEMENT;
		// GameAssets.HIGHLIGHT = GameAssets.BASTARD_REPLACEMENT;

		colourIndex = Math.floor(Math.random() * GameAssets.COLOURS.length);

		// colourIndex = 0;
		GameAssets.BASTARD_REPLACEMENT = GameAssets.COLOURS[colourIndex];

		colourIndex = (colourIndex + 1) % GameAssets.COLOURS.length;
		GameAssets.OTHER_REPLACEMENT = GameAssets.COLOURS[colourIndex];

		colourIndex = (colourIndex + 1) % GameAssets.COLOURS.length;
		GameAssets.FURNITURE_REPLACEMENT = GameAssets.COLOURS[colourIndex];

		colourIndex = (colourIndex + 1) % GameAssets.COLOURS.length;
		GameAssets.WALL_REPLACEMENT = GameAssets.COLOURS[colourIndex];

		colourIndex = (colourIndex + 1) % GameAssets.COLOURS.length;
		GameAssets.HIGHLIGHT_REPLACEMENT = GameAssets.COLOURS[colourIndex];

		colourIndex = (colourIndex + 1) % GameAssets.COLOURS.length;
		FlxG.bgColor = GameAssets.COLOURS[colourIndex];

		// trace("COLOURS ARE:");
		// trace("BASTARD: " + GameAssets.BASTARD);
		// trace("OTHER: " + GameAssets.OTHER);
		// trace("FURNITURE: " + GameAssets.FURNITURE);
		// trace("WALL: " + GameAssets.WALL);

		// trace("COLOUR REPLACEMENTS ARE:");
		// trace("BASTARD: " + GameAssets.BASTARD_REPLACEMENT);
		// trace("OTHER: " + GameAssets.OTHER_REPLACEMENT);
		// trace("FURNITURE: " + GameAssets.FURNITURE_REPLACEMENT);
		// trace("WALL: " + GameAssets.WALL_REPLACEMENT);
		// trace("BG: " + FlxG.bgColor);
	}

	private function settingFinished(t:FlxTimer):Void
	{
		copTimerText.visible = false;
	}





	/////////////////////////
	// 
	// TWEENING
	//
	/////////////////////////


	// TITLE //


	private function titleTweenIn():Void
	{
		sceneTitleText.setText(sceneTitleString);

		sceneTitleText.y = FlxG.height/2 - sceneTitleText.height/2;
		sceneSubtitleText.y = sceneTitleText.y + sceneTitleText.height + 20;
		var titleTextVarTween:VarTween = new VarTween(titleTweenInComplete,FlxTween.ONESHOT);
		titleTextVarTween.tween(sceneTitleText,"x",0,TWEEN_TIME);
		var titleTextTween:FlxTween = addTween(titleTextVarTween);
	}


	private function titleTweenInComplete():Void
	{
		var subtitleTextVarTween:VarTween = new VarTween(subtitleTweenInComplete,FlxTween.ONESHOT);
		subtitleTextVarTween.tween(sceneSubtitleText,"x",0,TWEEN_TIME);
		var subtitleTextTween:FlxTween = addTween(subtitleTextVarTween);
	}

	private function subtitleTweenInComplete():Void
	{
		sceneSubtitleText.setText(sceneSubtitleString);
		titleTimer.start(TITLE_TIME,1,subtitleTweenOut);
	}


	private function subtitleTweenOut(t:FlxTimer):Void
	{
		var subtitleTextVarTween:VarTween = new VarTween(subtitleTweenOutComplete,FlxTween.ONESHOT);
		subtitleTextVarTween.tween(sceneSubtitleText,"x",FlxG.width,TWEEN_TIME);
		var subtitleTextTween:FlxTween = addTween(subtitleTextVarTween);
	}


	private function subtitleTweenOutComplete():Void
	{
		var titleTextVarTween:VarTween = new VarTween(titleTweenOutComplete,FlxTween.ONESHOT);
		titleTextVarTween.tween(sceneTitleText,"x",FlxG.width,TWEEN_TIME);
		var titleTextTween:FlxTween = addTween(titleTextVarTween);
	}


	private function titleTweenOutComplete():Void
	{
		state = PLAY;
		bastard.inputEnabled = true;
		display.setAll("active",true);
		physicsEnabled = true;

		// We'll sometimes send people who want revenge (including into the apartment)
		if (Story.sendAvenger())
		{
			avengerTimer.start(4 + Math.random() * 5,1,sendAvenger);
		}

		// Most of the time we'll send the cops if the bastard has been
		// arrested or evaded arrest in this place before
		if (Story.sendCopsImmediately() && Math.random() > 0.4)
		{
			callTheCops();
		}

		groupThinkTimer.start(5,1,handleGroupThink);
	}



	// STATS //

	private function statsTweenIn(t:FlxTimer):Void
	{
		var ratingWordVarTween:VarTween = new VarTween(ratingWordInComplete,FlxTween.ONESHOT);
		ratingWordVarTween.tween(statsRatingWord,"x",0,TWEEN_TIME);
		var ratingWordTween:FlxTween = addTween(ratingWordVarTween);	
	}

	private function ratingWordInComplete():Void
	{
		var ratingTextVarTween:VarTween = new VarTween(ratingTextInComplete,FlxTween.ONESHOT);
		ratingTextVarTween.tween(statsRatingText,"x",0,TWEEN_TIME);
		var ratingTextTween:FlxTween = addTween(ratingTextVarTween);	
	}

	private function ratingTextInComplete():Void
	{
		var rankWordVarTween:VarTween = new VarTween(rankWordInComplete,FlxTween.ONESHOT);
		rankWordVarTween.tween(statsRankWord,"x",0,TWEEN_TIME);
		var rankWordTween:FlxTween = addTween(rankWordVarTween);
	}

	private function rankWordInComplete():Void
	{
		var rankTextVarTween:VarTween = new VarTween(rankTextInComplete,FlxTween.ONESHOT);
		rankTextVarTween.tween(statsRankText,"x",0,TWEEN_TIME);
		var rankTextTween:FlxTween = addTween(rankTextVarTween);	
	}

	private function rankTextInComplete():Void
	{
		if (statsBonuses.length > 0)
		{
			bonusHeight = statsRankText.y + statsRankText.height + 20;
			var bonus:String = statsBonuses.shift();
			var bonusText:FlxTextWithBG = new FlxTextWithBG(-FlxG.width,bonusHeight,FlxG.width,bonus,12,"center",0xFFFFFFFF,0xFF000000);
			bonusHeight += bonusText.height + 2;
			fg.add(bonusText);
			tweenInOnly(bonusText,0.5,bonusTweenedIn);
		}	
		else
		{
			bonusTextInComplete();
		}
	}


	private function bonusTweenedIn():Void
	{
		if (statsBonuses.length > 0)
		{
			var bonus:String = statsBonuses.pop();
			var bonusText:FlxTextWithBG = new FlxTextWithBG(-FlxG.width,bonusHeight,FlxG.width,bonus,12,"center",0xFFFFFFFF,0xFF000000);
			fg.add(bonusText);
			bonusHeight += bonusText.height + 2;
			tweenInOnly(bonusText,0.5,bonusTweenedIn);
		}
		else
		{
			bonusTextInComplete();
		}		
	}


	private function bonusTextInComplete():Void
	{
		pressSpaceText.visible = true;
		state = COMPLETE;
	}



	// COPS //

	private function sendCops(t:FlxTimer):Void
	{
		if (copsSent) return;

		copTimerText.visible = false;
		copsSent = true;

		var numCops:Int = Story.numCopsToSend();

		for (i in 0...numCops)
		{
			var cop:Cop = new Cop(FlxG.width / 2 - 20 + Math.random() * 10,FlxG.height + 100 * (i+1),bastard);
			cop.active = true;
			display.add(cop);
			cops.add(cop);
		}
	}



	private function sendAvenger(t:FlxTimer):Void
	{
		if (avengersSent) return;

		avengersSent = true;

		avengerText.visible = true;
		avengerText.bg.flicker(10000);
		avengerText.text.flicker(10000);

		var numAvengers:Int = Math.floor(Math.random() * 3) + 1;

		for (i in 0...numAvengers)
		{
			var a:Avenger = new Avenger(FlxG.width / 2 - 12 + Math.random() * 4,FlxG.height + 100 * (i+1),bastard);
			a.active = true;
			display.add(a);
			others.add(a);
		}
	}


	private function handleCops():Void
	{
		if (score.bastardArrested())
		{
			Story.arrested();
			
			bastard.flicker(1000);
			cops.callAll("flicker");
			display.setAll("active",false);
			copTimerText.visible = false;
			music.playArrested();
			state = ARRESTED;
			arrested = true;

			showArrestText(null);
		}

		copTimerText.setText("COPS IN: " + Math.ceil(copTimer.timeLeft));
		if (!copsCalled && score.currentJostleStrength() > Story.sendCopThreshold())
		{
			callTheCops();
		}
	}



	private function callTheCops():Void
	{
		canParticipate = false;

		failText.visible = false;
		successText.visible = false;
		copsCalledText.visible = true;

		copsCalled = true;
		tweenIn(copsCalledText,0.1);
		copsCalledTimer.start(1.2,1,showCopTimer);

	}


	private function handleMusic():Void
	{
		if (music.getTempo() == SLOW && score.currentJostleStrength() > 5)
		{
			music.setTempo(MEDIUM);
		}
		else if (copsCalled && !copsSent)
		{
			music.setFastMode();
		}
		else if (cops.length != 0)
		{
			music.setTempo(FAST);
		}
	}


	private function showCopTimer(t:FlxTimer):Void
	{
		copTimerText.visible = true;
		copTimer.start(Story.timeToSendCops(),1,sendCops);
	}




	// SUCCESS / FAILURE //

	private function showSuccessText(t:FlxTimer):Void
	{
		if (!canParticipate) return;

		successText.visible = true;
		failText.visible = false;
		copsCalledText.visible = false;

		successText.y = FlxG.height/2 - successText.height/2;

		tweenIn(successText,1);
	}

	private function showFailText(t:FlxTimer):Void
	{
		if (!canParticipate) return;

		failText.visible = true;
		successText.visible = false;
		copsCalledText.visible = false;

		failText.y = FlxG.height/2 - failText.height/2;

		tweenIn(failText,1);
	}


	private function showArrestText(t:FlxTimer):Void
	{
		successText.visible = false;
		failText.visible = false;
		arrestText.visible = true;
		tweenTimer.stop();
		tweenTimer.finished = true;

		arrestText.y = FlxG.height/2 - arrestText.height/2;

		tweenIn(arrestText,-1);
	}



	private function tweenInOnly(O:FlxTextWithBG,T:Float,OnComplete:Dynamic):Void
	{
		tweenTimer.stop();
		tweenTimer.finished = true;

		currentTweenInComplete = false;
		currentTweenTarget = O;

		var varTweenIn:VarTween = new VarTween(OnComplete,FlxTween.ONESHOT);
		varTweenIn.tween(currentTweenTarget,"x",0,TWEEN_TIME);
		var tweenIn:FlxTween = addTween(varTweenIn);	

		if (T < 0) return;

		tweenTimer.start(T + 0.5);

		tweeningIn = true;
	}


	private function tweenIn(O:FlxTextWithBG,T:Float):Void
	{
		tweenTimer.stop();
		tweenTimer.finished = true;

		currentTweenInComplete = false;
		currentTweenTarget = O;

		var varTweenIn:VarTween = new VarTween(tweenInComplete,FlxTween.ONESHOT);
		varTweenIn.tween(currentTweenTarget,"x",0,TWEEN_TIME);
		var tweenIn:FlxTween = addTween(varTweenIn);	

		if (T < 0) return;

		tweenTimer.start(T + 0.5,tweenOut);

		tweeningIn = true;
	}

	private function tweenInComplete():Void
	{
		currentTweenInComplete = true;
		tweeningIn = false;
		if (tweenTimer.finished)
		{
			pressSpaceText.visible = true;
		}
	}

	private function tweenOut(t:FlxTimer):Void
	{
		var varTweenOut:VarTween = new VarTween(tweenOutComplete,FlxTween.ONESHOT);
		varTweenOut.tween(currentTweenTarget,"x",FlxG.width,TWEEN_TIME);
		var tweenOut:FlxTween = addTween(varTweenOut);
		tweeningOut = true;
	}

	private function tweenOutComplete():Void
	{
		currentTweenTarget = null;
		tweeningOut = false;
	}


	// SCORE //

	private function showStats():Void
	{
		cast(FlxG.getPlugin(org.flixel.plugin.TimerManager),org.flixel.plugin.TimerManager).clear();

		avengerText.visible = false;
		successText.visible = false;
		failText.visible = false;
		copsCalledText.visible = false;
		copTimerText.visible = false;
		
		// display.setAll("alpha",0.25);
		display.setAll("active",false);
		bastard.active = true;
		bastard.inputEnabled = false;
		bastard.moveDown();

		var rank:String = score.getRank();
		var title:String = score.getTitle();
		var bonus:String = "";

		statsRatingWord = new FlxTextWithBG(-FlxG.width,20,FlxG.width,"RATING",18,"center",0xFFFFFFFF,0xFF000000);
		statsRatingText = new FlxTextWithBG(-FlxG.width,statsRatingWord.y + statsRatingWord.height + 20,FlxG.width,rank,28,"center",0xFFFFFFFF,0xFF000000);
		statsRankWord = new FlxTextWithBG(-FlxG.width,statsRatingText.y + statsRatingText.height + 20,FlxG.width,"RANK",18,"center",0xFFFFFFFF,0xFF000000);
		statsRankText = new FlxTextWithBG(-FlxG.width,statsRankWord.y + statsRankWord.height + 20,FlxG.width,title,28,"center",0xFFFFFFFF,0xFF000000);

		addBonuses();

		add(statsRatingWord);
		add(statsRatingText);
		add(statsRankWord);
		add(statsRankText);

		statsTimer.start(1,1,statsTweenIn);
	}


	private function addBonuses():Void
	{
		// POSITIVE

		if (score.currentJostleStrength() == 0)
		{
			addToBonus("+ NO TOUCHING");
		}
		if (score.currentJostleStrength() > 0 && score.currentJostleStrength() < 5)
		{
			addToBonus("+ GENTLE GIANT");
		}
		if (worked)
		{
			addToBonus("+ HARD WORKER");
		}
		if (served)
		{
			addToBonus("+ VALUED CUSTOMER");
		}

		// EMOTIONS
		if (score.scared > 5)
		{
			addToBonus("+ SCARE TACTICS");
		}
		if (score.angered + score.annoyed > 5)
		{
			addToBonus("+ MR. UNPOPULAR");
		}

		// NEGATIVE

		if (fired)
		{
			addToBonus("+ DOES NOT WORK WELL WITH OTHERS");
		}
		if (score.ko > 1000)
		{
			addToBonus("+ HEAVYWEIGHT CHAMPION");
		}
		if (copsCalled && !copsSent)
		{
			addToBonus("+ SMOOTH CRIMINAL");
		}
		if (score.cops >= 5)
		{
			addToBonus("+ RESISTING ARREST");
		}
		if (copsSent && !arrested)
		{
			addToBonus("+ THE GETAWAY");
		}
		if (avengersSent)
		{
			addToBonus("+ \"FAN CLUB\"");
		}
		if (served)
		{
			addToBonus("+ YOU GOT SERVED");
		}
		if (score.furniture > 50)
		{
			addToBonus("+ FURNITURE HATER");
		}
		if (score.b_into_w > 50 && thisSceneType != PARK)
		{
			addToBonus("+ CLIMBING THE WALLS");
		}
		if (score.kid > 50)
		{
			addToBonus("+ CRUELTY TO CHILDREN");
		}
		if (score.riccochet > score.direct)
		{
			addToBonus("+ RICCOCHET RICK");
		}
		if (score.direct > score.riccochet)
		{
			addToBonus("+ THE PERSONAL TOUCH");
		}

		// trace("Furnitures: " + furniture.members.length);
		var thief:Bool = calculateThief();

		if (thief && thisSceneType != APARTMENT && furniture.members.length != 0)
		{
			addToBonus("+ BLATANT THIEF");
		}
		else if (thief && thisSceneType == APARTMENT && furniture.members.length != 0)
		{
			addToBonus("+ YOU CAN TAKE IT WITH YOU");
		}

		var kidnapper:Bool = calculateKidnapper();

		if (kidnapper && thisSceneType == CLASSROOM && others.members.length != 0)
		{
			addToBonus("+ KIDNAPPER");
		}
		else if (kidnapper && others.members.length != 0)
		{
			addToBonus("+ HOSTAGE SITUATION");
		}

		if (statsBonuses.length == 0)
		{
			statsBonuses.push("+ VANILLA");
		}
	}


	private function calculateThief():Bool
	{
		for (i in 0...furniture.members.length)
		{
			var f:FlxSprite = cast(furniture.members[i],FlxSprite);
			if (f == null) continue;

			if (f.y > FlxG.height)
			{
				return true;
			}
		}

		return false;	
	}


	private function calculateKidnapper():Bool
	{
		for (i in 0...others.members.length)
		{
			var o:FlxSprite = cast(others.members[i],FlxSprite);
			if (o == null) continue;

			if (o.y > FlxG.height)
			{
				return true;
			}
		}

		return false;	
	}


	private function addToBonus(S:String):Void
	{
		statsBonuses.push(S);
	}
}
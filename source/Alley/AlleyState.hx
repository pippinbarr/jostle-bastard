
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;
import org.flixel.util.FlxPoint;

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



enum TutorialState
{
	PRE;
	INTRO;
	DIRECTIONS;
	KEYS;
	FINAL;
	FINALFINAL;
	POST;
}



class AlleyState extends SceneState
{					
	private var tutor:Tutor;
	private var victim:Other;

	private var tutorTrigger:FlxSprite;
	private var tutorText:FlxTextWithBG;
	private var tutorialState:AlleyState.TutorialState;

	private var anyKeyJustPressed:Bool = false;


	override public function create():Void
	{
		super.create();

		createWalls();

		bastard = new Bastard(FlxG.width / 2 - 80,FlxG.height - 80);
		display.add(bastard);

		tutor = new Tutor(Std.int(FlxG.width / 2) - 8,Std.int(FlxG.height - 100),bastard);
		display.add(tutor);
		others.add(tutor);

		tutorTrigger = new FlxSprite(tutor.x - 100,tutor.y + 20);
		tutorTrigger.makeGraphic(200,100,0xFFFF0000);
		tutorTrigger.visible = false;
		tutorTrigger.alpha = 0.5;
		add(tutorTrigger);

		tutorText = new FlxTextWithBG(-FlxG.width,300,FlxG.width,"I'M HERE TO TELL YOU HOW TO JOSTLE PEOPLE.",24,"center",0xFFFFFFFF,0xFF000000);
		fg.add(tutorText);

		victim = new Other(FlxG.width - 80,32,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL);
		display.add(victim);
		others.add(victim);
		
		thisSceneType = ALLEY;

		tutorialState = PRE;
	}


	override private function createWalls():Void
	{
		var leftWall:Wall = new Wall(0,0,224,FlxG.height + 200);
		display.add(leftWall);

		var topWall:Wall = new Wall(leftWall.width,0,Std.int(FlxG.width - leftWall.width),8);
		display.add(topWall);

		var rightWall:Wall = new Wall(FlxG.width - 8,topWall.height,8,Std.int(FlxG.height - topWall.height));
		display.add(rightWall);

		var rightBlock:Wall = new Wall(FlxG.width - 256 - 8,FlxG.height - 352,Std.int(FlxG.width - 256 - 8),500);
		display.add(rightBlock);

		var topBound:PhysicsSprite = new PhysicsSprite(10,60,GameAssets.WALL_TOP_PNG,1,1,1000,false);
	}


	override public function destroy():Void
	{
		super.destroy();

		display.destroy();
	}


	override public function update():Void
	{
		super.update();


		switch (state)
		{
			case FADE_IN:

			case TITLE:

			case PLAY:
			tutor.changeMood(NORMAL);
			tutor.changeMode(STILL);
			handleTutorial();

			case ARRESTED:

			case EXITING:

			case STATS:

			case FADE_OUT:

			case COMPLETE:
		}

		display.sort("depth");
	}



	private function handleTutorial():Void
	{
		checkAnyKey();

		switch (tutorialState)
		{
			case PRE:
			if (bastard.hit.overlaps(tutorTrigger))
			{
				tutorialState = INTRO;
				tweenIn(tutorText,-1);
				bastard.inputEnabled = false;
				physicsEnabled = false;
				anyKeyJustPressed = false;
			}

			case INTRO:
			if (currentTweenTarget == null)
			{
				tutorialState = DIRECTIONS;
				tutorText.setText("THIS GAME IS PLAYED WITH YOUR ARROW-KEYS AND THE SPACE BAR.");
				tutorText.x = -FlxG.width;
				tweenIn(tutorText,-1);
			}
			else if (currentTweenInComplete && !tweeningOut)
			{
				pressSpaceText.visible = true;
				if (FlxG.keys.justPressed("SPACE"))
				{
					pressSpaceText.visible = false;
					tweenOut(null);
				}
			}

			case DIRECTIONS:
			if (currentTweenTarget == null)
			{
				tutorialState = KEYS;
				tutorText.setText("PRESS THE SPACE BAR TO RUN FASTER.\nRUN FASTER JOSTLE HARDER!");
				tutorText.x = -FlxG.width;
				tweenIn(tutorText,-1);
			}
			else if (currentTweenInComplete && !tweeningOut)
			{
				pressSpaceText.visible = true;
				if (FlxG.keys.justPressed("SPACE"))
				{
					pressSpaceText.visible = false;
					tweenOut(null);
				}
			}

			case KEYS:
			if (currentTweenTarget == null)
			{
				tutorialState = FINAL;
				tutorText.setText("YOU GOT IT? ARE YOU SURE?");
				tutorText.x = -FlxG.width;
				tweenIn(tutorText,-1);
			}
			else if (currentTweenInComplete && !tweeningOut)
			{
				pressSpaceText.visible = true;
				if (FlxG.keys.justPressed("SPACE"))
				{
					pressSpaceText.visible = false;
					tweenOut(null);
				}
			}

			case FINAL:
			if (currentTweenTarget == null)
			{
				tutorialState = FINALFINAL;
				var gender:String;
				if (Math.random() > 0.5) gender = "MAN";
				else gender = "WOMAN";
				tutorText.setText("NOW GO AHEAD AND JOSTLE THE " + gender + " AROUND THE CORNER AND THEN LEAVE.");
				tutorText.x = -FlxG.width;
				tweenIn(tutorText,-1);
			}
			else if (currentTweenInComplete && !tweeningOut)
			{
				pressSpaceText.visible = true;
				if (FlxG.keys.justPressed("SPACE"))
				{
					pressSpaceText.visible = false;
					tweenOut(null);
				}
			}

			case FINALFINAL:
			if (currentTweenTarget == null)
			{
				tutorialState = POST;
				bastard.inputEnabled = true;
				physicsEnabled = true;
			}
			else if (currentTweenInComplete && !tweeningOut)
			{
				pressSpaceText.visible = true;
				if (FlxG.keys.justPressed("SPACE"))
				{
					pressSpaceText.visible = false;
					tweenOut(null);
				}
			}

			case POST:
		}
	}


	override private function handleCops():Void
	{
		// No arrests.
	}



	// SCORE //


	private function checkAnyKey():Void
	{
		if (FlxG.keys.any() && !anyKeyJustPressed)
		{
			anyKeyJustPressed = true;
		}
		else if (!FlxG.keys.any())
		{
			anyKeyJustPressed = false;
		}
	}


	override private function showStats():Void
	{
		super.showStats();
	}


	override private function addBonuses():Void
	{
		if (victim.jostled)
		{
			addToBonus("+ GOOD STUDENT");
		}
		if (tutor.jostled)
		{
			addToBonus("+ NOW I AM THE MASTER");
		}
		super.addBonuses();
	}
}

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



enum JailStateState
{
	JAILED;
	FREE;
}



class JailState extends SceneState
{					
	private var jailor:Jailor;
	private var bastardCell:Cell;

	private var inmates:FlxGroup;

	private var jailState:JailStateState;

	private var jailTimer:FlxTimer;
	private var jailTimeText:FlxTextWithBG;


	override public function create():Void
	{
		super.create();

		bastard = new Bastard(55,60);
		display.add(bastard);

		jailor = new Jailor(Std.int(FlxG.width / 2),Std.int(160));
		jailor.moveLeft();
		display.add(jailor);
		
		inmates = new FlxGroup();

		createWalls();
		createCells();

		sceneTitleString = "JAIL";
		sceneSubtitleString = "AN UNKNOWN LOCATION";

		jailState = JAILED;

		jailTimeText = new FlxTextWithBG(0,8,FlxG.width,"JAIL TIME REMAINING: " + 0,18,"center",0xFFFFFFFF,0xFF000000);
		fg.add(jailTimeText);
		jailTimeText.visible = false;

		jailTimer = new FlxTimer();

		thisSceneType = JAIL;

		display.callAll("updatePosition");
		display.setAll("active",false);
	}


	private function jailTimeFinished(t:FlxTimer):Void
	{
		successText.setText("JAIL UNIT COMPLETED");
		showSuccessText(null);
		bastardCell.open();
		jailTimeText.visible = false;
	}


	private function createCells():Void
	{
		bastardCell = new Cell(24,16);
		display.add(bastardCell);

		var cell:Cell = new Cell(Std.int(bastardCell.x + bastardCell.width + - 16),Std.int(bastardCell.y));
		display.add(cell);

		var inmate:Other = new Other(
			cell.x + cell.width / 4 + 40 * Math.random(),
			cell.y + 30 + Math.random() * 10,
			GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
		others.add(inmate);
		display.add(inmate);
		inmates.add(inmate);

		var cell2:Cell = new Cell(Std.int(cell.x + cell.width + - 16),Std.int(cell.y));
		display.add(cell2);

		var inmate2:Other = new Other(
			cell2.x + cell2.width / 4 + 40 * Math.random(),
			cell2.y + 30 + Math.random() * 10,
			GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
		others.add(inmate2);
		display.add(inmate2);
		inmates.add(inmate2);

		var cell3:Cell = new Cell(Std.int(bastardCell.x),Std.int(FlxG.height - 16 - bastardCell.height));
		display.add(cell3);
		var inmate3:Other = new Other(
			cell3.x + cell3.width / 4 + 40 * Math.random(),
			cell3.y + 30 + Math.random() * 10,
			GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
		others.add(inmate3);
		inmates.add(inmate3);
		display.add(inmate3);

		var cell4:Cell = new Cell(Std.int(cell2.x),Std.int(FlxG.height - 16 - bastardCell.height));
		display.add(cell4);
		var inmate4:Other = new Other(
			cell4.x + cell4.width / 4 + 40 * Math.random(),
			cell4.y + 30 + Math.random() * 10,
			GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
		others.add(inmate4);
		inmates.add(inmate4);
		display.add(inmate4);
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
			jailTimeText.setText("JAIL TIME REMAINING: " + Math.ceil(jailTimer.timeLeft));
			updateInmates();

			case ARRESTED:

			case EXITING:

			case STATS:

			case FADE_OUT:

			case COMPLETE:
		}

		display.sort("depth");
	}


	private function updateInmates():Void
	{
		if (Math.random() < 0.005)
		{
			for (i in 0...inmates.members.length)
			{
				if (inmates.members[i] != null)
				{
					if (Math.random() < 0.1)
					{
						cast(inmates.members[i],Other).changeMood(ANGRY);
					}
				}
			}
		}
	}


	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (copsCalled)
		{
			statsRatingText.setText("E");
			statsRankText.setText("ESCAPED CONVICT");
		}
		else if (SceneState.score.currentJostleStrength() == 0)
		{
			statsRatingText.setText("A");
			statsRankText.setText("MODEL PRISONER");
		}
		else if (SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("A-");
			statsRankText.setText("GOOD BEHAVIOUR");
		}
		else if (SceneState.score.currentJostleStrength() < 100)
		{
			statsRatingText.setText("BBBB");
			statsRankText.setText("CAGED HEAT");
		}
		else if (SceneState.score.currentJostleStrength() < 500 )
		{
			statsRatingText.setText("BBBBBBBB");
			statsRankText.setText("HARDENED CRIMINAL");
		}
		else if (SceneState.score.currentJostleStrength() < 1000)
		{
			statsRatingText.setText("BBBBBBBBBBBB");
			statsRankText.setText("CAGED ANIMAL");
		}
		else
		{
			statsRatingText.setText("BBBBBBBBBBBBBBBBB");
			statsRankText.setText("PRISON BREAKER");
		}
	}


	override private function addBonuses():Void
	{
		if (!arrested)
		{
			addToBonus("+ FREE AS A BIRD");
		}

		super.addBonuses();
	}



	override private function titleTweenOutComplete():Void
	{
		super.titleTweenOutComplete();

		jailTimer.start(Story.getJailTime(),1,jailTimeFinished);
		jailTimeText.visible = true;
	}


	override private function handleCops():Void
	{
		if (SceneState.score.bastardArrested())
		{
			Story.arrested();
			bastard.flicker(1000);
			cops.callAll("flicker");
			display.setAll("active",false);
			physicsEnabled = false;
			state = ARRESTED;
			arrested = true;
			arrestText.setText("REPEAT OFFENDER");
			showArrestText(null);
		}
		if (!copsCalled && SceneState.score.currentCopJostleStrength() > 0)
		{
			copsCalled = true;
			sendCops(null);
		}
	}

	override private function sendCops(t:FlxTimer):Void
	{
		// copTimerText.visible = false;

		var numCops:Int = 5;

		for (i in 0...numCops)
		{
			var cop:Cop = new Cop(FlxG.width / 2 - 20 + Math.random() * 10,FlxG.height + 100 * (i+1),bastard);
			display.add(cop);
			cops.add(cop);
			cops.setAll("active",true);
		}
	}
}
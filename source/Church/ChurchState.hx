

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


class ChurchState extends SceneState
{				
	private static var PRAYER_UNIT_AMOUNT:Int = 30 * 10;
	private static var PREACHING_UNIT_AMOUNT:Int = 30 * 10;

	private var preachingTrigger:FlxSprite;
	private var preachingTimer:FlxTimer;
	private var preaching:Bool = false;
	private var preachingComplete:Bool = false;
	private var preachingTime:Int = 0;

	private var prayerTrigger:FlxSprite;
	private var prayerTimer:FlxTimer;
	private var praying:Bool = false;
	private var prayerComplete:Bool = false;
	private var prayerTime:Int = 0;

	private var bastardPew:PhysicsSprite;
	private var altar:PhysicsSprite;

	private var priest:Other;

	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		createWalls();
		createWindows();
		createPews();
		createAltar();

		prayerTimer = new FlxTimer();
		prayerTimer.finished = true;

		preachingTimer = new FlxTimer();
		preachingTimer.finished = true;

		successText.setText("PRAYER UNIT COMPLETED");
	}


	private function createWindows():Void
	{
		var windows:PhysicsSprite = new PhysicsSprite(0,0,GameAssets.CHURCH_WINDOWS_PNG,1,1,10000,false,false);
		windows.recolour();
		display.add(windows);
	}


	private function createAltar():Void
	{
		altar = new PhysicsSprite(34*8,18*8,GameAssets.CHURCH_ALTAR_PNG,0.2,1,5,true,false);
		altar.recolour();
		display.add(altar);
		furniture.add(altar);

		priest = new Other(altar.x + 2*8,altar.y - 5*8,GameAssets.PERSON_STANDING_PNG,null,null,STILL,null);
		display.add(priest);
		others.add(priest);	

		preachingTrigger = new FlxSprite(altar.x,altar.hit.y - 30);
		preachingTrigger.makeGraphic(Std.int(altar.hit.width),30);
		preachingTrigger.x = altar.x;
		preachingTrigger.y = altar.hit.y - 30;

		// add(preachingTrigger);	
	}



	private function createPews():Void
	{
		createPew(2*8,27*8);
		createPew(2*8,38*8);
		createPew(2*8,49*8);
		createPew(47*8,27*8);
		createPew(47*8,38*8);
		createPew(47*8,49*8);


		prayerTrigger = new FlxSprite(0,0);
		prayerTrigger.makeGraphic(5*8,20,0xFFFF0000);
		prayerTrigger.x = bastardPew.x + (3*8*8);
		prayerTrigger.y = bastardPew.hit.y - 20;
		// add(prayerTrigger);
	}


	private function createPew(X:Float,Y:Float):Void
	{
		var pew:PhysicsSprite = new PhysicsSprite(X,Y,GameAssets.CHURCH_PEW_PNG,0.2,1.0,10,true,false);
		pew.recolour();
		display.add(pew);
		furniture.add(pew);

		for (i in 0...4)
		{
			// if (X == 2*8 && Y == 27*8 && i == 3)
			if (X == 2*8 && Y == 27*8 && i == 3)
			{
				bastardPew = pew;
				continue;
			}
			// if (Math.random() > 0.4)
			// {
				var v:Other = new Other(X + (i * 8*8),Y - 4*8 - 4,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL,null);
				display.add(v);
				others.add(v);
			// }
		}
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
			handlePraying();
			handlePreaching();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handlePraying():Void
	{
		prayerTrigger.x = bastardPew.x + (3*8*8);
		prayerTrigger.y = bastardPew.hit.y - 20;

		if (prayerComplete) return;


		if (prayerTimer.finished && bastard.hit.overlaps(prayerTrigger) && !prayerComplete)
		{
			prayerTimer.start(1,1,startPraying);
		}
		else if (!bastard.hit.overlaps(prayerTrigger))
		{
			prayerTimer.stop();
			prayerTimer.finished = true;
		}

		if (praying)
		{
			prayerTime++;
			if (prayerTime >= PRAYER_UNIT_AMOUNT)
			{
				prayerTimer.stop();
				prayerTimer.finished = true;
				prayerComplete = true;
				successText.setText("PRAYER UNIT COMPLETE");
				showSuccessText(null);
			}
		}
	}


	private function startPraying(t:FlxTimer):Void
	{
		praying = true;
	}



	private function handlePreaching():Void
	{
		preachingTrigger.x = altar.x;
		preachingTrigger.y = altar.hit.y - 30;

		if (preachingComplete) return;


		if (preachingTimer.finished && bastard.hit.overlaps(preachingTrigger) && !preachingComplete)
		{
			preachingTimer.start(1,1,startPreaching);
		}
		else if (!bastard.hit.overlaps(preachingTrigger))
		{
			preachingTimer.stop();
			preachingTimer.finished = true;
		}

		if (preaching)
		{
			preachingTime++;
			if (preachingTime >= PREACHING_UNIT_AMOUNT)
			{
				preachingTimer.stop();
				preachingTimer.finished = true;
				preachingComplete = true;
				successText.setText("PREACHING UNIT COMPLETE");
				showSuccessText(null);
			}
		}
	}


	private function startPreaching(t:FlxTimer):Void
	{
		preaching = true;
	}

	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (preachingComplete)
		{
			statsRatingText.setText("P");
			statsRankText.setText("SON OF A PREACHER MAN");
		}
		else if (prayerComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("SON OF GOD");
		}
		else if (prayerComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("A");
			statsRankText.setText("DEVOUT");
		}
		else if (prayerComplete && SceneState.score.currentJostleStrength() >= 10)
		{
			statsRatingText.setText("B");
			statsRankText.setText("PROBLEM PRAYER");
		}		
	}


	override private function addBonuses():Void
	{
		if (prayerComplete && SceneState.score.currentJostleStrength() > 500)
		{
			addToBonus("+ DEEPLY CONFLICTED");
		}
		if (!prayerComplete && SceneState.score.currentJostleStrength() > 500)
		{
			addToBonus("+ DAMNED ALL TO HELL");
		}
		if (prayerComplete)
		{
			addToBonus("+ THE POWER OF PRAYER");
		}
		if (preachingComplete)
		{
			addToBonus("+ PULLPIT PASSION");
		}
		if (priest.jostled)
		{
			addToBonus("+ PRIEST PUSHER");
		}
		super.addBonuses();
	}
}






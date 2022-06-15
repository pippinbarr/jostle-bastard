
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


class OfficeState extends SceneState
{				
	private static var WORK_UNIT_AMOUNT:Int = 30 * 10;

	private var bastardDesk:PhysicsSprite;
	private var deskTrigger:FlxSprite;
	private var deskTimer:FlxTimer;
	private var working:Bool = false;
	private var workComplete:Bool = false;
	private var workTime:Int = 0;

	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		createWalls();
		createDesks();

		deskTimer = new FlxTimer();
		deskTimer.finished = true;

		successText.setText("WORK UNIT COMPLETED");
	}


	private function createDesks():Void
	{
		createDesk(2*8,10*8);
		createDesk(2*8,26*8);
		createDesk(2*8,42*8);

		createDesk(31*8,10*8);
		createDesk(31*8,26*8);
		createBastardDesk(31*8,42*8);

		createDesk(60*8,10*8);
		createDesk(60*8,26*8);
		createDesk(60*8,42*8);

	}


	private function createDesk(X:Float,Y:Float):Void
	{
		var desk:PhysicsSprite = new PhysicsSprite(X,Y,GameAssets.DESK_PNG,0.2,0.25,5,true,false);
		desk.loadGraphic(GameAssets.DESK_PNG,true,false,144,72,true);
		desk.addAnimation("work",[0,1,2,3,3,2,1,0],2 + Std.int(Math.random() * 3),true);
		desk.play("work");
		desk.kind = FURNITURE;
		desk.recolour();

		display.add(desk);

		var w:Worker = new Worker(X + 48,Y - 25,bastard,desk);

		display.add(w);
		others.add(w);
	}


	private function createBastardDesk(X:Float,Y:Float):Void
	{
		bastardDesk = new PhysicsSprite(X,Y,GameAssets.DESK_PNG,0.2,0.25,5,true,false);
		bastardDesk.loadGraphic(GameAssets.DESK_PNG,true,false,144,72);
		bastardDesk.addAnimation("work",[0,1,2,3,3,2,1,0],2 + Std.int(Math.random() * 3),true);
		bastardDesk.kind = FURNITURE;

		display.add(bastardDesk);

		deskTrigger = new FlxSprite(bastardDesk.x + bastardDesk.width/4,bastardDesk.hit.y - bastardDesk.hit.height*2);
		deskTrigger.makeGraphic(Std.int(bastardDesk.hit.width/2),Std.int(bastardDesk.hit.height*2),0xFFFF0000);
		deskTrigger.x = bastardDesk.x + bastardDesk.width/2 - deskTrigger.width/2;
		deskTrigger.y = bastardDesk.hit.y - bastardDesk.hit.height*2;

		// add(deskTrigger);
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
			handleWork();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleWork():Void
	{

		deskTrigger.x = bastardDesk.x + bastardDesk.width/2 - deskTrigger.width/2;
		deskTrigger.y = bastardDesk.hit.y - bastardDesk.hit.height*2;

		if (workComplete) return;


		if (deskTimer.finished && bastard.hit.overlaps(deskTrigger) && !workComplete)
		{
			deskTimer.start(1,1,startWork);
		}
		else if (!bastard.hit.overlaps(deskTrigger))
		{
			deskTimer.stop();
			bastardDesk.pauseAnimation();
			deskTimer.finished = true;
		}

		if (working)
		{
			workTime++;
			if (workTime >= WORK_UNIT_AMOUNT)
			{
				deskTimer.stop();
				deskTimer.finished = true;
				workComplete = true;
				worked = true;
				bastardDesk.frame = bastardDesk.frame;
				bastardDesk.pauseAnimation();
				showSuccessText(null);
			}
		}
	}


	private function startWork(t:FlxTimer):Void
	{
		working = true;
		bastardDesk.play("work");
	}


	override private function showArrestText(t:FlxTimer):Void
	{
		super.showArrestText(t);

		if (arrested)
		{
			fired = true;
			Story.fired();
			arrestText.setText("ARRESTED\n(AND FIRED)");
		}
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (copsCalled)
		{
			fired = true;
			Story.fired();
			statsRatingText.setText("F");
			statsRankText.setText("FIRED");	
		}
		else if (workComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("VALUED EMPLOYEE");
		}
		else if (workComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("A");
			statsRankText.setText("DISRUPTIVE EMPLOYEE");
		}
		else if (!workComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("L");
			statsRankText.setText("LAYABOUT");	
		}
		else if (!workComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("LC");
			statsRankText.setText("COMPANY LIABILITY");	
		}
		else if (!workComplete)
		{
			var warning:Int = Story.getJobWarning();
			if (warning == 1)
			{

				statsRatingText.setText("V");
				statsRankText.setText("VERBAL WARNING");	
			}
			else if (warning == 2)
			{

				statsRatingText.setText("W");
				statsRankText.setText("WRITTEN WARNING");	
			}
			else
			{
				fired = true;
				Story.fired();
				statsRatingText.setText("F");
				statsRankText.setText("FIRED");		
			}
		}
	}


	override private function addBonuses():Void
	{
		if (workComplete)
		{
			addToBonus("+ OFFICE DRONE");
		}
		if (!workComplete)
		{
			addToBonus("+ WILL NOT WORK FOR PAY");
		}
		if (SceneState.score.currentJostleStrength() > 1000)
		{
			addToBonus("+ FALLING DOWN");
		}
		super.addBonuses();
	}

}







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


class ClassroomState extends SceneState
{				
	private static var TEACHING_UNIT_AMOUNT:Int = 30 * 10;

	private var bastardDesk:PhysicsSprite;
	private var blackboard:PhysicsSprite;
	private var teachingTrigger:FlxSprite;
	private var teachingTimer:FlxTimer;
	private var teaching:Bool = false;
	private var teachingComplete:Bool = false;
	private var teachingTime:Int = 0;
	private var handledKnockdowns:Bool = false;

	private var students:FlxGroup;

	override public function create():Void
	{
		super.create();

		students = new FlxGroup();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		createWalls();
		createDesks();
		createChalkBoard();

		teachingTimer = new FlxTimer();
		teachingTimer.finished = true;

		successText.setText("TEACHING UNIT COMPLETED");
	}


	private function createDesks():Void
	{
		createDesk(10*8,34*8);
		createDesk(25*8,34*8);

		createDesk(10*8,44*8);
		createDesk(25*8,44*8);

		createDesk(10*8,54*8);
		createDesk(25*8,54*8);

		createDesk(49*8,34*8);
		createDesk(64*8,34*8);

		createDesk(49*8,44*8);
		createDesk(64*8,44*8);

		createDesk(49*8,54*8);
		createDesk(64*8,54*8);

		createBastardDesk(10*8,17*8);
	}


	private function createDesk(X:Float,Y:Float):Void
	{
		var desk:PhysicsSprite = new PhysicsSprite(X,Y,GameAssets.STUDENT_DESK_PNG,0.2,0.25,5,true,false);
		desk.kind = FURNITURE;
		desk.recolour();

		var chair:StudentSeat = new StudentSeat(X + 8,Y - 3*8,FlxObject.RIGHT);
		var s:Student = new Student(chair.x,chair.y + 10,bastard,WANDER,chair);
		chair.addOccupant(cast(s,Other));

		furniture.add(desk);
		furniture.add(chair);

		display.add(desk);
		display.add(chair);
		display.add(s);
		others.add(s);
		students.add(s);
	}


	private function createBastardDesk(X:Float,Y:Float):Void
	{
		bastardDesk = new PhysicsSprite(X,Y,GameAssets.TEACHER_DESK_PNG,0.2,1,5,true,false);
		bastardDesk.kind = FURNITURE;
		bastardDesk.recolour();

		display.add(bastardDesk);

		teachingTrigger = new FlxSprite(bastardDesk.x + bastardDesk.width/4,bastardDesk.hit.y - bastardDesk.hit.height*2);
		teachingTrigger.makeGraphic(Std.int(bastardDesk.hit.width/2),Std.int(bastardDesk.hit.height*2),0xFFFF0000);
		teachingTrigger.x = bastardDesk.x + bastardDesk.width/4;
		teachingTrigger.y = bastardDesk.hit.y - bastardDesk.hit.height*2;

		// add(teachingTrigger);
	}


	private function createChalkBoard():Void
	{
		blackboard = new PhysicsSprite(28*8,4*8,GameAssets.BLACKBOARD_ANIM_PNG,0.2,1/23,10,true,false);
		blackboard.loadGraphic(GameAssets.BLACKBOARD_ANIM_PNG,true,false,216,152,true);
		blackboard.recolour(true);
		blackboard.addAnimation("teaching",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],1,false);
		display.add(blackboard);
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
			handleTeaching();
			handleKnockdowns();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleTeaching():Void
	{
		teachingTrigger.x = bastardDesk.x + bastardDesk.width/4;
		teachingTrigger.y = bastardDesk.hit.y - bastardDesk.hit.height*2;

		if (teachingComplete) return;
		if (!canParticipate) return;


		if (teachingTimer.finished && bastard.hit.overlaps(teachingTrigger) && !teachingComplete)
		{
			teachingTimer.start(1,1,startTeaching);
		}
		else if (!bastard.hit.overlaps(teachingTrigger))
		{
			teachingTimer.stop();
			teachingTimer.finished = true;
			blackboard.pauseAnimation();
		}

		if (teaching)
		{
			teachingTime++;
			// if (teachingTime >= TEACHING_UNIT_AMOUNT)
			if (blackboard.finished)
			{
				teachingTimer.stop();
				teachingTimer.finished = true;
				teachingComplete = true;
				worked = true;
				showSuccessText(null);
			}
		}
	}


	private function startTeaching(t:FlxTimer):Void
	{
		teaching = true;
		blackboard.play("teaching");
	}


	private function handleKnockdowns():Void
	{
		if (handledKnockdowns) return;
		if (SceneState.score.ko == 0) return;

		for (i in 0...students.members.length)
		{
			var s:Student = cast(students.members[i],Student);
			if (s == null || !s.active) continue;

			if (Math.random() > 0.2)
			{
				if (s.mode == SEATED)
				{
					s.seat.getUp();
				}
				s.changeMood(SCARED);
			}
		}

		handledKnockdowns = true;
	}


	override private function showArrestText(t:FlxTimer):Void
	{
		super.showArrestText(t);

		if (arrested)
		{
			Story.fired();
			fired = true;
			arrestText.setText("ARRESTED\n(AND FIRED)");
		}
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (copsCalled || SceneState.score.kid > 5 || SceneState.score.furniture > 50)
		{
			Story.fired();
			fired = true;
			statsRatingText.setText("F");
			statsRankText.setText("FIRED");	
		}
		else if (teachingComplete && SceneState.score.kid == 0 && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("MR. CHIPS");
		}
		else if (!teachingComplete)
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
		if (teachingComplete)
		{
			addToBonus("+ OH CAPTAIN MY CAPTAIN");
		}
		if (!teachingComplete)
		{
			addToBonus("+ SCHOOL'S FOR SUCKERS");
		}
		super.addBonuses();
	}
}







import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;


class GymState extends SceneState
{				
	private static var WORKOUT_UNIT_AMOUNT:Int = 30 * 10;

	private var bastardDesk:PhysicsSprite;
	private var workoutTrigger:FlxSprite;
	private var workoutTimer:FlxTimer;
	private var workingout:Bool = false;
	private var workoutComplete:Bool = false;
	private var workoutTime:Int = 0;

	private var othersWorkingOut:Bool = true;

	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		createWalls();
		createMats();

		var boomBox:PhysicsSprite = new PhysicsSprite(18*8,12*8,GameAssets.BOOMBOX_PNG,0.25,1,1,true,false);
		boomBox.kind = FURNITURE;
		boomBox.recolour();
		display.add(boomBox);
		furniture.add(boomBox);

		workoutTimer = new FlxTimer();
		workoutTimer.finished = true;

		successText.setText("EXERCISE UNIT COMPLETED");
	}
	

	private function createMats():Void
	{
		createMat(8*8,28*8);
		createMat(8*8,44*8);

		createMat(25*8,28*8);
		createMat(25*8,44*8);

		createMat(42*8,28*8);
		createMat(42*8,44*8,false,false);

		createMat(59*8,28*8);
		createMat(59*8,44*8);

		createMat(33*8,14*8,true);
	}


	private function createMat(X:Float,Y:Float,Instructor:Bool = false,Occupied:Bool = true):Void
	{
		var mat:PhysicsSprite = new PhysicsSprite(X,Y,"",0.0,0.0,5,true,false,13*8,3*8,GameAssets.WALL_REPLACEMENT);
		display.add(mat);

		if (Occupied)
		{
			var e:Exercizer;
			if (Instructor)
			e = new Exercizer(X + 20,Y - 60,bastard,mat);			
			else
			e = new Exercizer(X + 40,Y - 60,bastard,mat);
			display.add(e);
			others.add(e);
		}
		else
		{
			workoutTrigger = new FlxSprite(X,Y);
			workoutTrigger.makeGraphic(Std.int(mat.width/2),Std.int(mat.height/2),0xFFFF0000);
			workoutTrigger.x = mat.x + mat.width/2 - workoutTrigger.width/2;
			workoutTrigger.y = mat.y + mat.height/2 - workoutTrigger.height/2;
			// workoutTrigger.visible = true;
			// add(workoutTrigger);
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
			handleWorkout();


			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}



	private function handleWorkout():Void
	{
		if (SceneState.score.currentJostleStrength() > 10)
		{
			others.setAll("exercizing",false);
			canParticipate = false;
		}

		if (workoutComplete) return;


		if (workoutTimer.finished && bastard.hit.overlaps(workoutTrigger) && !workoutComplete)
		{
			workoutTimer.start(1,1,startWorkout);
		}
		else if (!bastard.hit.overlaps(workoutTrigger))
		{
			workoutTimer.stop();
			workoutTimer.finished = true;
		}

		if (workingout && (bastard.body.getLinearVelocity().x != 0 || bastard.body.getLinearVelocity().y != 0))
		{
			workoutTime++;
			if (workoutTime >= WORKOUT_UNIT_AMOUNT)
			{
				workoutTimer.stop();
				workoutTimer.finished = true;
				workoutComplete = true;
				showSuccessText(null);
			}
		}
	}


	private function startWorkout(t:FlxTimer):Void
	{
		workingout = true;
	}




	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (workoutComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("FIT AS A FIDDLE");
		}
		else if (workoutComplete)
		{
			statsRatingText.setText("C");
			statsRankText.setText("WORKOUT JERKOFF");
		}		
	}


	override private function addBonuses():Void
	{
		if (workoutComplete)
		{
			addToBonus("+ MR. MUSCLE");
		}
		if (workoutComplete && SceneState.score.people > 100)
		{
			addToBonus("+ KICKING SAND IN THEIR FACES");
		}
		if (!workoutComplete)
		{
			addToBonus("+ 98 POUND WEAKLING");
		}
		if (!workoutComplete && SceneState.score.people > 100)
		{
			addToBonus("+ SMALL BUT MEAN");
		}

		super.addBonuses();
	}
}






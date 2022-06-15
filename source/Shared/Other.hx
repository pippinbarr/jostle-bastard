package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxText;

import org.flixel.util.FlxPoint;
import org.flixel.util.FlxTimer;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2World;

import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;


class Other extends Person
{
	private var KNOCKED_DOWN_MINIMUM:Float = 2;
	private var KNOCKED_DOWN_RANGE:Float = 20;
	
	public static var otherColour:Int = GameAssets.OTHER;
	public static var recoloured:Bool = false;

	private var NORMAL_SPEED:Float = 1;
	private static var ANNOYED_SPEED:Float = 1.5;
	private static var ANGRY_SPEED:Float = 9;
	private var SCARED_SPEED:Float = 5;

	private static var WANDER_MIN_TIME:Float = 2;
	private static var WANDER_RANGE_TIME:Float = 4;

	public var mood:JostleEnums.Mood;
	public var mode:JostleEnums.Mode;
	public var seat:Seat;

	private var walkPath:Array<FlxPoint>;
	public var walkPathIndex:Int = -1;

	private var timer:FlxTimer;
	private var knockedDownTimer:FlxTimer;
	private var textTimer:FlxTimer;
	private var target:Person;
	private var walkDelayTimer:FlxTimer;
	private var wanderTimer:FlxTimer;
	private var wanderDirection:JostleEnums.Direction;


	public function new(X:Float,Y:Float,Sprite:String,thePath:Array<FlxPoint>,Target:Person,theMode:JostleEnums.Mode,theSeat:Seat = null,recolourNow:Bool = true)
	{
		super(X,Y,Sprite,0.5);
		loadGraphic(GameAssets.PERSON_FRAMES_PNG,true,false,56,80,true);

		replaceO = true;
		replaceH = true;

		kind = OTHER;
		mode = theMode;
		seat = theSeat;
		target = Target;

		walkPath = thePath;
		walkPathIndex = -1;

		timer = new FlxTimer();
		knockedDownTimer = new FlxTimer();
		knockedDownTimer.finished = true;
		textTimer = new FlxTimer();
		walkDelayTimer = new FlxTimer();

		wanderTimer = new FlxTimer();
		wanderTimer.finished = true;
		wanderDirection = NONE;

		mood = NORMAL;
		MOVEMENT_IMPULSE = NORMAL_SPEED;

		recolour();

		// if (recolourNow)
		// {			
		// 	recolour();
		// }
	}


	override public function destroy():Void
	{
		Other.recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		switch (mood)
		{
			case NORMAL:
			if (mode == PATH)
			followSetPath();
			else if (mode == WANDER)
			wander();
			else if (mode == DANCE)
			dance();
			else if (mode == STILL)
			idle();
			else if (mode == EXERCISE)
			{}

			case APOLOGETIC:
			idle();

			case STUNNED:
			idle();

			case ANNOYED:
			chase(target);

			case ANGRY:
			chase(target);

			case KNOCKED_DOWN:

			case SCARED:
			flee(target);
		}
	}


	private function apologize():Void
	{
	}


	private function follow():Void
	{
	}

	public function changeMode(theMode:JostleEnums.Mode):Void
	{
		mode = theMode;

		switch (mode)
		{
			case STILL,SEATED,EXERCISE:

			case WANDER:
			MOVEMENT_IMPULSE = NORMAL_SPEED/2;

			case DANCE:
			MOVEMENT_IMPULSE = NORMAL_SPEED * 2;

			case PATH:
			MOVEMENT_IMPULSE = NORMAL_SPEED/2;			
		}
	}


	public function changeMood(theMood:JostleEnums.Mood):Void
	{
		if (!knockedDownTimer.finished) return;

		timer.stop();

		mood = theMood;
		mode = WANDER;

		switch (mood)
		{
			case NORMAL:
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case STUNNED:
			MOVEMENT_IMPULSE = NORMAL_SPEED;
			timer.start(5 + Math.random() * 5,1,handleStunnedTimer);

			case APOLOGETIC:
			MOVEMENT_IMPULSE = NORMAL_SPEED;
			timer.start(2 + Math.random() * 2,1,handleApologeticTimer);

			case ANNOYED:
			SceneState.score.annoyed++;
			MOVEMENT_IMPULSE = ANNOYED_SPEED;
			timer.start(5 + Math.random() * 5,1,handleAnnoyedTimer);

			case ANGRY:
			SceneState.score.angered++;
			MOVEMENT_IMPULSE = ANGRY_SPEED;
			timer.start(5 + Math.random() * 20,1,handleAngryTimer);

			case KNOCKED_DOWN:
			SceneState.score.ko += 50;
			frame = 2;
			knockedDownTimer.start(KNOCKED_DOWN_MINIMUM + Math.random() * KNOCKED_DOWN_RANGE,1,handleKnockedDownTimer);

			case SCARED:
			SceneState.score.scared++;
			MOVEMENT_IMPULSE = ANGRY_SPEED;
		}
	}


	private function handleStunnedTimer(t:FlxTimer):Void
	{
		changeMood(NORMAL);
	}


	private function handleApologeticTimer(t:FlxTimer):Void
	{
		changeMood(NORMAL);
	}


	private function handleAnnoyedTimer(t:FlxTimer):Void
	{
		changeMood(NORMAL);
	}


	private function handleAngryTimer(t:FlxTimer):Void
	{
		changeMood(ANNOYED);
	}


	private function handleKnockedDownTimer(t:FlxTimer):Void
	{

		var random:Float = Math.random();

		if (random > 0.8)
		{
			changeMood(ANNOYED);
		}
		else if (random > 0.5)
		{
			changeMood(ANGRY);
		}
		else if (random > 0.3)
		{
			changeMood(STUNNED);
		}
		else
		{
			changeMood(SCARED);
		}

		frame = 0;
	}


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		var impulse:Float = Impulse.normalImpulses[0];

		handleImpact(impulse,OtherSprite);

		super.postSolve(OtherSprite,Impulse);

	}


	private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	{
		var impact:Int = Physics.getImpact(impulse);
		recordImpact(other,impact);
		reactToImpact(other,impact);
	}


	public function recordImpact(O:PhysicsSprite,I:Int):Void
	{
		switch(O.kind)
		{
			case BASTARD:
			SceneState.score.o_by_b+=I;
			
			case OTHER:
			if (O.lastHitByBastard)
			{
				SceneState.score.o_by_o+=I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.o_into_o+=I;
			}

			case CHILD:
			if (O.lastHitByBastard)
			{
				SceneState.score.o_by_k += I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.o_into_k += I;
			}

			case COP:
			if (O.lastHitByBastard)
			{
				SceneState.score.o_by_c += I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.o_into_c += I;
			}


			case FURNITURE:
			if (O.lastHitByBastard)
			{
				SceneState.score.o_by_f+=I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.o_into_f+=I;
			}

			case TRASH:
			if (O.lastHitByBastard)
			{
				SceneState.score.o_by_tr+=I;
			}

			case WALL:
			if (lastHitByBastard) SceneState.score.o_into_w+=I;

			case TREE:
			if (lastHitByBastard) SceneState.score.o_into_t+=I;
			
			case UNKNOWN:
		}
	}



	private function reactToImpact(O:PhysicsSprite,I:Int):Void
	{
		var random:Float = Math.random();

		if (O == lastHitBy) return;

		if (O.kind != BASTARD && !O.jostled) return;

		switch (I)
		{
			case Physics.HARD:

			if (random > 0.7)
			{
				changeMood(KNOCKED_DOWN);
			}
			else if (random > 0.3 && mood == ANNOYED)
			{
				changeMood(ANGRY);
			}
			else if (random > 0.5 && (mood == STUNNED || mood == APOLOGETIC))
			{
				changeMood(ANNOYED);
			}
			else if (random > 0.1 && mood == APOLOGETIC)
			{
				changeMood(STUNNED);
			}
			else if (random > 0.9 && mood != ANNOYED && mood != ANGRY)
			{
				changeMood(APOLOGETIC);
			}


			case Physics.MEDIUM:

			if (random > 0.95)
			{
				changeMood(KNOCKED_DOWN);
			}
			else if (random > 0.5 && mood == ANNOYED)
			{
				changeMood(ANGRY);
			}
			else if (random > 0.5 && mood == STUNNED)
			{
				changeMood(ANNOYED);
			}
			else if (random > 0.2 && mood == APOLOGETIC)
			{
				changeMood(STUNNED);
			}
			else if (random > 0.6 && mood == APOLOGETIC)
			{
				changeMood(ANNOYED);
			}
			else if (random > 0.7 && mood == NORMAL)
			{
				changeMood(APOLOGETIC);
			}


			case Physics.SOFT:

			if (random > 0.8 && mood == ANNOYED)
			{
				changeMood(ANGRY);
			}
			else if (random > 0.7 && mood == STUNNED)
			{
				changeMood(ANNOYED);
			}
			else if (random > 0.7 && mood == APOLOGETIC)
			{
				changeMood(STUNNED);
			}
			else if (random > 0.3 && mood == APOLOGETIC)
			{
				changeMood(ANNOYED);
			}
			else if (random > 0.5 && mood != ANNOYED && mood != ANGRY)
			{
				changeMood(APOLOGETIC);
			}

			case Physics.NONE:
		}
	}


	public function startFollowingSetPath():Void
	{
		walkPathIndex = 0;
		changeMode(PATH);
	}


	private function followSetPath():Bool
	{
		if (walkPath == null) 
		{
			return false;
		}


		if (mood != NORMAL && 
			mood != APOLOGETIC)
		{
			return false;
		}

		if (walkPathIndex != -1)
		{
			if (walkPath[walkPathIndex].x < 0 && walkPath[walkPathIndex].y < -0)
			{
				walkDelayTimer.start(Math.abs(walkPath[walkPathIndex].x),1,resumeWalkPath);
				return false;
			}

			if (walkPath[walkPathIndex].x != 0)
			{
				// trace("... seeking on X...");
				if (Physics.worldToScreen(body.getPosition().x) > walkPath[walkPathIndex].x + 5)
				{
					moveLeft();
				}
				else if (Physics.worldToScreen(body.getPosition().x) < walkPath[walkPathIndex].x - 5)
				{
					moveRight();
				}
				else
				{
					// trace("... found X...");
					idleX();
					walkPathIndex++;
				}	
			}
			else if (walkPath[walkPathIndex].y != 0)
			{
				// trace("... seeking on Y...");
				if (Physics.worldToScreen(body.getPosition().y) > walkPath[walkPathIndex].y + 5)
				{
					moveUp();
				}
				else if (Physics.worldToScreen(body.getPosition().y) < walkPath[walkPathIndex].y - 5)
				{
					moveDown();
				}
				else
				{
					// trace("... found Y...");
					idleY();
					walkPathIndex++;
				}	
			}
			else
			{
				// trace("... PATH COMPLETED.");
				// Completed the walkPath
				walkPathIndex = -1;
				changeMode(WANDER);
			}
		}

		return true;
	}


	private function resumeWalkPath(t:FlxTimer):Void
	{
		walkPathIndex++;
	}


	override public function moveLeft():Void
	{
		this.facing = FlxObject.LEFT;

		if (mood != ANGRY && leftBlocks > 0)
		{
			// trace("Can't go left. Blocks: " + leftBlocks);
			idle();
		}
		else
		{
			super.moveLeft();
		}
	}


	override function moveRight():Void
	{
		this.facing = FlxObject.RIGHT;

		if (mood != ANGRY && rightBlocks > 0)
		{
			// trace("Can't go right. Blocks: " + rightBlocks);
			idle();
		}
		else
		{
			super.moveRight();
		}
	}


	override public function moveUp():Void
	{		
		if (mood != ANGRY && upBlocks > 0)
		{
			// trace("Can't go up. Blocks: " + upBlocks);
			idle();
		}
		else
		{
			super.moveUp();
		}
	}


	override public function moveDown():Void
	{
		if (mood != ANGRY && downBlocks > 0)
		{
			// trace("Can't go down. Blocks: " + downBlocks);
			idle();
		}
		else
		{
			super.moveDown();
		}
	}


	private function wander():Void
	{
		if (!wanderTimer.finished)
		{
			if (wanderDirection == LEFT) moveLeft();
			else if (wanderDirection == RIGHT) moveRight();
			else if (wanderDirection == UP) moveUp();
			else if (wanderDirection == DOWN) moveDown();

			return;
		}

		var random:Float = Math.random();
		if (random < 0.2) wanderDirection = LEFT;
		else if (random < 0.4) wanderDirection = RIGHT;
		else if (random < 0.6) wanderDirection = UP;
		else if (random < 0.8) wanderDirection = DOWN;
		else wanderDirection = NONE;

		wanderTimer.start(WANDER_MIN_TIME + WANDER_RANGE_TIME * Math.random(),1);
	}


	private function dance():Void
	{
		var r:Float = Math.random();
		if (r < 0.2) moveLeft();
		else if (r < 0.4) moveRight();
		else if (r < 0.6) moveUp();
		else if (r < 0.8) moveDown();
		else idle();
	}


	override public function beginContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor,OtherSensor,TheOther);

		if (Sensor == Physics.Y_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.y < this.y)
			{
				upBlocks++;
			}
			else if (TheOther.y > this.y)
			{
				downBlocks++;
			}
		}
		else if (Sensor == Physics.X_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.x < this.x)
			{
				leftBlocks++;
			}
			else if (TheOther.x > this.x)
			{
				rightBlocks++;
			}
		}
	}




	override public function endContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,TheOther);

		if (Sensor == Physics.Y_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.y < this.y)
			{
				upBlocks--;
			}
			else if (TheOther.y > this.y)
			{
				downBlocks--;
			}
		}
		else if (Sensor == Physics.X_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.x < this.x)
			{
				leftBlocks--;
			}
			else if (TheOther.x > this.x)
			{
				rightBlocks--;
			}
		}
	}


	// override public function recolour(Force:Bool = false):Void
	// {
	// 	if (!Other.recoloured || Force)
	// 	{
	// 		trace("Other.recolour()");
	// 		// currentO = otherColour;

	// 		super.recolour();
	// 		calcFrame();
	// 		Other.recoloured = true;

	// 		// otherColour = GameAssets.OTHER_REPLACEMENT;
	// 	}
	// }




}
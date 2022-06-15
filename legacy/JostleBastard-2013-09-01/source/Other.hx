package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxTimer;
import org.flixel.FlxText;

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
	private static var NORMAL:UInt = 0;
	private static var APOLOGETIC:UInt = 1;
	private static var STUNNED:UInt = 2;
	private static var ANNOYED:UInt = 3;
	private static var ANGRY:UInt = 4;
	private static var KNOCKED_DOWN:UInt = 5;

	public var mood:UInt = 0;

	public var pathIndex:Float = -1;

	private static var NORMAL_SPEED:Float = 1;
	private static var ANNOYED_SPEED:Float = 1.5;
	private static var ANGRY_SPEED:Float = 9;

	private var timer:FlxTimer;
	private var knockedDownTimer:FlxTimer;
	private var textTimer:FlxTimer;

	public function new(X:Float,Y:Float,Sprite:String)
	{
		super(X,Y,Sprite,0.5);

		loadGraphic(Assets.PERSON_FRAMES_PNG,true,false,56,80);

		timer = new FlxTimer();
		knockedDownTimer = new FlxTimer();
		textTimer = new FlxTimer();
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		speech.text = "" + mood;
		// changeMood(ANNOYED);

		moveToSetPoint();

		if (mood == NORMAL)
		{
			followSetPath();
		}
		else if (mood == APOLOGETIC)
		{
			idle();
		}
		else if (mood == STUNNED)
		{
			idle();
		}
		else if (mood == ANNOYED)
		{
			chase(SettingState.bastard);
		}
		else if (mood == ANGRY)
		{
			chase(SettingState.bastard);
		}
	}


	private function apologize():Void
	{
	}


	private function follow():Void
	{
	}


	private function chase(Target:Person):Void
	{
		if (Math.abs((x - Target.x)) > Math.abs((y - Target.y)))
		{
			chaseX(Target);
		}
		else
		{
			chaseY(Target);
		}
	}


	private function chaseY(Target:Person):Void
	{
		if (y < Target.y) moveDown();
		else if (y > Target.y) moveUp();
		else idleY();
	}


	private function chaseX(Target:Person):Void
	{
		if (x < Target.x) moveRight();
		else if (x > Target.x) moveLeft();
		else idleX();
	}


	public function changeMood(Mood:UInt):Void
	{
		mood = Mood;

		timer.stop();

		if (mood == NORMAL)
		{
			MOVEMENT_IMPULSE = NORMAL_SPEED;
		}
		if (mood == STUNNED)
		{
			MOVEMENT_IMPULSE = NORMAL_SPEED;
			timer.start(5 + Math.random() * 5,1,handleStunnedTimer);
		}
		else if (mood == APOLOGETIC)
		{
			MOVEMENT_IMPULSE = NORMAL_SPEED;
			timer.start(2 + Math.random() * 2,1,handleApologeticTimer);
		}
		else if (mood == ANNOYED)
		{
			MOVEMENT_IMPULSE = ANNOYED_SPEED;
			timer.start(5 + Math.random() * 5,1,handleAnnoyedTimer);
		}
		else if (mood == ANGRY)
		{
			MOVEMENT_IMPULSE = ANGRY_SPEED;
			timer.start(5 + Math.random() * 20,1,handleAngryTimer);
		}
		else if (mood == KNOCKED_DOWN)
		{
			frame = 2;
			knockedDownTimer.start(5 + Math.random() * 20,1,handleKnockedDownTimer);
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

		if (random > 0.7)
		{
			frame = 0;
			changeMood(ANNOYED);
		}
		else if (random > 0.4)
		{
			frame = 0;
			changeMood(ANGRY);
		}
		else if (random > 0.2)
		{
			frame = 0;
			changeMood(STUNNED);
		}
	}


	


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		var impulse:Float = Impulse.normalImpulses[0];

		handleImpactStrength(impulse,OtherSprite);

		super.postSolve(OtherSprite,Impulse);
	}


	private function handleImpactStrength(impulse:Float,other:PhysicsSprite):Void
	{
		handleHardImpact(other);

		return;

		if (impulse <= 10)		
		{
			return;
		}	
		else if (impulse > 30)
		{
			handleHardImpact(other);
		}
		else if (impulse > 20)
		{
			handleMediumImpact(other);
		}
		else
		{
			handleSoftImpact(other);
		}
	}



	private function handleHardImpact(OtherSprite:PhysicsSprite):Void
	{
		var random:Float = Math.random();

		if (OtherSprite == lastHitBy) 
		{
			return;
		}

		if (lastHitByBastard && lastHitBy.lastHitByBastard) trace("Both hit by bastard!");

		if (Type.getClass(OtherSprite) == Bastard)
		{
			trace("Hit hard by bastard.");
		}
		else if (lastHitByBastard)
		{
			if (Type.getClass(OtherSprite) == Chair)
			{
				trace("Hit hard into chair.");
			}
			else if (Type.getClass(OtherSprite) == Table)
			{
				trace("Hit hard into table.");
			}
			else if (Type.getClass(OtherSprite) == Wall)
			{
				trace("Hit hard into wall.");
			}
			else if (Type.getClass(OtherSprite) == Other)
			{
				trace("Hit hard into other.");
			}
		}
		else if (OtherSprite.lastHitByBastard)
		{
			if (Type.getClass(OtherSprite) == Chair)
			{
				trace("Hit hard by chair.");
			}
			else if (Type.getClass(OtherSprite) == Table)
			{
				trace("Hit hard by table.");
			}
			else if (Type.getClass(OtherSprite) == Wall)
			{
				trace("Hit hard by wall.");
			}
			else if (Type.getClass(OtherSprite) == Other)
			{
				trace("Hit hard by other.");
			}
		}

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
		else if (random > 0.9 && mood <= APOLOGETIC)
		{
			changeMood(APOLOGETIC);
		}
	}


	private function handleMediumImpact(Other:PhysicsSprite):Void
	{
		var random:Float = Math.random();

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
	}


	private function handleSoftImpact(Other:PhysicsSprite):Void
	{
		var random:Float = Math.random();


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
		else if (random > 0.5 && mood <= APOLOGETIC)
		{
			changeMood(APOLOGETIC);
		}
	}
	

	private function followSetPath():Bool
	{
		if (mood != NORMAL && mood != APOLOGETIC)
		{
			return false;
		}
		else
		{
			return true;
		}
	}



	override public function moveLeft():Void
	{
		this.facing = FlxObject.LEFT;

		if (mood < ANGRY && leftBlocks > 0)
		{
			trace("Can't go left. Blocks: " + leftBlocks);
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

		if (mood < ANGRY && rightBlocks > 0)
		{
			trace("Can't go right. Blocks: " + rightBlocks);
			idle();
		}
		else
		{
			super.moveRight();
		}
	}


	override public function moveUp():Void
	{		
		if (mood < ANGRY && upBlocks > 0)
		{
			trace("Can't go up. Blocks: " + upBlocks);
			idle();
		}
		else
		{
			super.moveUp();
		}
	}


	override public function moveDown():Void
	{
		if (mood < ANGRY && downBlocks > 0)
		{
			trace("Can't go down. Blocks: " + downBlocks);
			idle();
		}
		else
		{
			super.moveDown();
		}
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


}
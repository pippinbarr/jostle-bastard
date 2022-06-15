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


class MovieStar extends Other
{

	public function new(X:Float,Y:Float,Sprite:String,thePath:Array<FlxPoint>,Target:Person,theMode:JostleEnums.Mode,theSeat:Seat = null)
	{
		super(X,Y,Sprite,thePath,Target,theMode,theSeat);

		kind = UNKNOWN;

		KNOCKED_DOWN_RANGE = 1;
	}


	override public function destroy():Void
	{
		Other.recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		// changeMode(WANDER);
		// changeMood(NORMAL);
		// MOVEMENT_IMPULSE = Math.random() * 5 + 5;

		super.update();

	}


	override private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	{
		var impact:Int = Physics.getImpact(impulse);
		reactToImpact(other,impact);
	}


	override private function reactToImpact(O:PhysicsSprite,I:Int):Void
	{
		super.reactToImpact(O,I);
	}



	override public function changeMood(theMood:JostleEnums.Mood):Void
	{
		changeMode(WANDER);

		super.changeMood(theMood);

		if (mood == KNOCKED_DOWN) SceneState.score.ko -= 50;

		if (mood == APOLOGETIC || mood == STUNNED) super.changeMood(NORMAL);
	}


	public function changeTarget(NewTarget:Person):Void
	{
		target = NewTarget;
	}


	override private function wander():Void
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
		if (random < 0.25) wanderDirection = LEFT;
		else if (random < 0.5) wanderDirection = RIGHT;
		else if (random < 0.75) wanderDirection = UP;
		else wanderDirection = DOWN;

		wanderTimer.start(2 + 2 * Math.random(),1);
	}



}
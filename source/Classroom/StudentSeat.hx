package;

import org.flixel.FlxSprite;

import box2D.dynamics.B2ContactImpulse;
import box2D.common.math.B2Vec2;

class StudentSeat extends Seat
{	
	public function new(X:Float,Y:Float,Facing:UInt):Void
	{
		super(X,Y,GameAssets.STUDENT_CHAIR_PNG,GameAssets.STUDENT_CHAIR_PNG,Facing,40,56,2,0.5,0.1);
	}


	override private function handleImpactStrength(impulse:Float,other:PhysicsSprite):Void
	{
		if (impulse >= 15)
		{
			knockedOff();
			SceneState.score.ko += 200;
		}
		else if (impulse >= 5)
		{
			getUp();
		}
	}

	override private function knockedOff():Void
	{
		occupant.changeMood(KNOCKED_DOWN);
		removeOccupant();
	}


	override public function getUp():Void
	{
		occupant.changeMode(WANDER);
		occupant.changeMood(SCARED);
		removeOccupant();
	}
}
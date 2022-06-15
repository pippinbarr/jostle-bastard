package;

import org.flixel.FlxSprite;

import box2D.dynamics.B2ContactImpulse;
import box2D.common.math.B2Vec2;

class CinemaSeat extends Seat
{	
	public function new(X:Float,Y:Float,Facing:UInt):Void
	{
		super(X,Y,GameAssets.CINEMA_SEAT_PNG,GameAssets.CINEMA_SEAT_PNG,Facing,56,80,100000,0.5,0.1);
	}


	override private function knockedOff():Void
	{
		occupant.changeMood(ANGRY);
		removeOccupant();
	}
}
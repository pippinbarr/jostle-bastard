package;

import org.flixel.FlxSprite;

import box2D.dynamics.B2ContactImpulse;
import box2D.common.math.B2Vec2;

class ParkBench extends Seat
{	
	public function new(X:Float,Y:Float,Facing:UInt):Void
	{
		super(X,Y,GameAssets.BENCH_LEFT,GameAssets.BENCH_RIGHT,Facing);
	}
}
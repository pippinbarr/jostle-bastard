package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;

import box2D.dynamics.B2ContactImpulse;

import box2D.dynamics.B2Fixture;


class Chair extends Seat
{
	public function new(X:Float,Y:Float,F:UInt)
	{
		super(X,Y,GameAssets.CHAIR_LEFT_PNG,GameAssets.CHAIR_RIGHT_PNG,F);
	}
}

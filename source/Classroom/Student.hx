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


class Student extends Child
{
	public function new(X:Float,Y:Float,theTarget:Person,theMode:JostleEnums.Mode,theSeat:Seat = null)
	{
		super(X,Y,theTarget,theMode,theSeat);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}
}
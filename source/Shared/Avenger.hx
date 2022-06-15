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


class Avenger extends Other
{
	// public static var recoloured:Bool = false;

	public function new(X:Float,Y:Float,Target:Person)
	{
		super(X,Y,GameAssets.PERSON_STANDING_PNG,null,Target,WANDER,null);

		changeMood(ANGRY);
		SceneState.score.angered++;

		recolour();
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	override private function handleAngryTimer(t:FlxTimer):Void
	{

	}


	override private function handleKnockedDownTimer(t:FlxTimer):Void
	{
		changeMood(ANGRY);
		frame = 0;
	}


	// override public function recolour(Force:Bool = false):Void
	// {
	// 	if (!Avenger.recoloured || Force)
	// 	{
	// 		super.recolour();
	// 		calcFrame();
	// 		Tutor.recoloured = true;
	// 	}

	// 	currentO = GameAssets.OTHER_REPLACEMENT;
	// }

}
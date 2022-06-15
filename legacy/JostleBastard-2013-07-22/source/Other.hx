package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxTimer;

import box2D.dynamics.B2World;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2Body;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2FilterData;

class Other extends Person
{
	public function new(X:Float,Y:Float)
	{
		super(X,Y,Assets.PERSON_FRAMES);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	public function chase(Target:Person):Void
	{			
		if (Math.abs((x + width/2) - (Target.x + Target.width/2)) > Math.abs((y + height/2) - (Target.y + Target.height)))
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


	

}
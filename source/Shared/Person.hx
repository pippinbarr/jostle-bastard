package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

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


class Person extends PhysicsSprite
{
	private var MOVEMENT_IMPULSE:Float = 10.0;

	public var upBlocks:Int = 0;
	public var downBlocks:Int = 0;
	public var leftBlocks:Int = 0;
	public var rightBlocks:Int = 0;


	public function new(X:Float,Y:Float,Sprite:String,M:Float)
	{
		super(X,Y,Sprite,0.125,1,M,true,true);

		active = false;
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	public function moveToSetPoint(X:Float,Y:Float):Void
	{
		body.setPosition(new B2Vec2(X,Y));
		updatePosition();
	}


	public function moveLeft():Void
	{
		this.facing = FlxObject.LEFT;
		body.applyImpulse(new B2Vec2(-MOVEMENT_IMPULSE,0),body.getPosition());
	}



	public function moveRight():Void
	{
		this.facing = FlxObject.RIGHT;
		body.applyImpulse(new B2Vec2(MOVEMENT_IMPULSE,0),body.getPosition());
	}


	public function moveUp():Void
	{		
		body.applyImpulse(new B2Vec2(0,-MOVEMENT_IMPULSE),body.getPosition());
	}


	public function moveDown():Void
	{
		body.applyImpulse(new B2Vec2(0,MOVEMENT_IMPULSE),body.getPosition());
	}


	public function idleX():Void
	{
		body.setLinearVelocity(new B2Vec2(0,body.getLinearVelocity().y));
	}


	public function idleY():Void
	{
		body.setLinearVelocity(new B2Vec2(body.getLinearVelocity().x,0));
	}


	public function idle():Void
	{
		body.setLinearVelocity(new B2Vec2(0,0));
	}


	private function chase(Target:Person):Void
	{
		if (Target == null) return;

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
		if (y < Target.y) 
		{
			moveDown();
		}
		else if (y >= Target.y) 
		{
			moveUp();	
		}
	}


	private function chaseX(Target:Person):Void
	{
		if (x < Target.x) 
		{
			moveRight();
		}
		else if (x >= Target.x) 
		{
			moveLeft();
		}
	}	



	private function flee(Target:Person):Void
	{
		if (Target == null) return;

		if (Math.abs((x - Target.x)) >= Math.abs((y - Target.y)))
		{
			fleeX(Target);
		}
		else
		{
			fleeY(Target);
		}
	}


	private function fleeY(Target:Person):Void
	{
		if (y > Target.y)
		{
			if (downBlocks == 0) moveDown();
			else if (Math.random() > 0.5) moveRight();
			else moveLeft();
		}
		else if (y <= Target.y)
		{
			if (upBlocks == 0) moveUp();
			else if (Math.random() > 0.5) moveRight();
			else moveLeft();
		}
		else idle();
	}


	private function fleeX(Target:Person):Void
	{
		if (x > Target.x)
		{
			if (rightBlocks == 0) moveRight();
			else if (Math.random() > 0.5) moveUp();
			else moveDown();
		}
		else if (x <= Target.x)
		{
			if (leftBlocks == 0) moveLeft();
			else if (Math.random() > 0.5) moveUp();
			else moveDown();
		}
		else idle();
	}
}
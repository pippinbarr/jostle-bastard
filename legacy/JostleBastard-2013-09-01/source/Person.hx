package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

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

	public var moveTo:B2Vec2 = null;

	public var upBlocks:Int = 0;
	public var downBlocks:Int = 0;
	public var leftBlocks:Int = 0;
	public var rightBlocks:Int = 0;


	public function new(X:Float,Y:Float,Sprite:String,M:Float)
	{
		super(X,Y,Sprite,8,M,true,true);
	}


	override public function recolour():Void
	{
		replaceColor(Assets.PERSON_COLOUR,Assets.PERSON_COLOURS[SettingState.COLOUR_SET]);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	private function moveToSetPoint():Void
	{
		if (moveTo != null)
		{
			body.setPosition(moveTo);
			updatePosition();
			moveTo = null;
			visible = true;
			body.setActive(true);
		}
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








}
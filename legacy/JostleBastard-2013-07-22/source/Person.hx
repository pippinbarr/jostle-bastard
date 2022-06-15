package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


class Person extends FlxSprite
{
	private var MOVEMENT_IMPULSE:Float = 10.0;

	public var body:B2Body;
	public var fixture:B2FixtureDef;
	public var sprite:FlxSprite;


	public function new(X:Float,Y:Float,Sprite:String)
	{
		super(X,Y);

		sprite = new FlxSprite(X,Y);
		sprite.loadGraphic(Sprite,true,true,56,80);
		FlxG.state.add(sprite);
		sprite.frame = Assets.STANDING_FRAME;

		this.makeGraphic(Math.floor(sprite.width),Math.floor(sprite.height/8),0xFF00FF00);
		this.x = X + this.width/2;
		this.y = Y + this.height/2;

		sprite.x = this.x - this.width/2;
		sprite.y = this.y + this.height/2 - sprite.height/2;

		createPersonBodyFromSpriteBoundingBox(this);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function preUpdate():Void
	{
		super.preUpdate();
	}

	override public function update():Void
	{
		sprite.x = Physics.worldToScreen(body.getPosition().x) - width/2;
		sprite.y = Physics.worldToScreen(body.getPosition().y) + height/2 - sprite.height;
		
		sprite.facing = facing;

		this.x = sprite.x;
		this.y = sprite.y + sprite.height - this.height;

		super.update();
	}


	override public function postUpdate():Void
	{
		super.postUpdate();
	}


	public function wouldCollideWithPerson(P:Person):Bool
	{
		var vx:Float = Physics.worldToScreen(body.getLinearVelocity().x);
		var vy:Float = Physics.worldToScreen(body.getLinearVelocity().y);

		if (this.overlapsAt(x + vx*FlxG.elapsed,y + vy*FlxG.elapsed,P))
		{
			return true;
		}
		else
		{
			return false;
		}
	}


	public function moveLeft():Void
	{
		facing = FlxObject.LEFT;

		body.applyImpulse(new B2Vec2(-MOVEMENT_IMPULSE,0),body.getPosition());
	}


	public function moveRight():Void
	{
		facing = FlxObject.RIGHT;

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


	public function createPersonBodyFromSpriteBoundingBox(S:FlxSprite):Void
	{
		var bodyDefinition = new B2BodyDef();

		bodyDefinition.position.set(
			Physics.screenToWorld(S.x + S.width/2), 
			Physics.screenToWorld(S.y)
			);
		bodyDefinition.type = B2Body.b2_dynamicBody;

		var hitShape = new B2PolygonShape();
		hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/2));

		fixture = new B2FixtureDef();
		fixture.shape = hitShape;
		fixture.restitution = 1.1;

		body = Physics.WORLD.createBody(bodyDefinition);
		body.createFixture(fixture);

		var mass:B2MassData = new B2MassData();
		mass.mass = 1;
		body.setMassData(mass);
		body.setLinearDamping(10);
	}

}
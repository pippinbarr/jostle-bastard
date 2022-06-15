package;

import box2D.dynamics.B2World;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2Body;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;

import org.flixel.FlxSprite;
import flash.display.Sprite;

class Physics
{
	public static var X_SENSOR:Int = 0x0002;
	public static var Y_SENSOR:Int = 0x0004;

	public static var DRAW_DEBUG:Bool = false;
	
	public static var WORLD:B2World;
	public static var SCALE:Float = 1/30;

	public static var DEBUG:B2DebugDraw;
	public static var DEBUG_SPRITE:Sprite;

	public static var AVATAR:UInt = 1;
	public static var PERSON:UInt = 2;
	public static var CHAIR:UInt = 3;
	public static var TABLE:UInt = 4;
	public static var COUNTER:UInt = 5;
	public static var WALL:UInt = 6;


	public static function createDynamicBodyFromSpriteBoundingBox(S:FlxSprite,M:Float,IsDynamic:Bool = true,HasSensor:Bool = false):B2Body
	{

		var bodyDefinition = new B2BodyDef();

		bodyDefinition.position.set(
			Physics.screenToWorld(S.x + S.width/2), 
			Physics.screenToWorld(S.y)
			);
		bodyDefinition.type = B2Body.b2_dynamicBody;

		bodyDefinition.bullet = true;

		var hitShape = new B2PolygonShape();
		hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/2));

		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		fixtureDef.shape = hitShape;
		fixtureDef.restitution = 1.2;

		var body:B2Body = Physics.WORLD.createBody(bodyDefinition);

		var fixture:B2Fixture = body.createFixture(fixtureDef);


		if (HasSensor)
		{
			hitShape = new B2PolygonShape();
			// hitShape.setAsBox(Physics.screenToWorld(S.width/1.75), Physics.screenToWorld(S.height/1.75));
			hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/0.33));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = Y_SENSOR;

			fixture = body.createFixture(fixtureDef);


			hitShape = new B2PolygonShape();
			// hitShape.setAsBox(Physics.screenToWorld(S.width/1.75), Physics.screenToWorld(S.height/1.75));
			hitShape.setAsBox(Physics.screenToWorld(S.width/1), Physics.screenToWorld(S.height/2));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = X_SENSOR;

			fixture = body.createFixture(fixtureDef);
		}

		var mass:B2MassData = new B2MassData();
		mass.mass = M;
		body.setMassData(mass);
		body.setLinearDamping(10);

		return body;
	}


	public static function createStaticBodyFromSpriteBoundingBox(S:FlxSprite):B2Body
	{
		var bodyDefinition = new B2BodyDef();

		bodyDefinition.position.set(
			Physics.screenToWorld(S.x + S.width/2), 
			Physics.screenToWorld(S.y + S.height/2)
			);
		bodyDefinition.type = B2Body.b2_staticBody;

		var hitShape = new B2PolygonShape();
		hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/2));

		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		fixtureDef.shape = hitShape;
		fixtureDef.restitution = 1.2;

		var body:B2Body = Physics.WORLD.createBody(bodyDefinition);
		body.createFixture(fixtureDef);

		var mass:B2MassData = new B2MassData();
		mass.mass = 1;
		body.setMassData(mass);
		body.setLinearDamping(10);

		return body;
	}


	public static function worldToScreen(N:Float):Float
	{
		return (N / SCALE);
	}


	public static function screenToWorld(N:Float):Float
	{
		return (N * SCALE);
	}
}
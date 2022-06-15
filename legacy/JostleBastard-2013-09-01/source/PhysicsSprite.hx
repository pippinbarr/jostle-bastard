package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxText;
import org.flixel.FlxTimer;
import org.flixel.FlxObject;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2World;

import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;


class PhysicsSprite extends FlxSprite
{
	private var isDynamic:Bool;

	public var hit:FlxSprite;

	public var body:B2Body;
	public var contacts:FlxGroup;
	public var depth:Float;
	public var lastHitByBastard:Bool = false;
	public var lastHitBy:PhysicsSprite = null;

	private var speech:FlxText;

	private var lastHitTimer:FlxTimer;


	public function new(X:Float,Y:Float,Sprite:String,HitFactor:Float,M:Float,IsDynamic:Bool = false,HasSensor:Bool = false)
	{

		super(X,Y);

		contacts = new FlxGroup();

		isDynamic = IsDynamic;

		this.loadGraphic(Sprite,false,true,0,0,false);

		hit = new FlxSprite(X,Y);
		hit.makeGraphic(Math.floor(this.width),Math.floor(this.height/HitFactor),0xFF000000);
		hit.x = this.x;
		hit.y = this.y + this.height - hit.height;

		if (isDynamic)
		{
			body = Physics.createDynamicBodyFromSpriteBoundingBox(hit,M,IsDynamic,HasSensor);
		}
		else
		{
			body = Physics.createStaticBodyFromSpriteBoundingBox(hit);	
		}

		body.setUserData(this);

		depth = Physics.worldToScreen(body.getPosition().y);

		speech = new FlxText(this.x - this.width/2, this.y, Std.int(this.width) * 2, "NORMAL");
		speech.setFormat("Commodore",12,"center");
		FlxG.state.add(speech);
		// speech.visible = false;

		lastHitTimer = new FlxTimer();


	}


	public function recolour():Void
	{
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		speech.text = "" + lastHitByBastard;
		speech.x = this.x - this.width/2;
		speech.y = this.y - 20;

		if (isDynamic)
		{
			updatePosition();
		}

		depth = Physics.worldToScreen(body.getPosition().y);

		super.update();

		if (Math.abs(this.body.getLinearVelocity().x) < 0.5 && Math.abs(this.body.getLinearVelocity().y) < 0.5)
		{
			lastHitByBastard = false;
			lastHitBy = null;
		}
	}


	public function updatePosition():Void
	{
		this.x = Physics.worldToScreen(body.getPosition().x) - hit.width/2;
		this.y = Physics.worldToScreen(body.getPosition().y) + hit.height/2 - this.height;
	}


	public function beginContact(Sensor:Int,OtherSensor:Int,Other:PhysicsSprite):Void
	{
	}

	public function endContact(Sensor:Int,OtherSensor:Int,Other:PhysicsSprite):Void
	{
	}

	private function hitByBastard():Void
	{

	}


	public function postSolve(OtherSprite:PhysicsSprite, impulse:B2ContactImpulse):Void
	{
		lastHitBy = OtherSprite;

		if (this == SettingState.bastard) return;

		if (isDynamic)
		{
			if (OtherSprite == SettingState.bastard)
			{
				lastHitByBastard = true;
			}
			else if (OtherSprite.lastHitByBastard) 
			{
				lastHitByBastard = true;
			}
		}
	}


	private function stopTimer(t:FlxTimer):Void
	{
		lastHitTimer.stop();
		lastHitByBastard = false;
		lastHitBy = null;
	}
}
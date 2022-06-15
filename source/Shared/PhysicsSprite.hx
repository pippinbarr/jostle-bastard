package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxText;
import org.flixel.FlxObject;

import org.flixel.util.FlxTimer;


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
	private var currentB:Int = -1000;
	private var currentO:Int = -1000;
	private var currentF:Int = -1000;
	private var currentW:Int = -1000;
	private var currentH:Int = -1000;

	private var replaceB:Bool = false;
	private var replaceO:Bool = false;
	private var replaceF:Bool = false;
	private var replaceW:Bool = false;
	private var replaceH:Bool = false;


	public var kind:JostleEnums.Kind;

	private var isDynamic:Bool;

	public var hit:FlxSprite;
	public var body:B2Body;
	public var contacts:FlxGroup;

	public var depth:Float;

	public var lastHitByBastard:Bool = false;
	public var lastHitBy:PhysicsSprite = null;
	public var jostled:Bool = false;

	private var lastHitTimer:FlxTimer;

	private var speech:FlxText;


	public function new(
		X:Float,
		Y:Float,
		Sprite:String,
		HitYRatio:Float,
		HitXRatio:Float = 1,
		Mass:Float,
		IsDynamic:Bool = false,
		HasSensor:Bool = false,
		W:Int = 0,
		H:Int = 0,
		Color:UInt = 0xFF000000)
	{

		super(X,Y);

		kind = UNKNOWN;

		isDynamic = IsDynamic;

		if (Sprite != "")
		{
			this.loadGraphic(Sprite,false,true,0,0,false);
		}
		else 
		{
			this.makeGraphic(W,H,Color);
		}

		if (HitXRatio == 0 && HitYRatio == 0) return;

		contacts = new FlxGroup();

		hit = new FlxSprite(X,Y);
		hit.makeGraphic(Math.floor(this.width * HitXRatio),Math.floor(this.height * HitYRatio),0xFF000000);
		hit.x = this.x;
		hit.y = this.y + this.height - hit.height;

		if (isDynamic)
		{
			body = Physics.createDynamicBodyFromSpriteBoundingBox(hit,Mass,IsDynamic,HasSensor);
		}
		else
		{
			body = Physics.createStaticBodyFromSpriteBoundingBox(hit);	
		}

		body.setUserData(this);

		depth = Physics.worldToScreen(body.getPosition().y);

		lastHitTimer = new FlxTimer();

		updatePosition();
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		if (isDynamic)
		{
			updatePosition();
		}

		if (hit == null) return;

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
		if (hit == null || body == null) return;

		this.x = Physics.worldToScreen(body.getPosition().x) - hit.width/2;
		this.y = Physics.worldToScreen(body.getPosition().y) + hit.height/2 - this.height;

		hit.x = this.x;
		hit.y = this.y + this.height - hit.height;
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

		if (kind == BASTARD && impulse.normalImpulses[0] >= 3)
		{
			SceneState.score.justJostled = true;			
		}
		else if ((kind == OTHER || kind == COP) &&
			(OtherSprite.kind == OTHER || OtherSprite.kind == BASTARD || OtherSprite.kind == COP) &&
			impulse.normalImpulses[0] >= 2)
		{
			SceneState.score.justJostled = true;			
		}


		if (kind == BASTARD) return;

		var impact:Int = Physics.getImpact(impulse.normalImpulses[0]);
		
		lastHitBy = OtherSprite;

		if (isDynamic)
		{
			if (OtherSprite.kind == BASTARD)
			{
				lastHitByBastard = true;
				jostled = true;
			}
			else if (OtherSprite.lastHitByBastard) 
			{
				lastHitByBastard = true;
				jostled = true;
			}
		}
	}


	private function stopTimer(t:FlxTimer):Void
	{
		lastHitTimer.stop();
		lastHitByBastard = false;
		lastHitBy = null;
	}


	// public function recolour(Force:Bool = false):Void
	// {
	// 	if (replaceB || Force) replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
	// 	if (replaceO || Force) replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
	// 	if (replaceF || Force) replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
	// 	if (replaceW || Force) replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
	// 	if (replaceH || Force) replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);
	// }

	// public function recolour(Force:Bool = false):Void
	// {
	// 	if (Force)
	// 	{
	// 		replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
	// 		replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
	// 		replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
	// 		replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
	// 		replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);
	// 	}
	// 	else
	// 	{
	// 		if (currentB != -1000) replaceColor(currentB,GameAssets.BASTARD_REPLACEMENT);
	// 		if (currentO != -1000) replaceColor(currentO,GameAssets.OTHER_REPLACEMENT);
	// 		if (currentF != -1000) replaceColor(currentF,GameAssets.FURNITURE_REPLACEMENT);
	// 		if (currentW != -1000) replaceColor(currentW,GameAssets.WALL_REPLACEMENT);
	// 		if (currentH != -1000) replaceColor(currentH,GameAssets.HIGHLIGHT_REPLACEMENT);
	// 	}
	// }




	public function recolour(Force:Bool = false):Void
	{
		replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
		replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
		replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
		replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
		replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);
		
		calcFrame();
	}

}
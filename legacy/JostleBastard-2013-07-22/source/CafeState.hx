
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxCollision;

import nme.display.Sprite;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;



class CafeState extends FlxState
{				
	private var NUM_OTHERS:UInt = 0;

	private var bastard:Bastard;
	private var others:FlxGroup;
	private var other:Other;
	private var room:CafeRoom;

	override public function create():Void
	{
		super.create();

		//FlxG.bgColor = 0xFFFFFFFF;
		FlxG.bgColor = 0xFFBBCCEE;

		Physics.DEBUG_SPRITE = new Sprite();
		FlxG.stage.addChild(Physics.DEBUG_SPRITE);

		Physics.WORLD = new B2World (new B2Vec2 (0,0), true);
		Physics.DEBUG = new B2DebugDraw ();

		Physics.DEBUG.setSprite(Physics.DEBUG_SPRITE);
		Physics.DEBUG.setDrawScale(1/Physics.SCALE);
		Physics.DEBUG.setFlags(B2DebugDraw.e_shapeBit);
		Physics.DEBUG_SPRITE.visible = true;

		Physics.WORLD.setDebugDraw(Physics.DEBUG);

		bastard = new Bastard(100,100);

		others = new FlxGroup();
		for (i in 0...NUM_OTHERS)
		{
			var otherOne:Other = new Other(Math.random() * FlxG.width,Math.random() * FlxG.height);
			// var otherOne:Other = new Other(400,100);
			others.add(otherOne);
		}

		room = new CafeRoom();
		add(room);

		add(bastard);
		add(others);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		// other.chase(bastard);
		for (i in 0...others.members.length)
		{
			if (others.members[i] != null)
			{
				var o:Other = cast(others.members[i],Other);
				o.chase(bastard);
				// o.moveLeft();
				// if (o.wouldCollideWithPerson(bastard))
				// {
				// 	o.idleX();
				// 	o.idleY();
				// }
			}
		}

		Physics.WORLD.step(1 / 30, 10, 10);
		Physics.WORLD.clearForces();
		Physics.WORLD.drawDebugData();
	}
}
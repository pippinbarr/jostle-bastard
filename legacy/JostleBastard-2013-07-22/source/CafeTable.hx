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


class CafeTable extends FlxSprite
{
	public var leftBody:B2Body;
	public var rightBody:B2Body;

	public var sprite:FlxSprite;

	private var leftOther:Other;
	private var rightOther:Other;

	private var leftSeated:Bool;
	private var rightSeated:Bool;


	public function new(X:Float,Y:Float)
	{

		super(X,Y);

		sprite = new FlxSprite();
		sprite.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_PNG);
		sprite.x = X - sprite.width/2;
		sprite.y = Y - sprite.height/2;
		FlxG.state.add(sprite);

		this.makeGraphic(Math.floor(sprite.width/2),Math.floor(sprite.height/4),0xFFFF0000);
		x = sprite.x;
		y = sprite.y + sprite.height - sprite.height/4;
		// leftBody = Physics.createBodyFromSpriteBoundingBox(this,false);

		x = sprite.x + sprite.width/2;
		y = sprite.y + sprite.height - sprite.height/4;
		// rightBody = Physics.createBodyFromSpriteBoundingBox(this,false);

		// CREATE PATRONS

		if (Math.random() > 0.0)
		{
			leftOther = new Other(sprite.x,sprite.y);
			leftOther.sprite.frame = Assets.SITTING_FRAME;
			leftOther.sprite.facing = FlxObject.RIGHT;
			FlxG.state.add(leftOther);

			sitLeft();

		}
		if (Math.random() > 1.0)
		{
			sitRight();
			rightOther = new Other(sprite.x + sprite.width/4,sprite.y);
			rightOther.sprite.frame = Assets.SITTING_FRAME;
			rightOther.sprite.facing = FlxObject.LEFT;
			FlxG.state.add(rightOther);
		}


		leftSeated = false;
		rightSeated = false;
	}


	override public function destroy():Void
	{
		sprite.destroy();

		// Physics.WORLD.destroyBody(leftBody);
		// Physics.WORLD.destroyBody(rightBody);

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	public function sitLeft():Bool
	{
		if (leftSeated) 
		{
			return false;
		}
		
		// leftBody.setPosition(new B2Vec2(-1000,0));

		leftSeated = true;

		return true;
	}


	public function sitRight():Bool
	{
		if (rightSeated) 
		{
			return false;
		}
		
		rightBody.setPosition(new B2Vec2(-1000,0));

		rightSeated = true;

		return true;
	}

}
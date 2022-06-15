package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


class Bastard extends Person
{
	private var NORMAL_SPEED:Float = 5;
	private var SPRINT_SPEED:Float = 12;

	public function new(X:Float,Y:Float)
	{
		super(X,Y,Assets.BASTARD_STANDING_PNG,1);

		MOVEMENT_IMPULSE = NORMAL_SPEED;
	}


	override public function recolour():Void
	{
		replaceColor(Assets.BASTARD_COLOUR,Assets.BASTARD_COLOURS[SettingState.COLOUR_SET]);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		handleInput();

	}


	public function handleInput():Void
	{			
		if (FlxG.keys.SPACE)
		{
			MOVEMENT_IMPULSE = SPRINT_SPEED;
		}
		else
		{
			MOVEMENT_IMPULSE = NORMAL_SPEED;
		}

		if (FlxG.keys.pressed("LEFT"))
		{
			moveLeft();
		}
		else if (FlxG.keys.pressed("RIGHT"))
		{
			moveRight();
		}
		else
		{
			idleX();
		}

		if (FlxG.keys.pressed("UP"))
		{
			moveUp();
		}
		else if (FlxG.keys.pressed("DOWN"))
		{
			moveDown();
		}
		else
		{
			idleY();
		}
	}
}
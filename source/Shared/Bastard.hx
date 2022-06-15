package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import org.flixel.util.FlxPoint;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2ContactImpulse;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


class Bastard extends Person
{
	public static var bColour:Int = GameAssets.BASTARD;
	public static var recoloured:Bool = false;

	private var NORMAL_SPEED:Float = 5;
	private var SPRINT_SPEED:Float = 12;

	public var inputEnabled:Bool = false;


	public function new(X:Float,Y:Float)
	{
		super(X,Y,GameAssets.BASTARD_STANDING_PNG,1);

		replaceB = true;

		kind = BASTARD;
		inputEnabled = false;

		MOVEMENT_IMPULSE = NORMAL_SPEED;

		recolour();
	}


	override public function destroy():Void
	{
		recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (inputEnabled) handleInput();

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

		if (FlxG.keys.LEFT)
		{
			moveLeft();
		}
		else if (FlxG.keys.RIGHT)
		{
			moveRight();
		}
		else
		{
			idleX();
		}

		if (FlxG.keys.UP)
		{
			moveUp();
		}
		else if (FlxG.keys.DOWN)
		{
			moveDown();
		}
		else
		{
			idleY();
		}
	}


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		super.postSolve(OtherSprite,Impulse);

		var impulse:Float = Impulse.normalImpulses[0];
		var impact:Int = Physics.getImpact(impulse);

		if (lastHitBy != null && lastHitBy.kind == COP)
		{
			SceneState.score.b_by_c += impact;
			return;
		}


		switch (OtherSprite.kind)
		{
			case FURNITURE:
			if (OtherSprite.lastHitBy != null && OtherSprite.lastHitBy.kind == COP)
			{
				SceneState.score.b_by_c += impact;
			}
			else
			{
				SceneState.score.b_into_f += impact;
			}

			case WALL:
			SceneState.score.b_into_w += impact;
			
			case TREE:
			SceneState.score.b_into_t += impact;

			case COP:
			SceneState.score.b_by_c += impact;

			case TRASH:
			SceneState.score.trash++;

			case UNKNOWN, OTHER, CHILD, BASTARD:

		}
	}


	// override public function recolour(Force:Bool = false):Void
	// {
	// 	if (!Bastard.recoloured || Force)
	// 	{
	// 		trace("Bastard.recolour()");
	// 		trace("bColour = " + bColour);
	// 		trace("replacement = " + GameAssets.BASTARD_REPLACEMENT);
	// 		currentB = bColour;

	// 		super.recolour();
	// 		calcFrame();
	// 		recoloured = true;

	// 		bColour = GameAssets.BASTARD_REPLACEMENT;
	// 	}
	// }

}
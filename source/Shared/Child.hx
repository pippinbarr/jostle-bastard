package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxText;

import org.flixel.util.FlxPoint;
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

import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;


class Child extends Other
{
	

	public static var recoloured:Bool = false;
	// public static var otherColour:Bool = GameAssets.OTHER;


	public function new(X:Float,Y:Float,theTarget:Person,theMode:JostleEnums.Mode,theSeat:Seat = null)
	{
		super(X,Y,GameAssets.CHILD_FRAMES_PNG,null,theTarget,theMode,theSeat,false);
		loadGraphic(GameAssets.CHILD_FRAMES_PNG,true,false,56,56,true);
		recolour();

		KNOCKED_DOWN_MINIMUM = 2;
		KNOCKED_DOWN_RANGE = 20;
		SCARED_SPEED = 5;

		kind = CHILD;

		mood = NORMAL;
		MOVEMENT_IMPULSE = NORMAL_SPEED;
	}


	override public function destroy():Void
	{
		Child.recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		switch (mood)
		{
			case NORMAL:

			case SCARED:
			flee(target);

			case ANGRY,ANGRY,STUNNED,ANNOYED,APOLOGETIC:
			idle();

			case KNOCKED_DOWN:
		}
	}


	override public function changeMood(theMood:JostleEnums.Mood):Void
	{
		if (!knockedDownTimer.finished) return;

		timer.stop();

		mood = theMood;
		mode = WANDER;

		switch (mood)
		{
			case NORMAL:
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case ANNOYED:
			SceneState.score.annoyed++;
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case ANGRY:
			SceneState.score.angered++;
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case STUNNED,APOLOGETIC:
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case SCARED:
			SceneState.score.scared++;
			MOVEMENT_IMPULSE = SCARED_SPEED;

			case KNOCKED_DOWN:
			SceneState.score.ko += 100;
			frame = 1;
			knockedDownTimer.start(KNOCKED_DOWN_MINIMUM + Math.random() * KNOCKED_DOWN_RANGE,1,handleKnockedDownTimer);
		}
	}


	override private function handleKnockedDownTimer(t:FlxTimer):Void
	{
		changeMood(SCARED);

		frame = 0;
	}


	override public function recordImpact(O:PhysicsSprite,I:Int):Void
	{
		switch(O.kind)
		{
			case BASTARD:
			SceneState.score.k_by_b+=I;
			
			case OTHER:
			if (O.lastHitByBastard)
			{
				SceneState.score.k_by_o+=I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.k_into_o+=I;
			}

			case CHILD:
			if (O.lastHitByBastard)
			{
				SceneState.score.k_by_k += I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.k_into_k += I;
			}


			case COP:
			if (O.lastHitByBastard)
			{
				SceneState.score.k_by_c += I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.k_into_c += I;
			}


			case FURNITURE:
			if (O.lastHitByBastard)
			{
				SceneState.score.k_by_f+=I;
			}
			else
			{
				if (lastHitByBastard) SceneState.score.k_into_f+=I;
			}

			case WALL:
			if (lastHitByBastard) SceneState.score.k_into_w+=I;

			case TREE:
			if (lastHitByBastard) SceneState.score.k_into_t+=I;
			
			case UNKNOWN,TRASH:
		}
	}



	override private function reactToImpact(O:PhysicsSprite,I:Int):Void
	{
		var random:Float = Math.random();

		if (O == lastHitBy) return;

		switch (I)
		{
			case Physics.HARD:
			changeMood(SCARED);

			case Physics.MEDIUM:
			changeMood(SCARED);

			case Physics.SOFT:
			changeMood(SCARED);

			case Physics.NONE:
		}
	}


	// override public function recolour(Force:Bool = false):Void
	// {
	// 	if (!Child.recoloured || Force)
	// 	{
	// 		trace("Recolouring child.");
	// 		replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
	// 		replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
	// 		replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
	// 		replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
	// 		replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);

	// 		calcFrame();
	// 		Child.recoloured = true;
	// 	}
	// }




}
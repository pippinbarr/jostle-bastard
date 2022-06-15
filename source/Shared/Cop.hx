package;

import org.flixel.FlxG;

import org.flixel.util.FlxTimer;

import box2D.dynamics.B2ContactImpulse;


class Cop extends Person
{
	public static var otherColour:Int = GameAssets.OTHER;
	public static var highlightColour:Int = GameAssets.HIGHLIGHT;
	public static var recoloured:Bool = false;


	private static var COP_SPEED:Float = 10;


	private var bastard:Bastard;
	private var timer:FlxTimer;


	public function new(X:Float,Y:Float,theBastard:Bastard)
	{
		super(X,Y,GameAssets.COP_STANDING_PNG,0.5);

		kind = COP;

		bastard = theBastard;
		timer = new FlxTimer();

		MOVEMENT_IMPULSE = COP_SPEED;

		recolour();
	}


	override public function destroy():Void
	{
		Cop.recoloured = false;


		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (hit.y + hit.height > FlxG.height - 20)
		{
			moveUp();
		}
		else
		{
			chase(bastard);
		}
	}


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		var impulse:Float = Impulse.normalImpulses[0];

		handleImpact(impulse,OtherSprite);

		super.postSolve(OtherSprite,Impulse);
	}


	private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	{
		var impact:Int = Physics.getImpact(impulse);
		recordImpact(other,impact);
	}


	public function recordImpact(O:PhysicsSprite,I:Int):Void
	{
		// if (lastHitBy == O) return;

		switch(O.kind)
		{
			case BASTARD:
			SceneState.score.c_by_b += I;
			
			case OTHER,COP,CHILD,FURNITURE:
			if (O.lastHitByBastard)
			{
				SceneState.score.c_by_b += I;
			}

			case WALL,TREE:
			if (this.lastHitByBastard)
			{
				SceneState.score.c_by_b += I;
			}

			case UNKNOWN,TRASH:
		}
	}


	override public function beginContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor,OtherSensor,TheOther);

		if (Sensor == Physics.Y_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.y < this.y)
			{
				upBlocks++;
			}
			else if (TheOther.y > this.y)
			{
				downBlocks++;
			}
		}
		else if (Sensor == Physics.X_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.x < this.x)
			{
				leftBlocks++;
			}
			else if (TheOther.x > this.x)
			{
				rightBlocks++;
			}
		}
	}




	override public function endContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,TheOther);

		if (Sensor == Physics.Y_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.y < this.y)
			{
				upBlocks--;
			}
			else if (TheOther.y > this.y)
			{
				downBlocks--;
			}
		}
		else if (Sensor == Physics.X_SENSOR && OtherSensor != Physics.X_SENSOR && OtherSensor != Physics.Y_SENSOR)
		{
			if (TheOther.x < this.x)
			{
				leftBlocks--;
			}
			else if (TheOther.x > this.x)
			{
				rightBlocks--;
			}
		}
	}


	// override public function recolour(Force:Bool = false):Void
	// {
	// 	if (!Cop.recoloured || Force)
	// 	{
	// 		currentO = otherColour;
	// 		currentH = highlightColour;

	// 		super.recolour();
	// 		calcFrame();
	// 		Cop.recoloured = true;

	// 		otherColour = GameAssets.OTHER_REPLACEMENT;
	// 		highlightColour = GameAssets.HIGHLIGHT_REPLACEMENT;
	// 	}

	// 	currentO = GameAssets.OTHER_REPLACEMENT;
	// 	currentH = GameAssets.HIGHLIGHT_REPLACEMENT;
	// }
}



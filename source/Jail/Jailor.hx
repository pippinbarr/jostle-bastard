package;

import org.flixel.FlxG;

import box2D.dynamics.B2ContactImpulse;

class Jailor extends Person
{

	public static var recoloured:Bool = false;


	public function new(X:Int,Y:Int):Void
	{
		super(X,Y,GameAssets.COP_STANDING_PNG,0.5);

		MOVEMENT_IMPULSE = 1;
		kind = COP;

		recolour();
	}


	override public function destroy():Void
	{
		Jailor.recoloured = false;
	}


	override public function update():Void
	{
		super.update();

		if (body.getLinearVelocity().x < 0)
		{
			if (hit.x < 32) moveRight();
			else moveLeft();
		}
		else if (body.getLinearVelocity().x > 0)
		{
			if (hit.x > FlxG.width - 32 - hit.width) moveLeft();
			else moveRight();
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


	override public function recolour(Force:Bool = false):Void
	{
		if (!Jailor.recoloured || Force)
		{
			super.recolour();
			calcFrame();
			Jailor.recoloured = true;
		}
	}

}
package;

import box2D.dynamics.B2ContactImpulse;

class Tutor extends Other
{
	public static var recoloured:Bool = false;

	public function new(X:Int,Y:Int,theBastard:Bastard):Void
	{
		super(X,Y,GameAssets.PERSON_STANDING_PNG,null,theBastard,STILL,null);

		recolour();
	}
	

	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		var impulse:Float = Impulse.normalImpulses[0];

		handleImpact(impulse,OtherSprite);

		super.postSolve(OtherSprite,Impulse);
	}


	// override private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	// {
	// 	var impact:Int = Physics.getImpact(impulse);
	// 	recordImpact(other,impact);
	// }


	// public function recordImpact(O:PhysicsSprite,I:Int):Void
	// {
	// 	// if (lastHitBy == O) return;

	// 	switch(O.kind)
	// 	{
	// 		case BASTARD:
	// 		SceneState.score.o_by_b+=I;

	// 		case OTHER:
	// 		if (O.lastHitByBastard)
	// 		{
	// 			SceneState.score.o_by_o+=I;
	// 		}
	// 		else
	// 		{
	// 			SceneState.score.o_into_o+=I;
	// 		}

	// 		case COP:
	// 		if (O.lastHitByBastard)
	// 		{
	// 			SceneState.score.o_by_c += I;
	// 		}
	// 		else
	// 		{
	// 			SceneState.score.o_into_c += I;
	// 		}


	// 		case FURNITURE:
	// 		if (O.lastHitByBastard)
	// 		{
	// 			SceneState.score.o_by_f+=I;
	// 		}
	// 		else
	// 		{
	// 			SceneState.score.o_into_f+=I;
	// 		}

	// 		case WALL:
	// 		SceneState.score.o_into_w+=I;

	// 		case TREE:
	// 		SceneState.score.o_into_t+=I;

	// 		case UNKNOWN:
	// 	}
	// }


	override public function recolour(Force:Bool = false):Void
	{
		if (!Tutor.recoloured || Force)
		{
			super.recolour(true);
			calcFrame();
			Tutor.recoloured = true;
		}

		currentO = GameAssets.OTHER_REPLACEMENT;
	}

}
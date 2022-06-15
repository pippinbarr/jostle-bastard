package;

import org.flixel.FlxSprite;
import org.flixel.FlxObject;

import box2D.dynamics.B2ContactImpulse;
import box2D.common.math.B2Vec2;

class Furniture extends PhysicsSprite
{
	private static var EMPTY_FRAME:Int = 0;
	private static var OCCUPIED_FRAME:Int = 1;

	public var occupant:Other;

	public function new(X:Float,Y:Float,LeftSprite:String,RightSprite:String,Facing:UInt,Width:Int = 40,Height:Int = 72,Mass = 0.5,XRatio:Float = 0.5,YRatio:Float = 0.25):Void
	{
		super(X,Y,RightSprite,YRatio,XRatio,Mass,true,false);
		this.loadGraphic(RightSprite,true,true,Width,Height,true);
		this.facing = Facing;

		frame = EMPTY_FRAME;
		kind = FURNITURE;

		recolour();
	}


	override public function destroy():Void
	{
		Seat.recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (occupant != null) 
		{
			occupant.moveToSetPoint(body.getPosition().x,body.getPosition().y - 1);
		}
	}

	public function addOccupant(O:Other):Void
	{
		occupant = O;
		occupant.moveToSetPoint(body.getPosition().x,body.getPosition().y - 1);
		occupant.active = false;
		occupant.visible = false;
		occupant.body.setActive(false);
		occupant.seat = this;
		occupant.changeMode(SEATED);

		this.frame = OCCUPIED_FRAME;
	}


	public function removeOccupant():Void
	{
		if (occupant == null) return;

		occupant.moveToSetPoint(body.getPosition().x,body.getPosition().y - 1);
		occupant.body.setActive(true);
		occupant.active = true;
		occupant.visible = true;
		occupant.seat = null;
		occupant = null;

		this.frame = EMPTY_FRAME;
	}


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		super.postSolve(OtherSprite,Impulse);

		if (frame == EMPTY_FRAME) return;

		var impulse:Float = Impulse.normalImpulses[0];

		occupant.jostled = true;
		occupant.recordImpact(OtherSprite,Physics.HARD);
		handleImpactStrength(impulse,OtherSprite);
	}


	private function handleImpactStrength(impulse:Float,other:PhysicsSprite):Void
	{
		if (impulse > 25)
		{
			knockedOff();
			SceneState.score.ko += 50;
		}
		else if (impulse > 15 && Math.random() > 0.5)
		{
			getUp();
		}
		else if (impulse > 2 && Math.random() > 0.9)		
		{
			getUp();
		}	
	}


	private function knockedOff():Void
	{
		occupant.changeMood(KNOCKED_DOWN);
		removeOccupant();
	}


	public function getUp():Void
	{
		var random:Float = Math.random();

		if (random > 0.8)
		{
			occupant.changeMood(ANGRY);
		}
		else if (random > 0.6)
		{
			occupant.changeMood(ANNOYED);
		}
		else
		{
			occupant.changeMood(NORMAL);
		}

		removeOccupant();
	}


	override public function recolour(Force:Bool = false):Void
	{
		if (!Seat.recoloured || Force)
		{
			super.recolour();
			calcFrame();
			Seat.recoloured = true;
		}

		currentF = GameAssets.FURNITURE_REPLACEMENT;
	}
}
package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;

import box2D.dynamics.B2ContactImpulse;

import box2D.dynamics.B2Fixture;


class Chair extends PhysicsSprite
{
	public var occupier:CafeCustomer;
	public var occupied:Bool;
	public var faces:UInt;

	public function new(X:Float,Y:Float,Display:FlxGroup,F:UInt = FlxObject.RIGHT)
	{
		faces = F;

		if (Math.random() > 0.5)
		{
			if (faces == FlxObject.RIGHT)
			{
				super(X,Y,Assets.CHAIR_PNG,4,1,true);
			}
			else
			{
				super(X,Y,Assets.CHAIR_LEFT_PNG,4,1,true);				
			}

			occupied = false;
		}
		else
		{
			if (faces == FlxObject.RIGHT)
			{
				super(X,Y,Assets.CHAIR_WITH_PERSON_PNG,4,1,true);
			}
			else
			{
				super(X,Y,Assets.CHAIR_WITH_PERSON_LEFT_PNG,4,1,true);				
			}

			occupier = new CafeCustomer(x,y - 40,Assets.PERSON_STANDING_PNG,this);
			occupier.body.setActive(false);
			occupier.facing = F;
			occupier.visible = false;
			occupier.active = false;

			CafeState.customers.add(occupier);
			Display.add(occupier);

			occupied = true;
		}
	}


	override public function recolour():Void
	{
		replaceColor(Assets.FURNITURE_COLOUR,Assets.FURNITURE_COLOURS[SettingState.COLOUR_SET]);
		replaceColor(Assets.PERSON_COLOUR,Assets.PERSON_COLOURS[SettingState.COLOUR_SET]);
	}


	public function sit():Void
	{
		if (faces == FlxObject.RIGHT)
		{
			this.loadGraphic(Assets.CHAIR_WITH_PERSON_PNG,false,true);		
		}
		else
		{
			this.loadGraphic(Assets.CHAIR_WITH_PERSON_LEFT_PNG,false,true);		
		}

		occupied = true;
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	override public function endContact(Sensor:Int,OtherSensor:Int,Other:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,Other);
	}


	public function goToCounter():Void
	{
		if (occupier == null || occupied == false) return;

		if (faces == FlxObject.RIGHT)
		{
			this.loadGraphic(Assets.CHAIR_PNG,false,true);		
		}
		else
		{
			this.loadGraphic(Assets.CHAIR_LEFT_PNG,false,true);		
		}			
		occupier.body.setPosition(new B2Vec2(body.getPosition().x,body.getPosition().y - 1));
		occupier.moveTo = occupier.body.getPosition();
		occupied = false;
		occupier.visible = true;
		occupier.active = true;

		occupier.pathIndex = 0;
	}


	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		super.postSolve(OtherSprite,Impulse);


		if (occupier == null) return;

		var impulse:Float = Impulse.normalImpulses[0];

		if (occupied)
		{
			handleImpactStrength(impulse,OtherSprite);
		}
		else
		{
			if (occupier.mood != 5)
			occupier.changeMood(3);
		}

	}


	private function handleImpactStrength(impulse:Float,other:PhysicsSprite):Void
	{
		if (impulse > 30)
		{
			knockedOff();
		}
		else if (impulse > 20 && Math.random() > 0.5)
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
		if (occupier == null || occupied == false) return;

		if (faces == FlxObject.RIGHT)
		{
			this.loadGraphic(Assets.CHAIR_PNG,false,true);		
		}
		else
		{
			this.loadGraphic(Assets.CHAIR_LEFT_PNG,false,true);		
		}			

		occupier.body.setPosition(this.body.getPosition());
		occupier.updatePosition();
		occupier.body.setActive(true);		
		occupied = false;
		occupier.visible = true;
		occupier.active = true;

		occupier.changeMood(5);
	}


	private function getUp():Void
	{
		if (occupier == null || occupied == false) return;

		if (faces == FlxObject.RIGHT)
		{
			this.loadGraphic(Assets.CHAIR_PNG,false,true);		
		}
		else
		{
			this.loadGraphic(Assets.CHAIR_LEFT_PNG,false,true);		
		}			
		occupier.body.setPosition(this.body.getPosition());
		occupier.updatePosition();
		occupier.body.setActive(true);		
		occupied = false;
		occupier.visible = true;
		occupier.active = true;

		if (Math.random() > 0.8)
		{
			occupier.changeMood(4);
		}
		else if (Math.random() > 0.8)
		{
			occupier.changeMood(3);
		}
		else
		{
			occupier.changeMood(0);
		}
	}
}

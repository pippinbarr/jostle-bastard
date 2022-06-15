package;

import org.flixel.FlxSprite;

import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.B2Fixture;


class JostleContactListener extends B2ContactListener
{
	public function new() 
	{
		super();
	}


	override public function beginContact(contact:B2Contact):Void 
	{		
		super.beginContact(contact);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		var sensorA:Int = fixtureA.getFilterData().categoryBits;
		var sensorB:Int = fixtureB.getFilterData().categoryBits;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		spriteA.beginContact(sensorA,sensorB,spriteB);
		spriteB.beginContact(sensorB,sensorA,spriteA);
	}


	override public function endContact(contact:B2Contact):Void 
	{		
		super.endContact(contact);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		var sensorA:Int = fixtureA.getFilterData().categoryBits;
		var sensorB:Int = fixtureB.getFilterData().categoryBits;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		spriteA.endContact(sensorA,sensorB,spriteB);
		spriteB.endContact(sensorB,sensorA,spriteA);
	}

	override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void
	{
		super.postSolve(contact,impulse);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		if (fixtureA.isSensor() || fixtureB.isSensor()) return;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		spriteA.postSolve(spriteB,impulse);		
		spriteB.postSolve(spriteA,impulse);		
	}



}
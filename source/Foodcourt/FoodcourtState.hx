
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;
import org.flixel.util.FlxPoint;

import org.flixel.plugin.photonstorm.FlxCollision;

import flash.display.Sprite;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


class FoodcourtState extends SceneState
{				
	private static var VENDING_UNIT_AMOUNT:Int = 30 * 10;

	private var vendingTrigger:FlxSprite;
	private var vendingTimer:FlxTimer;
	private var vending:Bool = false;
	private var vendingComplete:Bool = false;
	private var vendingTime:Int = 0;

	private var centerCart:PhysicsSprite;

	private var standTimer:FlxTimer;


	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		createWalls();
		createCarts();
		createSeating();
		createWanderers();

		vendingTimer = new FlxTimer();
		vendingTimer.finished = true;

		successText.setText("VENDING UNIT COMPLETED");

		standTimer = new FlxTimer();

		standTimer.start(7,1,handleStanding);
	}


	private function createSeating():Void
	{
		createBench(6*8,33*8,FlxObject.RIGHT);
		createBench(6*8,45*8,FlxObject.RIGHT);

		createBench(21*8,33*8,FlxObject.LEFT);
		createBench(21*8,45*8,FlxObject.LEFT);

		createBench(29*8,33*8,FlxObject.RIGHT);
		createBench(29*8,45*8,FlxObject.RIGHT);

		createBench(46*8,33*8,FlxObject.LEFT);
		createBench(46*8,45*8,FlxObject.LEFT);

		createBench(54*8,33*8,FlxObject.RIGHT);
		createBench(54*8,45*8,FlxObject.RIGHT);

		createBench(68*8,33*8,FlxObject.LEFT);
		createBench(68*8,45*8,FlxObject.LEFT);
	}


	private function createBench(X:Int,Y:Int,F:Int):Void
	{
		var b:ParkBench = new ParkBench(X,Y,F);
		display.add(b);
		seats.add(b);
		furniture.add(b);

		if (Math.random() > 0.4)
		{
			var o:Other = new Other(b.x,b.y + 10,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER,b);
			b.addOccupant(o);
			display.add(o);
			others.add(o);
		}
	}


	private function createCarts():Void
	{
		var leftCart:PhysicsSprite = new PhysicsSprite(5*8,7*8,GameAssets.CART_1_PNG,0.1,1,50,true,false);
		leftCart.kind = FURNITURE;
		leftCart.recolour();

		var leftVendor:Other = new Other(leftCart.x + 4*8,leftCart.y + 4*8,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL,null);

		centerCart = new PhysicsSprite(32*8,8*8,GameAssets.CART_2_PNG,0.1,1,50,true,false);
		centerCart.kind = FURNITURE;
		centerCart.recolour();

		vendingTrigger = new FlxSprite(centerCart.x + centerCart.width/2,centerCart.hit.y - 20);
		vendingTrigger.makeGraphic(Std.int(centerCart.width/2),20,0xFFFF0000);
		vendingTrigger.x = centerCart.x + centerCart.width/2 - vendingTrigger.width/2;
		vendingTrigger.y = centerCart.hit.y - 20;

		// add(vendingTrigger);

		var rightCart:PhysicsSprite = new PhysicsSprite(59*8,6*8,GameAssets.CART_3_PNG,0.1,1,50,true,false);
		rightCart.kind = FURNITURE;
		rightCart.recolour();

		var rightVendor:Other = new Other(rightCart.x + 5*8,rightCart.y + 5*8,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL,null);

		display.add(leftCart);
		display.add(leftVendor);
		others.add(leftVendor);

		display.add(centerCart);

		display.add(rightCart);
		display.add(rightVendor);
		others.add(rightVendor);
	}


	private function createWanderers():Void
	{
		if (Math.random() > 0.2)
		{
			var o:Other = new Other(100,380,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}

		if (Math.random() > 0.2)
		{
			var o:Other = new Other(300,180,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}

		if (Math.random() > 0.2)
		{
			var o:Other = new Other(400,300,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}
	}


	override public function destroy():Void
	{
		super.destroy();

		display.destroy();
	}


	override public function update():Void
	{
		super.update();

		switch (state)
		{
			case FADE_IN:

			case TITLE:

			case PLAY:
			handleVending();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleVending():Void
	{
		vendingTrigger.x = centerCart.x + centerCart.width/2 - vendingTrigger.width/2;
		vendingTrigger.y = centerCart.hit.y - 20;

		if (vendingComplete) return;

		if (vendingTimer.finished && bastard.hit.overlaps(vendingTrigger) && !vendingComplete)
		{
			vendingTimer.start(1,1,startVending);
		}
		else if (!bastard.hit.overlaps(vendingTrigger))
		{
			vendingTimer.stop();
			vendingTimer.finished = true;
		}

		if (vending)
		{
			vendingTime++;
			if (vendingTime >= VENDING_UNIT_AMOUNT)
			{
				worked = true;
				vendingTimer.stop();
				vendingTimer.finished = true;
				vendingComplete = true;
				showSuccessText(null);
			}
		}
	}



	private function startVending(t:FlxTimer):Void
	{
		vending = true;
	}



	private function handleStanding(t:FlxTimer):Void
	{
		if (state != PLAY) return;

		for (i in 0...others.members.length)
		{
			var o:Other = cast(others.members[i],Other);
			if (o == null || !o.active || o.mode != SEATED) continue;

			if (Math.random() > 0.9)
			{
				o.changeMode(WANDER);
				o.seat.removeOccupant();
			}
		}

		standTimer.start(8,1,handleStanding);
	}


	override private function showArrestText(t:FlxTimer):Void
	{
		super.showArrestText(t);

		if (arrested)
		{
			fired = true;
			Story.fired();
			arrestText.setText("ARRESTED, FIRED, AND UNEMPLOYABLE");
		}
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (copsCalled)
		{
			fired = true;
			Story.fired();
			statsRatingText.setText("F");
			statsRankText.setText("FIRED\nAND UNEMPLOYABLE");	
		}
		else if (vendingComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("EMPLOYEE OF THE WEEK");
		}
		else if (vendingComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("A");
			statsRankText.setText("COULD TRY HARDER");
		}
		else if (!vendingComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("W");
			statsRankText.setText("WASTREL");	
		}
		else if (!vendingComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("L");
			statsRankText.setText("LAYABOUT");	
		}
		else if (!vendingComplete && SceneState.score.currentJostleStrength() >= 10)
		{
			var warning:Int = Story.getJobWarning();
			if (warning == 1)
			{

				statsRatingText.setText("V");
				statsRankText.setText("VERBAL WARNING");	
			}
			else if (warning == 2)
			{

				statsRatingText.setText("W");
				statsRankText.setText("WRITTEN WARNING");	
			}
			else
			{
				fired = true;
				Story.fired();
				statsRatingText.setText("F");
				statsRankText.setText("FIRED AND UNEMPLOYABLE");		
			}
		}
	}	


	override private function addBonuses():Void
	{
		if (vendingComplete)
		{
			addToBonus("+ CART LIFE");
		}
		if (!vendingComplete)
		{
			addToBonus("+ VACANT VENDOR");
		}
		super.addBonuses();
	}

}






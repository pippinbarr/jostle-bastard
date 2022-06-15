
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



class CafeState extends SceneState
{				
	public static var UP_ALLEY_X:Float = 215;
	public static var COUNTER_Y:Float;
	public static var COUNTER_X:Float;
	public static var DOWN_ALLEY_X:Float = 435;

	private var customers:FlxGroup;

	private var server:Other;

	private var queuerTimer:FlxTimer;
	private var customerInMotion:Other = null;
	private var customerInMotionChair:Chair = null;

	private var counterTrigger:FlxSprite;
	private var counterTimer:FlxTimer;

	private var waitingForService:Bool = false;
	private var gotService:Bool = false;
	private var failedService:Bool = false;

	override public function create():Void
	{
		super.create();

		createWalls();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		server = new Other(410,50,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL);
		display.add(server);

		customers = new FlxGroup();

		createCounter();
		createTables();
		
		queuerTimer = new FlxTimer();
	}


	private function sendToCounter(t:FlxTimer):Void
	{
		var chair:Chair = cast(seats.getRandom(),Chair);
		if (chair.occupant != null)
		{
			customerInMotion = chair.occupant;
			customerInMotionChair = chair;
			chair.removeOccupant();
			customerInMotion.startFollowingSetPath();
		}
		else
		{
			queuerTimer.start(1,1,sendToCounter);
		}
	}


	private function createCounter():Void
	{
		var counter:PhysicsSprite = new PhysicsSprite(0,80,GameAssets.CAFE_COUNTER_PNG,0.25,1,10000,false,false);
		counter.kind = FURNITURE;
		counter.recolour(true);
		display.add(counter);

		COUNTER_Y = counter.y + counter.height + 30;
		COUNTER_X = counter.x + counter.width - 100;

		counterTrigger = new FlxSprite(COUNTER_X - 5,COUNTER_Y - 40);
		counterTrigger.makeGraphic(40,40,0xFFFF0000);
		counterTrigger.visible = false;
		add(counterTrigger);

		counterTimer = new FlxTimer();
	}


	private function createTables():Void
	{
		var hMargin:Float = 38;
		var hSpacing:Float = (FlxG.width - hMargin*2)/2.64;

		var vMargin:Float = 180;
		var vSpacing:Float = (FlxG.height - vMargin - 50)/3;

		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 2*vSpacing);
		addTableAndChairs(hMargin + 1*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 1*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 2*vSpacing);
	}




	private function addTableAndChairs(X:Float, Y:Float):Void
	{
		var leftChair:Chair = new Chair(X,Y,FlxObject.RIGHT);
		if (Math.random() > 0.5)
		{
			addCustomerToChair(leftChair);
		}

		var table:Table = new Table(X + leftChair.width + 1,Y);
		
		var rightChair:Chair = new Chair(X + leftChair.width + table.width + 2,Y,FlxObject.LEFT);
		if (Math.random() > 0.5)
		{
			addCustomerToChair(rightChair);
		}

		display.add(table);
		display.add(leftChair);
		display.add(rightChair);

		furniture.add(table);
		furniture.add(leftChair);
		furniture.add(rightChair);

		seats.add(leftChair);
		seats.add(rightChair);
	}


	private function addCustomerToChair(C:Chair):Void
	{
		var walkPath:Array<FlxPoint> = new Array();
		walkPath.push(new FlxPoint(UP_ALLEY_X,0));
		walkPath.push(new FlxPoint(0,COUNTER_Y));
		walkPath.push(new FlxPoint(COUNTER_X,0));
		walkPath.push(new FlxPoint(-10,-10));
		walkPath.push(new FlxPoint(DOWN_ALLEY_X,0));
		walkPath.push(new FlxPoint(0,C.hit.y + C.hit.height + bastard.hit.height * 1.5));
		walkPath.push(new FlxPoint(C.hit.getMidpoint().x,0));
		walkPath.push(new FlxPoint(0,0));

		var customer:Other = new Other(C.x,C.hit.y - 40,GameAssets.PERSON_STANDING_PNG,walkPath,bastard,SEATED);
		customer.body.setActive(false);
		customer.facing = C.facing;
		customer.visible = false;
		customer.active = false;

		others.add(customer);
		customers.add(customer);
		display.add(customer);

		C.addOccupant(customer);
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
			checkQueuer();
			checkCounter();

			case ARRESTED:


			case EXITING:


			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function checkQueuer():Void
	{
		if (customerInMotion != null && customerInMotion.mode != PATH)
		{
			if (customerInMotion.mode == SEATED)
			{
				// queuerTimer.start(Math.random() * 5 + 2,1,sendToCounter);
				queuerTimer.start(Math.random() * 1 + 1,1,sendToCounter);
				customerInMotion = null;
			}
			else
			{
				if (Helpers.getDistance(customerInMotion.hit.getMidpoint(),customerInMotionChair.hit.getMidpoint()) < 40)
				{
					customerInMotionChair.addOccupant(customerInMotion);
				}
			}
		}
	}


	private function checkCounter():Void
	{
		if (gotService || failedService) return;
		if (!bastard.hit.overlaps(counterTrigger)) 
		{
			if (waitingForService) 
			{
				counterTimer.stop();
				counterTimer.finished = true;
			}
			return;
		}
		if (SceneState.score.currentJostleStrength() > 20 ||
			SceneState.score.currentPeopleJostleStrength() > 5)
		{
			noService();
			return;
		}
		if (customerInMotion != null && customerInMotion.hit.overlaps(counterTrigger)) return;
		if (waitingForService) return;

		counterTimer.start(3,1,startTransaction);
		waitingForService = true;
	}


	private function startTransaction(t:FlxTimer):Void
	{
		gotService = true;
		served = true;
		waitingForService = false;
		if (Story.thisScene == CAFE)
		{
			successText.setText("COFFEE UNIT ACQUIRED");
		}
		else if (Story.thisScene == RESTAURANT)
		{
			successText.setText("PIZZA UNIT ACQUIRED");
		}
		else if (Story.thisScene == BAR)
		{
			successText.setText("BEER UNIT ACQUIRED");
		}
		showSuccessText(null);
		// counterTimer.start(2,1,hideSuccessAndFailureTexts);
	}


	private function noService():Void
	{
		failedService = true;
		failText.setText("WE DON'T SERVE BASTARDS");
		counterTimer.start(0.1,1,showFailText);
	}


	override private function titleTweenOutComplete():Void
	{
		super.titleTweenOutComplete();
		// queuerTimer.start(Math.random() * 5 + 2,1,sendToCounter);	
		queuerTimer.start(Math.random() * 1 + 1,1,sendToCounter);	
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (gotService && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");

			if (Story.thisScene == CAFE)
			{
				statsRankText.setText("MR. COFFEE");
			}
			else if (Story.thisScene == RESTAURANT)
			{
				statsRankText.setText("PIZZA LOVER");
			}
			else if (Story.thisScene == BAR)
			{
				statsRankText.setText("BEER GOGGLED");
			}
		}
		else if (gotService && !arrested)
		{
			statsRatingText.setText("C");
			if (Story.thisScene == CAFE)
			{
				statsRankText.setText("COFFEE CRANK");
			}
			else if (Story.thisScene == RESTAURANT)
			{
				statsRankText.setText("PIZZA PEST");
			}
			else if (Story.thisScene == BAR)
			{
				statsRankText.setText("BEER BULLY");
			}
		}
	}


	override private function addBonuses():Void
	{
		if (Story.thisScene == CAFE && SceneState.score.currentJostleStrength() > 1000)
		{
			addToBonus("+ CAFE CRASHER");
		}
		if (Story.thisScene == RESTAURANT && SceneState.score.currentJostleStrength() > 1000)
		{
			addToBonus("+ RESTAURANT WRECKER");
		}
		if (Story.thisScene == BAR && SceneState.score.currentJostleStrength() > 1000)
		{
			addToBonus("+ BAR BRAWLER");
		}
		super.addBonuses();
	}


	override private function handleCops():Void
	{
		super.handleCops();

		if (state == ARRESTED)
		{
			queuerTimer.stop();
		}
	}

}
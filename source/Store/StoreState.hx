
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;
import org.flixel.util.FlxPoint;


import flash.display.Sprite;



class StoreState extends SceneState
{				
	private var shelves:FlxGroup;
	private var server:Other;

	private var counterTrigger:FlxSprite;
	private var counterTimer:FlxTimer;
	private var waitingForService:Bool = false;
	private var gotService:Bool = false;
	private var failedService:Bool = false;


	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		shelves = new FlxGroup();

		createWalls();
		createShelves();
		createCounter();
		createWanderers();

		server = new Other(450,360,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL);
		display.add(server);

		counterTimer = new FlxTimer();
	}


	private function createShelves():Void
	{
		addShelf(3*8,8*8);
		addShelf(3*8,26*8);
		addShelf(3*8,44*8);
		addShelf(50*8,8*8);
		addShelf(50*8,26*8);
	}


	private function addShelf(X:Float,Y:Float):Void
	{
		var shelf:PhysicsSprite;
		if (Story.thisScene != BOOKSTORE)
		shelf = new PhysicsSprite(X,Y,GameAssets.SHELVES_PNG,0.25,1,10,true,false);
		else
		shelf = new PhysicsSprite(X,Y,GameAssets.BOOKSHELVES_PNG,0.25,1,10,true,false);
		shelf.kind = FURNITURE;
		shelf.recolour();
		display.add(shelf);
		shelves.add(shelf);
		furniture.add(shelf);
	}


	private function createWanderers():Void
	{
		addWanderer(100,100,0.75);
		addWanderer(50,40,0.75);
		addWanderer(480,40,0.75);
		addWanderer(380,250,0.75);
		addWanderer(80,260,0.75);
		addWanderer(90,380,0.75);
		addWanderer(420,170,0.75);
	}


	private function addWanderer(X:Float,Y:Float,P:Float):Void
	{
		if (Math.random() > P) return;

		var o:Other = new Other(X,Y,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
		display.add(o);
		others.add(o);
	}

	private function createCounter():Void
	{
		var counterTop:Wall = new Wall(55*8,FlxG.height - 17*8,16*8,5*8);
		counterTop.kind = FURNITURE;
		display.add(counterTop);

		var counterSide:Wall = new Wall(50*8,FlxG.height - 17*8,5*8,16*8);
		counterTop.kind = FURNITURE;
		display.add(counterSide);

		// var register:PhysicsSprite = new PhysicsSprite(0,0,GameAssets.CASH_REGISTER_PNG,1,1,10000,false,false);
		var register:PhysicsSprite = new PhysicsSprite(counterSide.x + 2*8,counterSide.y + 7*8,GameAssets.CASH_REGISTER_PNG,0,0,10000,false,false);
		display.add(register);
		register.recolour();
		register.depth = 10000;

		counterTrigger = new FlxSprite(counterSide.x - 30,counterSide.y + 50);
		counterTrigger.makeGraphic(40,60,0xFFFF0000);
		counterTrigger.visible = false;
		add(counterTrigger);
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
			checkCounter();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
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

		if (waitingForService) return;

		counterTimer.start(3,1,startTransaction);
		waitingForService = true;
	}


	private function startTransaction(t:FlxTimer):Void
	{
		gotService = true;
		served = true;
		waitingForService = false;
		if (Story.thisScene == STORE)
		successText.setText("GUM UNIT ACQUIRED");
		else if (Story.thisScene == PHARMACY)
		successText.setText("CORTISONE CREAM UNIT ACQUIRED");
		else if (Story.thisScene == BOOKSTORE)
		successText.setText("BOOK UNIT ACQUIRED");
		showSuccessText(null);
		// counterTimer.start(2,1,hideSuccessAndFailureTexts);
	}


	private function noService():Void
	{
		failedService = true;
		failText.setText("WE DON'T SERVE BASTARDS");
		counterTimer.start(2,1,showFailText);
	}

	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (gotService && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			if (Story.thisScene == STORE)
			{
				statsRankText.setText("GUM CHEWER");
			}
			else if (Story.thisScene == PHARMACY)
			{
				statsRankText.setText("LESS ECZEMA");
			}
			else if (Story.thisScene == BOOKSTORE)
			{
				statsRankText.setText("HEAVY READER");
			}
		}
		else if (gotService)
		{
			statsRatingText.setText("B");
			statsRankText.setText("TOUGH CUSTOMER");	
		}
	}


	override private function addBonuses():Void
	{
		if (Story.thisScene == PHARMACY && gotService)
		{
			addToBonus("+ HYPERCONDRIAC");
		}
		else if (Story.thisScene == STORE && gotService)
		{
			addToBonus("+ GUMMY SMILE");
		}
		else if (Story.thisScene == BOOKSTORE && gotService)
		{
			addToBonus("+ BOOK WORM");
		}
		if (gotService)
		{
			addToBonus("+ CAPITALIST");
		}
		if (!gotService)
		{
			addToBonus("+ WHY DID I COME IN HERE AGAIN?");
		}
		super.addBonuses();
	}
}
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxG;

import org.flixel.util.FlxTimer;
import org.flixel.util.FlxPoint;


enum ApartmentStateState
{
	NORMAL;
	TV;
}



class ApartmentState extends SceneState
{					
	private var bastardCell:Cell;

	private var apartmentState:ApartmentStateState;

	private var apartmentWidth:Float;

	private var tv:PhysicsSprite;
	private var tvTrigger:FlxSprite;
	private var tvText:FlxTextWithBG;

	public static var bedLocation:FlxPoint;
	public static var dresserLocation:FlxPoint;
	public static var armchair1Location:FlxPoint;
	public static var armchair2Location:FlxPoint;
	public static var tvLocation:FlxPoint;
	public static var chair1Location:FlxPoint;
	public static var chair2Location:FlxPoint;
	public static var tableLocation:FlxPoint;
	public static var fridgeLocation:FlxPoint;
	public static var stoveLocation:FlxPoint;

	private var bed:PhysicsSprite;
	private var dresser:PhysicsSprite;
	private var armchair1:PhysicsSprite;
	private var armchair2:PhysicsSprite;
	private var chair1:Chair;
	private var chair2:Chair;
	private var table:Table;
	private var fridge:PhysicsSprite;
	private var stove:PhysicsSprite;

	private var blackFG:FlxSprite;
	private var dateText:FlxTextWithBG;
	private var dateFadeAmount:Float = 0.02;

	public function new():Void
	{
		super();
	}


	override public function create():Void
	{
		fadeInNow = false;

		super.create();

		bastard = new Bastard(480,100);
		display.add(bastard);

		createWalls();
		placeFurniture();

		thisSceneType = APARTMENT;
		apartmentState = NORMAL;

		blackFG = new FlxSprite(0,0);
		blackFG.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
		blackFG.alpha = 1;
		fg.add(blackFG);

		dateText = new FlxTextWithBG(0,0,FlxG.width,Helpers.dateToString(Story.date),24,"center",0xFFFFFFFF,0xFF000000);
		dateText.y = FlxG.height / 2 - dateText.height / 2;
		dateText.alpha = 0.00001;
		fg.add(dateText);
	}


	override private function createWalls():Void
	{
		var leftWall:Wall = new Wall(10*8,0,8,FlxG.height);
		display.add(leftWall);

		var topWall:Wall = new Wall(10*8 + 8,0,Std.int(FlxG.width - 2*10*8),8);
		display.add(topWall);
		apartmentWidth = topWall.width;

		var rightWall:Wall = new Wall(FlxG.width - 10*8,8,8,Std.int(FlxG.height - 8));
		display.add(rightWall);

		var bottomLeftWall:Wall = new Wall(leftWall.x + 8,FlxG.height - 8,27*8,8);
		display.add(bottomLeftWall);

		var bottomRightWall:Wall = new Wall(rightWall.x - 21*8,FlxG.height - 8,21*8,8);
		display.add(bottomRightWall);

		var topBound:PhysicsSprite = new PhysicsSprite(10,80,GameAssets.WALL_TOP_PNG,1,1,1000,false);

		var bathroomTopWall:Wall = new Wall(rightWall.x - 168,232,168,8);
		display.add(bathroomTopWall);

		var bathroomLeftWall:Wall = new Wall(bathroomTopWall.x,bathroomTopWall.y + 8,8,152);
		display.add(bathroomLeftWall);
	}


	private function placeFurniture():Void
	{

		if (ApartmentState.bedLocation == null)
		{
			ApartmentState.bedLocation = new FlxPoint(Std.int(apartmentWidth - 6*8),Std.int(18*8));
		}
		bed = new PhysicsSprite(ApartmentState.bedLocation.x,ApartmentState.bedLocation.y,GameAssets.BED_PNG,0.25,1,5,true,false);

		bed.kind = FURNITURE;
		bed.recolour(true);
		display.add(bed);
		furniture.add(bed);

		if (ApartmentState.dresserLocation == null)
		{
			ApartmentState.dresserLocation = new FlxPoint(apartmentWidth - 6*8,7*8);
		}
		dresser = new PhysicsSprite(ApartmentState.dresserLocation.x,ApartmentState.dresserLocation.y,GameAssets.DRESSER_PNG,0.25,1,5,true,false);
		dresser.kind = FURNITURE;
		dresser.recolour(true);
		display.add(dresser);
		furniture.add(dresser);

		if (ApartmentState.tvLocation == null)
		{
			ApartmentState.tvLocation = new FlxPoint(30*8,12*8);
		}
		tv = new PhysicsSprite(ApartmentState.tvLocation.x,ApartmentState.tvLocation.y,GameAssets.TV_PNG,0.25,0.5,2,true,false);
		tv.loadGraphic(GameAssets.TV_PNG,true,false,48,72,true);
		tv.addAnimation("flicker",[0,1,0,1,1,0,1,1,0,0,0,1,1,0,0,1,0,1,1,1,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1],30);
		tv.play("flicker");
		tv.recolour(true);
		tv.kind = FURNITURE;
		display.add(tv);
		furniture.add(tv);

		tvTrigger = new FlxSprite(tv.x,tv.y + tv.height/2);
		tvTrigger.makeGraphic(Std.int(tv.width),Std.int(tv.height * 0.75),0xFFFF0000);
		// add(tvTrigger);

		tvText = new FlxTextWithBG(tv.x - 50,tv.y - 50,100 + tv.width,"",14,"center",0xFF000000,GameAssets.WALL_REPLACEMENT);
		tvText.x = tv.x - 50;
		tvText.y = tv.y - 20 - tvText.height;
		tvText.alpha = 0;
		fg.add(tvText);

		if (ApartmentState.armchair1Location == null)
		{
			ApartmentState.armchair1Location = new FlxPoint(12*8,6*8);
		}
		armchair1 = new PhysicsSprite(ApartmentState.armchair1Location.x,ApartmentState.armchair1Location.y,GameAssets.ARMCHAIR_PNG,0.25,1,2,true,false);
		armchair1.kind = FURNITURE;
		armchair1.recolour(true);
		display.add(armchair1);
		furniture.add(armchair1);

		if (ApartmentState.armchair2Location == null)
		{
			ApartmentState.armchair2Location = new FlxPoint(12*8,16*8);
		}
		armchair2 = new PhysicsSprite(ApartmentState.armchair2Location.x,ApartmentState.armchair2Location.y,GameAssets.ARMCHAIR_PNG,0.25,1,2,true,false);
		armchair2.kind = FURNITURE;
		display.add(armchair2);
		furniture.add(armchair2);

		if (ApartmentState.fridgeLocation == null)
		{
			ApartmentState.fridgeLocation = new FlxPoint(12*8,30*8);
		}
		fridge = new PhysicsSprite(ApartmentState.fridgeLocation.x,ApartmentState.fridgeLocation.y,GameAssets.FRIDGE_PNG,0.25,1,8,true,false);
		fridge.kind = FURNITURE;
		fridge.recolour(true);
		display.add(fridge);
		furniture.add(fridge);

		if (ApartmentState.stoveLocation == null)
		{
			ApartmentState.stoveLocation = new FlxPoint(12*8,44*8);
		}
		stove = new PhysicsSprite(ApartmentState.stoveLocation.x,ApartmentState.stoveLocation.y,GameAssets.STOVE_PNG,0.25,1,8,true,false);
		stove.kind = FURNITURE;
		stove.recolour(true);
		display.add(stove);
		furniture.add(stove);

		var counter:Wall = new Wall(12*8,54*8,22*8,4*8);
		counter.kind = FURNITURE;
		display.add(counter);
		furniture.add(counter);

		var counter2:Wall = new Wall(counter.x + counter.width,counter.y - 8*8,4*8,12*8);
		counter2.kind = FURNITURE;
		display.add(counter2);
		furniture.add(counter2);

		if (ApartmentState.chair1Location == null)
		{
			ApartmentState.chair1Location = new FlxPoint(20*8,27*8);
		}
		chair1 = new Chair(ApartmentState.chair1Location.x,ApartmentState.chair1Location.y,FlxObject.RIGHT);
		display.add(chair1);
		furniture.add(chair1);

		if (ApartmentState.tableLocation == null)
		{
			ApartmentState.tableLocation = new FlxPoint(26*8,27*8);
		}
		table = new Table(ApartmentState.tableLocation.x,ApartmentState.tableLocation.y);
		display.add(table);
		furniture.add(table);

		if (ApartmentState.chair2Location == null)
		{
			ApartmentState.chair2Location = new FlxPoint(34*8,27*8);
		}
		chair2 = new Chair(ApartmentState.chair2Location.x,ApartmentState.chair2Location.y,FlxObject.LEFT);
		display.add(chair2);
		furniture.add(chair2);

		var sink:PhysicsSprite = new PhysicsSprite(50*8,43*8,GameAssets.SINK_PNG,0.25,1,1000,false,false);
		sink.kind = FURNITURE;
		sink.recolour(true);
		display.add(sink);
		furniture.add(sink);

		var shower:PhysicsSprite = new PhysicsSprite(60*8,33*8,GameAssets.SHOWER_PNG,0.25,1,1000,false,false);
		shower.kind = FURNITURE;
		shower.recolour(true);
		display.add(shower);
		furniture.add(shower);

		var toilet:PhysicsSprite = new PhysicsSprite(63*8,51*8,GameAssets.TOILET_PNG,0.25,1,1000,false,false);
		toilet.kind = FURNITURE;
		// toilet.replaceF = true;
		// toilet.replaceH = true;
		// toilet.replaceW = true;
		toilet.recolour(true);
		display.add(toilet);
		furniture.add(toilet);
	}


	override public function destroy():Void
	{
		ApartmentState.bedLocation.x = bed.x;
		ApartmentState.bedLocation.y = bed.y + bed.hit.height/2;

		ApartmentState.dresserLocation.x = dresser.x;
		ApartmentState.dresserLocation.y = dresser.y + dresser.hit.height/2;

		ApartmentState.tvLocation.x = tv.x;
		ApartmentState.tvLocation.y = tv.y + tv.hit.height/2;

		ApartmentState.armchair1Location.x = armchair1.x;
		ApartmentState.armchair1Location.y = armchair1.y + armchair1.hit.height/2;

		ApartmentState.armchair2Location.x = armchair2.x;
		ApartmentState.armchair2Location.y = armchair2.y + armchair2.hit.height/2;

		ApartmentState.chair1Location.x = chair1.x;
		ApartmentState.chair1Location.y = chair1.y + chair1.hit.height/2;

		ApartmentState.chair2Location.x = chair2.x;
		ApartmentState.chair2Location.y = chair2.y + chair2.hit.height/2;

		ApartmentState.tableLocation.x = table.x;
		ApartmentState.tableLocation.y = table.y + table.hit.height/2;

		ApartmentState.stoveLocation.x = stove.x;
		ApartmentState.stoveLocation.y = stove.y + stove.hit.height/2;

		ApartmentState.fridgeLocation.x = fridge.x;
		ApartmentState.fridgeLocation.y = fridge.y + fridge.hit.height/2;


		super.destroy();

		display.destroy();
	}


	private function handleDate():Void
	{
		dateText.alpha += dateFadeAmount;
		if (dateText.alpha >= 1)
		{
			dateFadeAmount = -0.02;
		}
		else if (dateText.alpha <= 0)
		{
			fadeIn();
			
			dateFadeAmount = 0;
			dateText.visible = false;
			blackFG.visible = false;
			dateText.alpha = 0.5;
		}
	}

	override public function update():Void
	{
		super.update();

		handleDate();

		tvTrigger.x = tv.x;
		tvTrigger.y = tv.y + tv.height/2;

		tvText.x = tv.x - 50;
		tvText.y = tv.y - 10 - tvText.height;

		if (tvText.x < 0) tvText.x = 0;
		else if (tvText.x + tvText.width > FlxG.width) tvText.x = FlxG.width - tvText.width;
		if (tvText.y < 0) tvText.y = 0;
		else if (tvText.y + tvText.height > FlxG.height) tvText.y = FlxG.height - tvText.height;


		switch (state)
		{
			case FADE_IN:

			case TITLE:

			case PLAY:
			handleTVTrigger();

			case ARRESTED:

			case EXITING:
			tvText.visible = false;

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleTVTrigger():Void
	{
		if (bastard.hit.overlaps(tvTrigger) && tvText.visible == false)
		{
			tvText.setText(Story.getApartmentTVText());
			tvText.x = tv.x - 50;
			tvText.y = tv.y - 10 - tvText.height;
			tvText.visible = true;
			tvText.bg.flicker(1000);
		}
		else if (!bastard.hit.overlaps(tvTrigger) || !tvText.bg.flickering)
		{
			tvText.visible = false;
		}
	}


	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (!Story.hasJob)
		{
			statsRatingText.setText("E");
			statsRankText.setText("EVICTED\n(NO JOB = NO RENT)");
			Story.evicted();
		}
		else if (SceneState.score.furniture < 50 && SceneState.score.b_into_w > 50)
		{
			statsRatingText.setText("NN");
			statsRankText.setText("NOISY NEIGHBOUR");
		}
		else if (SceneState.score.furniture == 0)
		{
			statsRatingText.setText("AAA");
			statsRankText.setText("PERFECT TENANT");
		}
		else if (SceneState.score.furniture < 10)
		{
			statsRatingText.setText("A");
			statsRankText.setText("GOOD NEIGHBOUR");
		}
		else if (SceneState.score.furniture < 50)
		{
			statsRatingText.setText("B");
			statsRankText.setText("BUILDING NUISANCE");
		}
		else if (SceneState.score.furniture < 100)
		{
			statsRatingText.setText("BB");
			statsRankText.setText("HOME WRECKER");
		}
		else
		{
			handleEvictionNotifications();
		}		
	}


	override private function addBonuses():Void
	{
		if (avengersSent && SceneState.score.furniture < 100)
		{
			addToBonus("+ ROUGHHOUSING");
		}
		if (tv.jostled)
		{
			addToBonus("+ TELEVISION VIOLENCE");
		}
		if (stove.jostled)
		{
			addToBonus("+ BAD COOK");
		}
		if (SceneState.score.furniture > 500)
		{
			addToBonus("+ REARRANGING THE FURNITURE");
		}
		super.addBonuses();
	}


	private function handleEvictionNotifications():Void
	{
		var warning:Int = Story.getApartmentWarning();
		if (warning == 1)
		{
			statsRatingText.setText("W");
			statsRankText.setText("EVICTION WARNING");
		}
		else if (warning == 2)
		{
			statsRatingText.setText("WW");
			statsRankText.setText("EVICTION THREAT");				
		}
		else
		{
			statsRatingText.setText("E");
			statsRankText.setText("EVICTED");
			Story.evicted();
		}
	}


	// COPS //

	override private function handleCops():Void
	{
		return;
	}
}
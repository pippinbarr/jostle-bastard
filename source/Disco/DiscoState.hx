
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;


class DiscoState extends SceneState
{				
	private static var DANCE_UNIT_AMOUNT:Int = 30 * 10;

	private var customers:FlxGroup;

	private var danceTimer:FlxTimer;
	private var dancing:Bool = false;
	private var danceComplete:Bool = false;
	private var danceTime:Int = 0;

	private var dancefloor:PhysicsSprite;
	private var dancefloorTrigger:FlxSprite;

	private var danceFrames:Int = 0;


	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);

		customers = new FlxGroup();

		createWalls();
		createDancefloor();
		createTablesAndChairs();

		danceTimer = new FlxTimer();
		danceTimer.finished = true;

		successText.setText("DANCE UNIT COMPLETED");
	}


	private function createDancefloor():Void
	{
		dancefloor = new PhysicsSprite(21*8,11*8,GameAssets.DANCEFLOOR_PNG,0,0,0,false,false);
		dancefloor.loadGraphic(GameAssets.DANCEFLOOR_PNG,true,false,296,296,true);
		dancefloor.addAnimation("lights",[0,1,0,1],10,true);
		dancefloor.recolour();
		dancefloor.play("lights");

		display.add(dancefloor);

		dancefloorTrigger = new FlxSprite(0,0);
		dancefloorTrigger.makeGraphic(Std.int(dancefloor.width * 0.7),Std.int(dancefloor.height * 0.7),0xFFFF0000);
		dancefloorTrigger.x = dancefloor.x + dancefloor.width/2 - dancefloorTrigger.width/2;
		dancefloorTrigger.y = dancefloor.y + dancefloor.height/2 - dancefloorTrigger.height/2;
		// add(dancefloorTrigger);

		var d:Other = new Other(dancefloor.x + 10*8,dancefloor.y + 2*8,GameAssets.PERSON_STANDING_PNG,null,bastard,DANCE);
		display.add(d);
		others.add(d);

		var d2:Other = new Other(dancefloor.x + 13*8,dancefloor.y + 20*8,GameAssets.PERSON_STANDING_PNG,null,bastard,DANCE);
		display.add(d2);
		others.add(d2);

		var d3:Other = new Other(dancefloor.x + 26*8,dancefloor.y + 8*8,GameAssets.PERSON_STANDING_PNG,null,bastard,DANCE);
		display.add(d3);
		others.add(d3);

		var d4:Other = new Other(dancefloor.x + 12*8,dancefloor.y + 15*8,GameAssets.PERSON_STANDING_PNG,null,bastard,DANCE);
		display.add(d4);
		others.add(d4);
	}


	private function createTablesAndChairs():Void
	{
		addTableAndChairs(2*8,8*8);
		addTableAndChairs(2*8,20*8);
		addTableAndChairs(2*8,32*8);
		addTableAndChairs(2*8,44*8);

		addTableAndChairs(61*8,8*8);
		addTableAndChairs(61*8,20*8);
		addTableAndChairs(61*8,32*8);
		addTableAndChairs(61*8,44*8);
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
		var customer:Other = new Other(C.x,C.hit.y - 40,GameAssets.PERSON_STANDING_PNG,null,bastard,SEATED);
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
			danceFrames++;
			if (danceFrames == 20) 
			{
				danceFrames = 0;
				dancefloor.frame = 1 - dancefloor.frame;
			}
			handleOthers();
			handleDancing();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleOthers():Void
	{
		for (i in 0...others.members.length)
		{
			var o:Other = cast(others.members[i],Other);
			if (o == null || !o.active) continue;

			if (o.hit.overlaps(dancefloorTrigger))
			{
				o.changeMode(DANCE);
			}			
			else if (o.mode == SEATED)
			{
				if (Math.random() < 0.00005)
				{
					o.seat.removeOccupant();
					o.changeMode(WANDER);
				}
			}
			else
			{
				o.changeMode(WANDER);
			}
		}
	}


	private function handleDancing():Void
	{
		if (danceComplete) return;

		if (danceTimer.finished && bastard.hit.overlaps(dancefloorTrigger) && !danceComplete)
		{
			danceTimer.start(1,1,startDance);
		}
		else if (!bastard.hit.overlaps(dancefloorTrigger))
		{
			danceTimer.stop();
			danceTimer.finished = true;
		}

		if (dancing && (bastard.body.getLinearVelocity().x != 0 || bastard.body.getLinearVelocity().y != 0))
		{
			danceTime++;
			if (danceTime >= DANCE_UNIT_AMOUNT)
			{
				danceTimer.stop();
				danceTimer.finished = true;
				danceComplete = true;
				showSuccessText(null);
			}
		}
	}


	private function startDance(t:FlxTimer):Void
	{
		dancing = true;
	}




	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (danceComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("DANCING KING");
		}
		else if (danceComplete)
		{
			statsRatingText.setText("D");
			statsRankText.setText("DISCO FEVERISH");
		}	
	}


	override private function addBonuses():Void
	{
		if (!danceComplete)
		{
			addToBonus("+ WALLFLOWER");
		}
		super.addBonuses();
	}
}






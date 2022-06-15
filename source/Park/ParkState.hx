
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxText;
import org.flixel.FlxGroup;

import org.flixel.util.FlxTimer;
import org.flixel.util.FlxPoint;


import flash.display.Sprite;



class ParkState extends SceneState
{				
	private static var SUCCESS_TIME:Float = 10;
	
	private var natureCompleted:Bool = false;

	private var successTimer:FlxTimer;

	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);

		display.add(bastard);

		createWalls();
		createBenches();
		createTrees();
		createWanderers();

		successTimer = new FlxTimer();

		thisSceneType = PARK;
	}



	override private function createWalls():Void
	{
		super.createWalls();

		// var fence:PhysicsSprite = new PhysicsSprite(0,0,GameAssets.FENCE_PNG,0,0,10000,false,false);
		// fence.replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
		// display.add(fence);
	}


	private function createBenches():Void
	{
		addBench(28*8,47*8,FlxObject.RIGHT);
		addBench(46*8,47*8,FlxObject.LEFT);
		addBench(44*8,20*8,FlxObject.RIGHT);
		addBench(32*8,20*8,FlxObject.LEFT);
		addBench(14*8,20*8,FlxObject.RIGHT,false);
		addBench(60*8,20*8,FlxObject.LEFT);
	}


	private function addBench(X:Float,Y:Float,Facing:UInt,Occupiable:Bool = true):Void
	{
		var bench:ParkBench = new ParkBench(X,Y,Facing);
		display.add(bench);
		furniture.add(bench);
		seats.add(bench);

		if (Occupiable && Math.random() > 0.5)
		{
			var o:Other = new Other(100,100,GameAssets.PERSON_STANDING_PNG,null,bastard,SEATED);
			bench.addOccupant(o);
			display.add(o);
			others.add(o);
		}
	}


	private function createWanderers():Void
	{
		if (Math.random() > 0.5)
		{
			var o:Other = new Other(100,380,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}

		if (Math.random() > 0.5)
		{
			var o:Other = new Other(300,180,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}

		if (Math.random() > 0.5)
		{
			var o:Other = new Other(400,300,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER);
			display.add(o);
			others.add(o);
		}
	}


	private function createTrees():Void
	{
		var tree1:PhysicsSprite = new PhysicsSprite(10*8,4*8,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree1.offset.x += tree1.width * 0.45;
		tree1.recolour();
		display.add(tree1);

		var tree2:PhysicsSprite = new PhysicsSprite(tree1.x,tree1.y + tree1.height + 3*8,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree2.offset.x += tree2.width * 0.45;
		display.add(tree2);

		var tree3:PhysicsSprite = new PhysicsSprite(FlxG.width - 12*8,4*8,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree3.offset.x += tree3.width * 0.45;
		display.add(tree3);

		var tree4:PhysicsSprite = new PhysicsSprite(tree3.x,tree3.y + tree3.height + 3*8,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree4.offset.x += tree4.width * 0.45;
		display.add(tree4);

		var tree5:PhysicsSprite = new PhysicsSprite(tree2.x + tree2.width + 2*8,tree2.y,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree5.offset.x += tree5.width * 0.45;
		display.add(tree5);

		var tree6:PhysicsSprite = new PhysicsSprite(tree4.x - tree4.width - 2*8,tree4.y,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree6.offset.x += tree6.width * 0.45;
		display.add(tree6);

		var tree7:PhysicsSprite = new PhysicsSprite(FlxG.width/2,tree1.y,GameAssets.TREE_PNG,0.1,0.1,10000,false,false);
		tree7.offset.x += tree7.width * 0.45;
		display.add(tree7);
	}


	override private function titleTweenOutComplete():Void
	{
		super.titleTweenOutComplete();

		successTimer.start(SUCCESS_TIME,1,successTimerComplete);
	}


	private function successTimerComplete(t:FlxTimer):Void
	{
		natureCompleted = true;
		successText.setText("NATURE UNIT COMPLETED");
		showSuccessText(null);
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

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (natureCompleted && SceneState.score.currentJostleStrength() == 0)
		{
			statsRatingText.setText("A");
			statsRankText.setText("NATURE LOVER");
		}
		else if (natureCompleted && SceneState.score.currentJostleStrength() <= 10)
		{
			statsRatingText.setText("GG");
			statsRankText.setText("GARDEN GNOME");
		}
		else if (natureCompleted)
		{
			statsRatingText.setText("P");
			statsRankText.setText("PARK TERROR");	
		}
	}


	override private function addBonuses():Void
	{
		if (natureCompleted)
		{
			addToBonus("+ FRESH AIR");
		}
		if (natureCompleted && SceneState.score.people > 100)
		{
			addToBonus("+ WILD BEAST");
		}
		if (!natureCompleted)
		{
			addToBonus("+ SCREW NATURE");
		}
		if (!natureCompleted && SceneState.score.people > 100)
		{
			addToBonus("+ UNNATURALLY PUSHY");
		}

		super.addBonuses();
	}




}

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






class AlleyHomeState extends SceneState
{					

	private var leftMargin:Float;
	private var rightMarginThin:Float;
	private var rightMarginWide:Float;
	private var topMargin:Float;
	private var bottomMarginHigh:Float;

	private var blackFG:FlxSprite;
	private var dateText:FlxTextWithBG;
	private var dateFadeAmount:Float = 0.02;


	override public function create():Void
	{
		fadeInNow = false;

		super.create();

		bastard = new Bastard(FlxG.width - 100,30);
		display.add(bastard);

		createWalls();
		createTrash();
		createOthers();
		
		thisSceneType = ALLEYHOME;

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
		var leftWall:Wall = new Wall(0,0,224,FlxG.height + 200);
		display.add(leftWall);

		var topWall:Wall = new Wall(leftWall.width,0,Std.int(FlxG.width - leftWall.width),8);
		display.add(topWall);

		var rightWall:Wall = new Wall(FlxG.width - 8,topWall.height,8,Std.int(FlxG.height - topWall.height));
		display.add(rightWall);

		var rightBlock:Wall = new Wall(FlxG.width - 256 - 8,FlxG.height - 352,Std.int(FlxG.width - 256 - 8),500);
		display.add(rightBlock);

		var topBound:PhysicsSprite = new PhysicsSprite(10,60,GameAssets.WALL_TOP_PNG,1,1,1000,false);


		leftMargin = leftWall.x + leftWall.width;
		rightMarginThin = rightBlock.x;
		rightMarginWide = rightWall.x;
		topMargin = topBound.y + topBound.height;
		bottomMarginHigh = rightBlock.y;
	}


	private function createTrash():Void
	{
		var trashAmount = 15 + Std.int(Math.random() * 15);
		for (i in 0...trashAmount)
		{
			var s:String = "";
			var r:Float = Math.random();
			if (r < 0.25) s = GameAssets.TRASH_1_PNG;
			else if (r < 0.5) s = GameAssets.TRASH_2_PNG;
			else if (r < 0.75) s = GameAssets.TRASH_3_PNG;
			else s = GameAssets.TRASH_4_PNG;

			var X:Float;
			var Y:Float;
			if (Math.random() > 0.5)
			{
		   	   // wide
		   	   X = leftMargin + Math.random() * (rightMarginWide - leftMargin - 16);
		   	   Y = topMargin + Math.random() * (bottomMarginHigh - topMargin - 16);
		   	}
		   	else
		   	{
		   	   // narrow
		   	   X = leftMargin + Math.random() * (rightMarginThin - leftMargin - 16);
		   	   Y = topMargin + Math.random() * (FlxG.height - topMargin - 16);
		   	}

		   	var t:PhysicsSprite = new PhysicsSprite(X,Y,s,0.2,1,0.2,true,false);
		   	t.recolour(true);
		   	display.add(t);
		   }
		}


		private function createOthers():Void
		{
			if (Math.random() > 0.5)
			{
				var X:Float = leftMargin + 50;
				var Y:Float = topMargin + 100;
				var o:Other = new Other(X,Y,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER,null);
				if (Math.random() > 0.75) o.changeMood(ANGRY);

				display.add(o);
				others.add(o);
			}

			if (Math.random() > 0.5)
			{
				var X:Float = leftMargin + 80;
				var Y:Float = topMargin + 220;
				var o:Other = new Other(X,Y,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER,null);
				if (Math.random() > 0.75) o.changeMood(ANGRY);

				display.add(o);
				others.add(o);
			}

			if (Math.random() > 0.5)
			{
				var X:Float = leftMargin + 8;
				var Y:Float = topMargin + 310;
				var o:Other = new Other(X,Y,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER,null);
				if (Math.random() > 0.75) o.changeMood(ANGRY);

				display.add(o);
				others.add(o);
			}
		}


		override public function destroy():Void
		{
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

			switch (state)
			{
				case FADE_IN:

				case TITLE:

				case PLAY:

				case ARRESTED:

				case EXITING:

				case STATS:

				case FADE_OUT:

				case COMPLETE:
			}

			display.sort("depth");
		}


		override private function handleCops():Void
		{
		// No arrests.
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();
	}


	override private function addBonuses():Void
	{
		addToBonus("+ ALLEY RAT");
		if (SceneState.score.trash > 0)
		{
			addToBonus("+ TRASHY");
		}

		super.addBonuses();
	}
}
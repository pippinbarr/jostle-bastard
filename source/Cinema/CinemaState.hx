
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


class CinemaState extends SceneState
{				
	private static var CINEMA_UNIT_AMOUNT:Int = 30 * 10;

	private var bastardSeat:CinemaSeat;
	private var seatTrigger:FlxSprite;
	private var seatTimer:FlxTimer;
	private var viewing:Bool = false;
	private var viewingComplete:Bool = false;
	private var viewingTime:Int = 0;

	private var screenGroup:FlxGroup;
	private var movieStars:FlxGroup;
	private var movieTimer:FlxTimer;

	override public function create():Void
	{
		super.create();

		bastard = new Bastard(FlxG.width / 2 - 20,FlxG.height - 80);
		display.add(bastard);


		createWalls();
		createSeats();
		createScreen();

		seatTimer = new FlxTimer();
		seatTimer.finished = true;

		successText.setText("CINEMA UNIT ACQUIRED");
	}


	private function createScreen():Void
	{
		screenGroup = new FlxGroup();

		topBound.body.setPosition(new B2Vec2(Physics.screenToWorld(FlxG.width/2),Physics.screenToWorld(10*8)));

		var screenSpriteBG:PhysicsSprite = new PhysicsSprite(8,0,GameAssets.CINEMA_SCREEN_BG_PNG,0,0,0,false,false);
		var screenSprite:PhysicsSprite = new PhysicsSprite(8,0,GameAssets.CINEMA_SCREEN_PNG,0.05,1,100000,false,false);
		screenSprite.kind = FURNITURE;

		// Create a bounding box for the screen
		var screenTop:Wall = new Wall(15*8,1*8,50*8,1*8);
		var screenLeft:Wall = new Wall(15*8,2*8,1*8,20*8);
		var screenRight:Wall = new Wall(15*8 + 49*8,2*8,1*8,20*8);
		var screenBottom:Wall = new Wall(15*8,1*8 + 20*8,50*8,1*8);

		// Create images for the screen

		screenGroup.add(screenSpriteBG);

		screenSpriteBG.recolour();
		screenSprite.recolour();

		movieStars = new FlxGroup();

		var o1:MovieStar = new MovieStar(screenLeft.x + 6*8,topBound.y - 1*8,GameAssets.PERSON_STANDING_PNG,null,bastard,WANDER,null);
		o1.changeMood(ANGRY);
		o1.active = true;
		o1.kind = UNKNOWN;

		var o2:MovieStar = new MovieStar(screenLeft.x + 2*8,topBound.y + 5*8,GameAssets.PERSON_STANDING_PNG,null,o1,WANDER,null);
		o2.changeMood(ANGRY);
		o2.active = true;
		o2.kind = UNKNOWN;

		var o3:MovieStar = new MovieStar(screenRight.x - o1.width - 2*8,topBound.y + 5*8,GameAssets.PERSON_STANDING_PNG,null,o2,WANDER,null);
		o3.changeMood(ANGRY);
		o3.active = true;
		o3.kind = UNKNOWN;

		var o4:MovieStar = new MovieStar(screenRight.x - o1.width - 6*8,topBound.y - 1*8,GameAssets.PERSON_STANDING_PNG,null,o3,WANDER,null);
		o4.changeMood(ANGRY);
		o4.active = true;
		o4.kind = UNKNOWN;

		var c1:Chair = new Chair(32*8,10*8,FlxObject.RIGHT);
		c1.recolour(true);
		var t:Table = new Table(c1.x + c1.width,c1.y + 1*8);
		var c2:Chair = new Chair(t.x + t.width,10*8,FlxObject.LEFT);

		var o5:MovieStar = new MovieStar(c1.x,c1.y - 10,GameAssets.PERSON_STANDING_PNG,null,o4,WANDER,c1);
		c1.addOccupant(o5);

		movieStars.add(o1);
		movieStars.add(o2);
		movieStars.add(o3);
		movieStars.add(o4);
		movieStars.add(o5);

		screenGroup.add(o1);
		screenGroup.add(o2);
		screenGroup.add(o3);
		screenGroup.add(o4);
		screenGroup.add(o5);
		screenGroup.add(c1);
		screenGroup.add(t);
		screenGroup.add(c2);
		screenGroup.add(screenSprite);
		
		bg.add(screenGroup);

		movieTimer = new FlxTimer();
		movieTimer.start(Math.random() * 3 + 3,changeMovieStarTargets);

	}


	private function changeMovieStarTargets(t:FlxTimer):Void
	{
		for (i in 0...movieStars.members.length)
		{
			var s:MovieStar = cast(movieStars.members[i]);
			if (s != null && s.active)
			{
				var o:MovieStar = s;
				while (o == s) o = cast(movieStars.getRandom(),MovieStar);

				if (o.mood != KNOCKED_DOWN) 
				{
					s.changeTarget(o);
				}
				else 
				{
					s.changeTarget(null);
					s.changeMood(NORMAL);
					s.changeMode(WANDER);
				}

				if (Math.random() > 0.25) s.changeMood(ANGRY);
			}

		}

		movieTimer.start(Math.random() * 3 + 3,changeMovieStarTargets);
	}


	private function createSeats():Void
	{
		createSeat(2*8,26*8);
		createSeat(10*8,26*8);
		createSeat(18*8,26*8);
		createBastardSeat(26*8,26*8);

		createSeat(2*8,37*8);
		createSeat(10*8,37*8);
		createSeat(18*8,37*8);
		createSeat(26*8,37*8);

		createSeat(2*8,48*8);
		createSeat(10*8,48*8);
		createSeat(18*8,48*8);
		createSeat(26*8,48*8);

		createSeat(47*8,26*8);
		createSeat(55*8,26*8);
		createSeat(63*8,26*8);
		createSeat(71*8,26*8);

		createSeat(47*8,37*8);
		createSeat(55*8,37*8);
		createSeat(63*8,37*8);
		createSeat(71*8,37*8);

		createSeat(47*8,48*8);
		createSeat(55*8,48*8);
		createSeat(63*8,48*8);
		createSeat(71*8,48*8);
	}


	private function createSeat(X:Float,Y:Float):Void
	{
		var seat:CinemaSeat = new CinemaSeat(X,Y,FlxObject.RIGHT);

		display.add(seat);
		furniture.add(seat);

		var v:Other = new Other(X,Y - 10,GameAssets.PERSON_STANDING_PNG,null,bastard,STILL,seat);

		seat.addOccupant(v);

		display.add(v);
		others.add(v);
	}


	private function createBastardSeat(X:Float,Y:Float):Void
	{
		bastardSeat = new CinemaSeat(X,Y,FlxObject.RIGHT);

		display.add(bastardSeat);
		furniture.add(bastardSeat);

		seatTrigger = new FlxSprite(bastardSeat.hit.x,bastardSeat.hit.y - 20);
		seatTrigger.makeGraphic(Std.int(bastardSeat.width),20,0xFFFF0000);
		seatTrigger.x = bastardSeat.hit.x;
		seatTrigger.y = bastardSeat.hit.y - 20;
		// add(seatTrigger);		
	}


	override public function destroy():Void
	{
		super.destroy();

		display.destroy();
	}


	override public function update():Void
	{
		super.update();

		screenGroup.sort();

		switch (state)
		{
			case FADE_IN:

			case TITLE:

			case PLAY:
			handleScreen();
			handleViewing();

			case ARRESTED:

			case EXITING:

			case STATS:

			case COMPLETE:

			case FADE_OUT:
		}

		display.sort("depth");
	}


	private function handleScreen():Void
	{

	}


	private function handleViewing():Void
	{
		seatTrigger.x = bastardSeat.hit.x;
		seatTrigger.y = bastardSeat.hit.y - 20;

		if (viewingComplete) return;


		if (seatTimer.finished && bastard.hit.overlaps(seatTrigger) && !viewingComplete)
		{
			seatTimer.start(1,1,startViewing);
		}
		else if (!bastard.hit.overlaps(seatTrigger))
		{
			seatTimer.stop();
			seatTimer.finished = true;
		}

		if (viewing)
		{
			viewingTime++;
			if (viewingTime >= CINEMA_UNIT_AMOUNT)
			{
				seatTimer.stop();
				seatTimer.finished = true;
				viewingComplete = true;
				showSuccessText(null);
			}
		}
	}


	private function startViewing(t:FlxTimer):Void
	{
		viewing = true;
	}



	// SCORE //

	override private function showStats():Void
	{
		super.showStats();

		if (viewingComplete && SceneState.score.currentJostleStrength() < 5)
		{
			statsRatingText.setText("A");
			statsRankText.setText("MOVIE LOVER");
		}
		else if (viewingComplete && SceneState.score.currentJostleStrength() < 20)
		{
			statsRatingText.setText("A");
			statsRankText.setText("RUSTLER");
		}
		else if (viewingComplete && SceneState.score.currentJostleStrength() >= 20)
		{
			statsRatingText.setText("B");
			statsRankText.setText("MOVIE SPOILER");
		}	
		else if (!viewingComplete && SceneState.score.currentJostleStrength() < 10)
		{
			statsRatingText.setText("B");
			statsRankText.setText("PHILISTINE");
		}
		
	}


	override private function addBonuses():Void
	{
		if (SceneState.score.currentJostleStrength() > 500)
		{
			addToBonus("+ MEDIA EFFECTS CASE STUDY");
		}
		super.addBonuses();
	}
}






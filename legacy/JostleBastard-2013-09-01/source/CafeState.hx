
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.FlxTimer;

import org.flixel.plugin.photonstorm.FlxCollision;

import nme.display.Sprite;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;



class CafeState extends SettingState
{				
	private var UP_ALLEY_X:Float = 220;
	private var COUNTER_Y:Float;
	private var COUNTER_X:Float;
	private var DOWN_ALLEY_X:Float = 450;

	public static var customerPath:Array<Float>;
	
	public static var customers:FlxGroup;
	private var walls:FlxGroup;
	private var door:Wall;

	private var chairs:FlxGroup;

	private var queuerTimer:FlxTimer;

	private var chairInMotion:Chair = null;

	private var p:Other;

	override public function create():Void
	{
		super.create();

		chairs = new FlxGroup();
		customers = new FlxGroup();
		walls = new FlxGroup();

		createWalls();
		createTables();
		createCounter();
		createPath();
		
		SettingState.bastard = new Bastard(200,200);
		display.add(SettingState.bastard);

		queuerTimer = new FlxTimer();
		queuerTimer.start(Math.random() * 5 + 2,1,sendToCounter);

		// p = new CafeCustomer(300,300,Assets.PERSON_STANDING_PNG,null);
		// display.add(p);

		recolour();
	}


	override private function settingFinished(t:FlxTimer):Void
	{
		super.settingFinished(t);

		door.kill();
		Physics.WORLD.destroyBody(door.body);
	}


	private function sendToCounter(t:FlxTimer):Void
	{
		chairInMotion = cast(chairs.getRandom(),Chair);
		while (!chairInMotion.occupied)
		{
			chairInMotion = cast(chairs.getRandom(),Chair);
		}
		chairInMotion.goToCounter();
	}


	private function createWalls():Void
	{
		var topWall:Wall = new Wall(0,0,Assets.WALL_TOP_PNG);
		display.add(topWall);

		var topBound:PhysicsSprite = new PhysicsSprite(10,60,Assets.WALL_TOP_PNG,1,1000,false);

		var leftWall:Wall = new Wall(0,10,Assets.WALL_SIDE_PNG);
		display.add(leftWall);

		var rightWall:Wall = new Wall(FlxG.width - 10,10,Assets.WALL_SIDE_PNG);
		display.add(rightWall);

		var bottomWallLeft:Wall = new Wall(0,FlxG.height - 10,Assets.CAFE_WALL_BOTTOM_PNG);
		display.add(bottomWallLeft);

		door = new Wall(bottomWallLeft.width,FlxG.height - 10,Assets.CAFE_DOOR_PNG);
		display.add(door);

		var bottomWallRight:Wall = new Wall(bottomWallLeft.width + door.width,FlxG.height - 10,Assets.CAFE_WALL_BOTTOM_PNG);
		display.add(bottomWallRight);
	}


	private function createTables():Void
	{
		var hMargin:Float = 40;
		var hSpacing:Float = (FlxG.width - hMargin*2)/2.5;

		var vMargin:Float = 200;
		var vSpacing:Float = (FlxG.height - vMargin)/3;

		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 0*hSpacing,vMargin + 2*vSpacing);
		addTableAndChairs(hMargin + 1*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 1*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 0*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 1*vSpacing);
		addTableAndChairs(hMargin + 2*hSpacing,vMargin + 2*vSpacing);
	}


	private function createCounter():Void
	{
		var counter:Wall = new Wall(0,80,Assets.CAFE_COUNTER_PNG);

		display.add(counter);

		COUNTER_Y = counter.y + counter.height + 30;
		COUNTER_X = counter.x + counter.width - 100;
	}


	private function createPath():Void
	{
		customerPath = new Array();
		customerPath.push(UP_ALLEY_X);
		customerPath.push(COUNTER_Y);
		customerPath.push(COUNTER_X);
		customerPath.push(DOWN_ALLEY_X);
	}


	private function addTableAndChairs(X:Float, Y:Float):Void
	{
		var leftChair:Chair = new Chair(X,Y,display,FlxObject.RIGHT);
		var table:Table = new Table(X + leftChair.width + 1,Y);
		var rightChair:Chair = new Chair(X + leftChair.width + table.width + 2,Y,display,FlxObject.LEFT);

		display.add(table);

		display.add(leftChair);
		chairs.add(leftChair);

		display.add(rightChair);
		chairs.add(rightChair);
	}
	

	override public function destroy():Void
	{
		super.destroy();

		display.destroy();
	}


	override public function update():Void
	{
		super.update();

		checkQueuer();


		display.sort("depth");
	}


	private function checkQueuer():Void
	{
		if (chairInMotion != null)
		{
			if (chairInMotion.occupied)
			{
				queuerTimer.start(Math.random() * 5 + 2,1,sendToCounter);
				chairInMotion = null;
			}
		}
	}
}
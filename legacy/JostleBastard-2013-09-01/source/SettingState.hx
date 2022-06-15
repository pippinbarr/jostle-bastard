
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.FlxTimer;
import org.flixel.FlxText;
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


class SettingState extends FlxState
{				
	public static var COLOUR_SET:Int = 1;
	public static var RECOLOUR_TIME:Float = 10;
	
	private var colourTimer:FlxTimer;

	public static var bastard:Bastard;

	public var display:FlxGroup;

	private var timerText:FlxText;
	private var settingTimer:FlxTimer;


	override public function create():Void
	{
		super.create();

		display = new FlxGroup();
		add(display);

		setupPhysics();

		settingTimer = new FlxTimer();
		settingTimer.start(300,1,settingFinished);


		timerText = new FlxText(10,10,FlxG.width - 20,"",12,true);
		timerText.setFormat("Commodore",48,0xFF000000,"right");
		add(timerText);

		timerText.text = "" + Std.int(settingTimer.timeLeft);
	}


	private function settingFinished(t:FlxTimer):Void
	{
		
	}


	private function setupPhysics():Void
	{
		Physics.DEBUG_SPRITE = new Sprite();
		FlxG.stage.addChild(Physics.DEBUG_SPRITE);

		Physics.WORLD = new B2World (new B2Vec2 (0,0), true);
		Physics.DEBUG = new B2DebugDraw ();

		var contactListener:JostleContactListener = new JostleContactListener();
		Physics.WORLD.setContactListener(contactListener);

		Physics.DEBUG.setSprite(Physics.DEBUG_SPRITE);
		Physics.DEBUG.setDrawScale(1/Physics.SCALE);
		Physics.DEBUG.setFlags(B2DebugDraw.e_shapeBit);
		Physics.DEBUG_SPRITE.visible = true;

		Physics.WORLD.setDebugDraw(Physics.DEBUG);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		timerText.text = "" + Std.int(settingTimer.timeLeft);

		Physics.WORLD.step(1 / 30, 20, 20);
		Physics.WORLD.clearForces();

		if (Physics.DRAW_DEBUG)
		{
			Physics.WORLD.drawDebugData();
		}
	}


	public function recolour():Void
	{
		COLOUR_SET = Math.floor(Math.random() * Assets.BG_COLOURS.length);

		FlxG.bgColor = Assets.BG_COLOURS[COLOUR_SET];
		display.callAll("recolour");
	}
}
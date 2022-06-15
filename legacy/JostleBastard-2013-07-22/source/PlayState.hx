package;


import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxCollision;


class PlayState extends FlxState
{				
	private var NUM_ENEMIES:Int = 0;

	private var avatar:Jostler;
	private var enemy:Enemy;
	private var enemies:Array<Enemy>;

	private var collidables:Array<FlxSprite>;
	private var cafeWalls:FlxSprite;

	private var displayGroup:FlxGroup;

	override public function create():Void
	{
		super.create();

		FlxG.bgColor = 0xFFDDDDDD;


		displayGroup = new FlxGroup();

		avatar = new Jostler(320,480);

		enemies = new Array();
		for (i in 0...NUM_ENEMIES)
		{
			enemies.push(new Enemy(Math.random()*FlxG.width,Math.random()*FlxG.height));
			add(enemies[i]);
		}

		displayGroup.add(avatar);

		collidables = new Array();
		var cafeWallsHit:FlxSprite = new FlxSprite(0,0);
		cafeWallsHit.loadGraphic(Assets.CAFE_WALLS_HIT_PNG);
		cafeWallsHit.visible = true;
		add(cafeWallsHit);
		collidables.push(cafeWallsHit);

		cafeWalls = new FlxSprite(0,0);
		cafeWalls.loadGraphic(Assets.CAFE_WALLS_PNG);
		cafeWalls.visible = false;
		displayGroup.add(cafeWalls);

		var cafeCounterHit:FlxSprite = new FlxSprite(8,80);
		cafeCounterHit.loadGraphic(Assets.CAFE_COUNTER_HIT_PNG);
		cafeCounterHit.visible = true;
		add(cafeCounterHit);
		collidables.push(cafeCounterHit);

		var cafeCounter:FlxSprite = new FlxSprite(8,80);
		cafeCounter.loadGraphic(Assets.CAFE_COUNTER_PNG);
		cafeCounter.visible = false;
		displayGroup.add(cafeCounter);

		var table1Hit:FlxSprite = new FlxSprite(48,144);
		table1Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table1Hit);
		collidables.push(table1Hit);

		var table2Hit:FlxSprite = new FlxSprite(48,256);
		table2Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table2Hit);
		collidables.push(table2Hit);

		var table3Hit:FlxSprite = new FlxSprite(48,368);
		table3Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table3Hit);
		collidables.push(table3Hit);

		var table4Hit:FlxSprite = new FlxSprite(264,144);
		table4Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table4Hit);
		collidables.push(table4Hit);

		var table5Hit:FlxSprite = new FlxSprite(264,256);
		table5Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table5Hit);
		collidables.push(table5Hit);

		var table6Hit:FlxSprite = new FlxSprite(480,144);
		table6Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table6Hit);
		collidables.push(table6Hit);

		var table7Hit:FlxSprite = new FlxSprite(480,256);
		table7Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table7Hit);
		collidables.push(table7Hit);

		var table8Hit:FlxSprite = new FlxSprite(480,368);
		table8Hit.loadGraphic(Assets.CAFE_TABLE_AND_CHAIRS_HIT_PNG);
		add(table8Hit);
		collidables.push(table8Hit);

		add(displayGroup);
	}		


	override public function destroy():Void
	{
		avatar.destroy();
		
		for (i in 0...enemies.length)
		{
			enemies[i].destroy();
		}

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		handleCollisions();

		displayGroup.sort("y");
	}


	private function handleCollisions():Void
	{
		for (i in 0...collidables.length)
		{
			if (FlxCollision.pixelPerfectCheck(avatar.hit,collidables[i]))
			{
				avatar.undoAndStop();
			}
		}
	}



	private function collision(P1:Person, P2:Person):Void
	{			
		while(FlxCollision.pixelPerfectCheck(P1.hit,P2.hit))
		{
			if (Math.abs(P1.x - P2.x) >= Math.abs(P1.y - P2.y) && P1.vy == 0 && P2.vy == 0)
			{					
				if (P1.x < P2.x)
				{
					P1.x -= 10;
					P2.x += 10;
				}
				else
				{
					P1.x += 10;
					P2.x -= 10;
				}
			}
			else
			{
				if (P1.y < P2.y)
				{
					P1.y -= 10;
					P2.y += 10;
				}
				else
				{
					P1.y += 10;
					P2.y -= 10;
				}
			}
		}
	}
}

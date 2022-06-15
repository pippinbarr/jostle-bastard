package;


import org.flixel.FlxSprite;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2ContactImpulse;


class Cell extends FlxSprite
{
	public static var recoloured:Bool = false;
	private var doorSprite:PhysicsSprite;

	private var depth:Float;


	public function new (X:Int,Y:Int):Void
	{
		super(X,Y,GameAssets.CELL_CLOSED_PNG);
		loadGraphic(GameAssets.CELL_CLOSED_PNG,false,false,0,0,true);

		doorSprite = new PhysicsSprite(X + 48,Y + 176 - 8,"",1,1,1000,false,false,15*8,8,0x00000000);
		doorSprite.kind = WALL;

		var topSprite:PhysicsSprite = new PhysicsSprite(X,Y,"",1,1,1000,false,false,Std.int(this.width),8,0x00000000);
		topSprite.kind = WALL;

		var leftSprite:PhysicsSprite = new PhysicsSprite(X,Y + 8,"",1,1,1000,false,false,Std.int(8),Std.int(this.height - 8),0x00000000);
		leftSprite.kind = WALL;

		var rightSprite:PhysicsSprite = new PhysicsSprite(X + this.width - 8,Y + 8,"",1,1,1000,false,false,Std.int(8),Std.int(this.height - 8),0x00000000);
		rightSprite.kind = WALL;

		var bottomLeftSprite:PhysicsSprite = new PhysicsSprite(X + 8,Y + this.height - 8,"",1,1,1000,false,false,Std.int((this.width - doorSprite.width)/2),Std.int(8),0x00000000);
		bottomLeftSprite.kind = WALL;

		var bottomRightSprite:PhysicsSprite = new PhysicsSprite(doorSprite.x + doorSprite.width,Y + this.height - 8,"",1,1,1000,false,false,Std.int(bottomLeftSprite.width),Std.int(8),0x00000000);
		bottomRightSprite.kind = WALL;

		var topBoundSprite:PhysicsSprite = new PhysicsSprite(X + 8,Y + 64,"",1,1,1000,false,false,Std.int(this.width - 16),8,0x00000000);

		depth = doorSprite.hit.y;

		recolour();
	}


	public function open():Void
	{
		doorSprite.visible = false;
		Physics.WORLD.destroyBody(doorSprite.body);
		this.loadGraphic(GameAssets.CELL_OPEN_PNG,false,false,0,0,true);
		Cell.recoloured = false;
		recolour();
	}


	public function beginContact(Sensor:Int,OtherSensor:Int,Other:PhysicsSprite):Void
	{

	}


	public function endContact(Sensor:Int,OtherSensor:Int,Other:PhysicsSprite):Void
	{

	}


	private function hitByBastard():Void
	{

	}


	public function postSolve(OtherSprite:PhysicsSprite, impulse:B2ContactImpulse):Void
	{

	}


	public function updatePosition():Void
	{
		
	}


	public function recolour():Void
	{
		replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
		replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
		replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
		replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
		replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);
		calcFrame();
	}


	// public function recolour():Void
	// {
	// 	if (!Cell.recoloured)
	// 	{
	// 		replaceColor(GameAssets.BASTARD,GameAssets.BASTARD_REPLACEMENT);
	// 		replaceColor(GameAssets.OTHER,GameAssets.OTHER_REPLACEMENT);
	// 		replaceColor(GameAssets.FURNITURE,GameAssets.FURNITURE_REPLACEMENT);
	// 		replaceColor(GameAssets.WALL,GameAssets.WALL_REPLACEMENT);
	// 		replaceColor(GameAssets.HIGHLIGHT,GameAssets.HIGHLIGHT_REPLACEMENT);
	// 		calcFrame();

	// 		Cell.recoloured = true;
	// 	}
	// }

}
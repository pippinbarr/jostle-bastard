package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.dynamics.B2Body;


class Table extends PhysicsSprite
{
	public static var recoloured:Bool = false;
	public static var fColour:Int = GameAssets.FURNITURE;

	public function new(X:Float,Y:Float)
	{
		super(X,Y,GameAssets.TABLE_PNG,0.25,1,1,true);

		kind = FURNITURE;

		recolour();
	}


	override public function destroy():Void
	{
		Table.recoloured = false;

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	override private function hitByBastard():Void
	{

	}

	override public function recolour(Force:Bool = false):Void
	{
		if (!Table.recoloured || Force)
		{
			currentF = fColour;

			super.recolour();
			calcFrame();
			Table.recoloured = true;

			fColour = GameAssets.FURNITURE_REPLACEMENT;
		}
	}

}
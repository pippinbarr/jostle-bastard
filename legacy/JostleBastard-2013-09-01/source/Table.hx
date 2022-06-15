package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.dynamics.B2Body;


class Table extends PhysicsSprite
{

	public function new(X:Float,Y:Float)
	{
		super(X,Y,Assets.TABLE_PNG,4,1,true);
	}


	override public function recolour():Void
	{

		replaceColor(Assets.FURNITURE_COLOUR,Assets.FURNITURE_COLOURS[SettingState.COLOUR_SET]);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	override private function hitByBastard():Void
	{

	}
}
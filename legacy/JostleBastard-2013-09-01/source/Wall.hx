package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;


class Wall extends PhysicsSprite
{

	public function new(X:Float,Y:Float,S:String,F:UInt = FlxObject.RIGHT)
	{
		super(X,Y,S,1,1000);
	}


	override public function recolour():Void
	{
		replaceColor(Assets.FURNITURE_COLOUR,Assets.HIGHLIGHT_COLOURS[SettingState.COLOUR_SET]);
		replaceColor(Assets.HIGHLIGHT_COLOUR,Assets.FURNITURE_COLOURS[SettingState.COLOUR_SET]);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}
}

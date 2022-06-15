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

	// public function new(X:Float,Y:Float,S:String,F:UInt = FlxObject.RIGHT)
	public function new(X:Float,Y:Float,W:Int,H:Int)
	{
		super(X,Y,"",1,1,1000,false,false,W,H,GameAssets.WALL_REPLACEMENT);

		kind = WALL;
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

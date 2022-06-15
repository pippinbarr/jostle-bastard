package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxPoint;

class CafeRoom extends FlxGroup
{

	public function new()
	{
		super();

		makeWalls();

		var hMargin:Float = 130;
		var hSpacing:Float = (FlxG.width - hMargin*2)/2;

		var vMargin:Float = 200;
		var vSpacing:Float = (FlxG.height - vMargin)/3;


		var table1:CafeTable = new CafeTable(hMargin + 0*hSpacing,vMargin + 0*vSpacing);
		add(table1);

		var table2:CafeTable = new CafeTable(hMargin + 0*hSpacing,vMargin + 1*vSpacing);
		add(table2);

		var table3:CafeTable = new CafeTable(hMargin + 0*hSpacing,vMargin + 2*vSpacing);
		add(table3);

		var table4:CafeTable = new CafeTable(hMargin + 1*hSpacing,vMargin + 0);
		add(table4);

		var table5:CafeTable = new CafeTable(hMargin + 1*hSpacing,vMargin + 1*vSpacing);
		add(table5);

		var table6:CafeTable = new CafeTable(hMargin + 2*hSpacing,vMargin + 0);
		add(table6);

		var table7:CafeTable = new CafeTable(hMargin + 2*hSpacing,vMargin + 1*vSpacing);
		add(table7);

		var table8:CafeTable = new CafeTable(hMargin + 2*hSpacing,vMargin + 2*vSpacing);
		add(table8);
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}


	private function makeWalls():Void
	{
		var leftWall:FlxSprite = new FlxSprite(0,0);
		leftWall.makeGraphic(10,FlxG.height,0xFF000000);
		Physics.createBodyFromSpriteBoundingBox(leftWall,false);
		add(leftWall);

		var rightWall:FlxSprite = new FlxSprite(FlxG.width - 10,0);
		rightWall.makeGraphic(10,FlxG.height,0xFF000000);
		Physics.createBodyFromSpriteBoundingBox(rightWall,false);
		add(rightWall);

		var topWall:FlxSprite = new FlxSprite(0,0);
		topWall.makeGraphic(FlxG.width,10,0xFF000000);
		Physics.createBodyFromSpriteBoundingBox(topWall,false);
		add(topWall);

		var bottomWall:FlxSprite = new FlxSprite(0,FlxG.height - 10);
		bottomWall.makeGraphic(FlxG.width,FlxG.height - 10,0xFF000000);
		Physics.createBodyFromSpriteBoundingBox(bottomWall,false);
		add(bottomWall);
	}
}
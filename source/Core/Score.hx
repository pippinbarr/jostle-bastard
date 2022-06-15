package;

import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;

class Score
{
	public var justJostled:Bool = false;


	private static var COP_CHECK_INTERVAL:Float = 2;
	private static var ARREST_THRESHOLD:Float = 60;

	// TRACKED DURING PLAY
	public var b_into_f:Int = 0;
	public var b_into_w:Int = 0;
	public var b_into_t:Int = 0;

	public var o_into_o:Int = 0;
	public var o_into_k:Int = 0;
	public var o_into_c:Int = 0;
	public var o_into_w:Int = 0;
	public var o_into_f:Int = 0;
	public var o_into_t:Int = 0;

	public var o_by_o:Int = 0;
	public var o_by_k:Int = 0;
	public var o_by_c:Int = 0;
	public var o_by_f:Int = 0;
	public var o_by_t:Int = 0;
	public var o_by_tr:Int = 0;
	public var o_by_b:Int = 0;

	public var k_into_o:Int = 0;
	public var k_into_k:Int = 0;
	public var k_into_c:Int = 0;
	public var k_into_w:Int = 0;
	public var k_into_f:Int = 0;
	public var k_into_t:Int = 0;

	public var k_by_o:Int = 0;
	public var k_by_k:Int = 0;
	public var k_by_c:Int = 0;
	public var k_by_f:Int = 0;
	public var k_by_t:Int = 0;
	public var k_by_b:Int = 0;

	public var c_by_b:Int = 0;
	public var b_by_c:Int = 0;

	public var ko:Int = 0;
	
	public var angered:Int = 0;
	public var annoyed:Int = 0;
	public var scared:Int = 0;

	// CALCULATED AFTER PLAY
	private var direct:Int = 0;
	private var riccochet:Int = 0;
	private var bounce:Int = 0;
	public var other:Int = 0;
	public var kid:Int = 0;
	public var people:Int = 0;
	public var cops:Int = 0;
	public var trash:Int = 0;
	private var furniture:Int = 0;

	private var directPercentage:Float = 0;
	private var riccochetPercentage:Float = 0;
	private var koPercentage:Float = 0;
	private var furniturePercentage:Float = 0;
	private var treePercentage:Float = 0;
	private var peoplePercentage:Float = 0;


	private var copTimer:FlxTimer;
	private var arrested:Bool = false;

	private var sceneTimer:FlxTimer;

	public function new():Void
	{
		copTimer = new FlxTimer();
		copTimer.start(COP_CHECK_INTERVAL,1,checkArrestThreshold);

		sceneTimer = new FlxTimer();
		sceneTimer.start(5,1);
	}

	public function traceStats():Void
	{
		trace("b_into_f: " + b_into_f);
		trace("b_into_w: " + b_into_w);
		trace("b_into_t: " + b_into_t);

		trace("o_into_o: " + o_into_o);
		trace("o_into_c: " + o_into_c);
		trace("o_into_w " + o_into_w);
		trace("o_into_f: " + o_into_f);
		trace("o_into_t: " + o_into_t);
		trace("b->f: " + b_into_f);

		trace("o_by_o: " + o_by_o);
		trace("o_by_c: " + o_by_c);
		trace("o_by_f: " + o_by_f);
		trace("o_by_t: " + o_by_t);
		trace("o_by_t: " + o_by_t);

		trace("c_by_b: " + c_by_b);
		trace("b_by_c: " + b_by_c);

		trace("ko: " + ko);
	}

	public function bastardArrested():Bool
	{
		return arrested;
	}


	private function checkArrestThreshold(t:FlxTimer):Void
	{
		// trace("Arrest threshold checking: " + b_by_c);

		if (b_by_c > ARREST_THRESHOLD)
		{
			arrested = true;
		}
		else
		{
			b_by_c = 0;
			copTimer.start(COP_CHECK_INTERVAL,1,checkArrestThreshold);
		}
	}


	public function currentJostleStrength():Int
	{
		return (
			ko + 
			o_into_o + o_into_c + o_into_f + o_into_t  + o_into_w + 
			o_by_o + o_by_c + o_by_f + o_by_t + o_by_tr + o_by_b + 
			k_into_o + k_into_c + k_into_f + k_into_t + k_into_w + 
			k_by_o + k_by_c + k_by_f + k_by_t + k_by_b + 
			b_into_f + b_into_t + b_into_w);
	}

	public function currentPeopleJostleStrength():Int
	{
		return (
			ko + 
			o_into_o + o_into_c + o_into_f + o_into_t  + o_into_w + 
			o_by_o + o_by_c + o_by_f + o_by_t + o_by_tr + o_by_b + 
			k_into_o + k_into_c + k_into_f + k_into_t + k_into_w + 
			k_by_o + k_by_c + k_by_f + k_by_t + k_by_b);
	}


	public function currentCopJostleStrength():Int
	{
		return (c_by_b + b_by_c);
	}


	public function calculateStats(othersGroup:FlxGroup,furnitureGroup:FlxGroup,treesGroup:FlxGroup):Void
	{
		riccochet = o_by_f + o_by_o + o_by_k + o_by_t + o_by_tr + k_by_f + k_by_k + k_by_o + k_by_t;
		direct = o_by_b + k_by_b;
		bounce = o_into_w + o_into_o + o_into_c + o_into_f + o_into_t + k_into_w + k_into_o + k_into_c + k_into_f + k_into_t;
		other = o_into_w + o_into_f + o_into_o + o_into_k + o_into_c + o_into_t + o_by_f + o_by_o + o_by_k + o_by_c + o_by_t + o_by_tr + o_by_b;
		kid = k_into_w + k_into_f + k_into_o + k_into_k + k_into_c + k_into_t + k_by_f + k_by_o + k_by_k + k_by_c + k_by_t + k_by_b;
		people = other + kid;
		cops = c_by_b;

		directPercentage = Std.int(direct / (riccochet + direct) * 100);
		riccochetPercentage = Std.int(riccochet / (riccochet + direct) * 100);


		koPercentage = Std.int((ko / other) * 100);

		furniture = b_into_f;

		var distinctFurniture:Int = 0;
		for (i in 0...furnitureGroup.members.length)
		{
			var item:PhysicsSprite = cast(furnitureGroup.members[i],PhysicsSprite);

			if (item == null || !item.alive) continue;

			if (item.jostled) distinctFurniture++;
		}

		furniturePercentage = Std.int(distinctFurniture / furnitureGroup.length * 100);


		var distinctTrees:Int = 0;
		for (i in 0...treesGroup.members.length)
		{
			var item:PhysicsSprite = cast(treesGroup.members[i],PhysicsSprite);

			if (item == null || !item.alive) continue;

			if (item.jostled) distinctTrees++;
		}

		treePercentage = Std.int(distinctTrees / treesGroup.length * 100);


		var distinctPeople:Int = 0;
		for (i in 0...othersGroup.members.length)
		{
			var item:PhysicsSprite = cast(othersGroup.members[i],PhysicsSprite);

			if (item == null || !item.alive) continue;

			if (item.jostled) distinctPeople++;
		}

		peoplePercentage = Std.int(distinctPeople / othersGroup.length * 100);

		// trace("COUNTS\n======");
		// trace("Riccochet jostles: " + riccochetJostles);
		// trace("Direct jostles: " + directJostles);
		// trace("Bounce jostles: " + bounceJostles);
		// trace("Total other jostles: " + totalOtherJostles);
		// trace("Total furniture jostles: " + totalFurnitureJostles);
		// trace("Knockdowns: " + knockDowns);

		// trace("PERCENTAGES\n===========");
		// trace("Riccochet percentage: " + riccochetJostlePercentage);
		// trace("Direct hit percentage: " + directJostlePercentage);
		// trace("Knockdown percentage: " + knockDownPercentage);
		// trace("Furniture percentage: " + furnitureJostlePercentage);
		// trace("Customer percentage: " + customerJostlePercentage);

		// trace("People: " + people);
	}


	public function getRank():String
	{
		var rank:String = "XXX";

		if (currentJostleStrength() < 5) 
		{
			rank = "L";
		}
		else
		{
			// trace(currentJostleStrength());
			var jostleRank:Int = Std.int(Math.min(currentJostleStrength() / 200,15));
			rank = "B";
			for (i in 0...jostleRank)
			{
				rank += "B";
			}

		}		
		return rank;
	}


	public function getTitle():String
	{
		var title:String = "";

		if (currentPeopleJostleStrength() < 5 && currentJostleStrength() < 20 && sceneTimer.finished) 
		{
			title = "LOITERER";
		}
		else if (currentPeopleJostleStrength() < 5 && !sceneTimer.finished)
		{
			title = "PREMATURE EJECTOR";
		}
		else if (!sceneTimer.finished)
		{
			title = "SPEEDY BASTARD";
		}
		else
		{
			title = "BASTARD";
		}

		return title;
	}
}
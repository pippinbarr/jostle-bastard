package;


import org.flixel.util.FlxPoint;



class Helpers
{
	public static function randomSort(X:Dynamic,Y:Dynamic):Int
	{
		var r:Float = Math.random();
		if (r < 0.33) return 1;
		else if (r < 0.66) return 0;
		else return -1;
	}


	public static function getDistance(P1:FlxPoint,P2:FlxPoint):Float
	{
		return (Math.sqrt(Math.pow(P1.x - P2.x,2) + Math.pow(P1.y - P2.y,2)));
	}


	public static function dateToString(D:Date):String
	{
		var dateString:String = "";
		switch (D.getMonth())
		{
			case 0: dateString += "JANUARY";
			case 1: dateString += "FEBRUARY";
			case 2: dateString += "MARCH";
			case 3: dateString += "APRIL";
			case 4: dateString += "MAY";
			case 5: dateString += "JUNE";
			case 6: dateString += "JULY";
			case 7: dateString += "AUGUST";
			case 8: dateString += "SEPTEMBER";
			case 9: dateString += "OCTOBER";
			case 10: dateString += "NOVEMBER";
			case 11: dateString += "DECEMBER";
		}
		dateString += " ";
		dateString += D.getDate() + ", ";
		dateString += D.getFullYear();

		return dateString;
	}
}
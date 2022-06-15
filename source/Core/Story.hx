package;

import org.flixel.FlxState;


class Story
{
	public static var date:Date;

	public static var hasJob:Bool = true;
	public static var hasHome:Bool = true;

	private static var arrests:Int = 0;

	private static var jailTime:Int = 0;
	private static var apartmentWarningLevel:Int = 0;
	private static var jobWarningLevel:Int = 0;

	public static var thisScene:JostleEnums.SceneType = ALLEY;
	public static var nextScene:JostleEnums.SceneType;

	private static var home:JostleEnums.SceneType = APARTMENT;
	private static var job:JostleEnums.SceneType = CLASSROOM;
	private static var nextSceneIndex:Int = 0;

	private static var avengerProbability:Float = 0.0;

	public static var firstClassroom:Bool = true;
	public static var firstOffice:Bool = true;
	public static var firstFoodcourt:Bool = true;

	public static var days:Int = 25;

	// SETUP //

	public static function setupDate():Void
	{
		date = new Date(1989,3,days,12,00,00);
	}

	public static function setupScene():Void
	{
		switch (thisScene)
		{
			case ALLEY,JAIL:
			nextScene = home;

			case APARTMENT,ALLEYHOME:
			days++;
			setupDate();
			nextScene = getHomeNextDestination();			

			case CAFE,RESTAURANT,BAR,PARK,STORE,PHARMACY,BOOKSTORE,GYM,DISCO,CINEMA,CHURCH:
			if (Math.random() > 0.33)
			{
				nextScene = getNextDestination();
			}
			else
			{
				nextScene = home;		
			}

			case CLASSROOM,OFFICE,FOODCOURT:
			nextScene = getNextDestination();			
		}

		// trace("Story.setupScene()");
		// trace("thisScene = " + thisScene);
		// trace("nextScene = " + nextScene);
	}



	// JOB //

	public static function getJobWarning():Int
	{
		jobWarningLevel++;
		return jobWarningLevel;
	}

	public static function fired():Void
	{
		if (job == CLASSROOM) job = OFFICE;
		else if (job == OFFICE) job = FOODCOURT;
		else hasJob = false;
		
		jobWarningLevel = 0;
	}


	// COPS //

	public static function sendCopsImmediately():Bool
	{
		// Basically check whether this establishment has called the cops before
		// If so then they will consider sending them again

		switch (thisScene)
		{
			case ALLEY,ALLEYHOME,APARTMENT,CLASSROOM,OFFICE,FOODCOURT,JAIL:
			return false;

			case CAFE:
			return Texts.CAFES[0][2] != "";

			case RESTAURANT:
			return Texts.RESTAURANTS[0][2] != "";

			case BAR:
			return Texts.BARS[0][2] != "";

			case STORE:
			return Texts.STORES[0][2] != "";

			case BOOKSTORE:
			return Texts.BOOKSTORES[0][2] != "";

			case PHARMACY:
			return Texts.PHARMACIES[0][2] != "";

			case GYM:
			return Texts.GYMS[0][2] != "";

			case DISCO:
			return Texts.DISCOS[0][2] != "";

			case PARK:
			return Texts.PARKS[0][2] != "" && Math.random() > 0.5;

			case CINEMA:
			return Texts.CINEMAS[0][2] != "";

			case CHURCH:
			return Texts.CHURCHES[0][2] != "";
		}		
	}


	public static function sendCopThreshold():Float
	{
		return Math.max(150 - arrests,100);
	}


	public static function timeToSendCops():Float
	{
		return Math.max(15 - arrests,5);
	}


	public static function numCopsToSend():Int
	{
		// First update the fact the cops were called

		switch (thisScene)
		{
			case ALLEY,ALLEYHOME,APARTMENT,CLASSROOM,OFFICE,FOODCOURT,JAIL:

			case CAFE:
			Texts.CAFES[0][2] = "SENT COPS";

			case RESTAURANT:
			Texts.RESTAURANTS[0][2] = "SENT COPS";

			case BAR:
			Texts.BARS[0][2] = "SENT COPS";

			case STORE:
			Texts.STORES[0][2] = "SENT COPS";

			case BOOKSTORE:
			Texts.BOOKSTORES[0][2] = "SENT COPS";

			case PHARMACY:
			Texts.PHARMACIES[0][2] = "SENT COPS";

			case GYM:
			Texts.GYMS[0][2] = "SENT COPS";

			case DISCO:
			Texts.DISCOS[0][2] = "SENT COPS";

			case PARK:
			Texts.PARKS[0][2] = "SENT COPS";

			case CINEMA:
			Texts.CINEMAS[0][2] = "SENT COPS";

			case CHURCH:
			Texts.CHURCHES[0][2] = "SENT COPS";

		}

		return Std.int(Math.min(arrests + 2,5));
	}


	public static function arrested():Void
	{
		nextScene = JAIL;
		jailTime += 5;
		arrests++;	
	}


	// JAIL //

	public static function getJailTime():Int
	{
		return jailTime;
	}


	// APARTMENT //

	public static function getApartmentTVText():String
	{

		// trace("Story.getApartmentTVText()");
		// trace("nextScene = " + nextScene);

		switch (nextScene)
		{
			case ALLEY,JAIL,APARTMENT,ALLEYHOME:
			return "SHOULD NEVER SEE THIS";

			case CAFE:
			return "\"DROP IN\" ON THE CAFE AND \"MAKE\" SOME NEW \"FREINDS\"";

			case RESTAURANT:
			return "GO AND \"EAT\" SOMETHING AT THAT NEW \"RESTAURANT\"";

			case BAR:
			return "TIME TO \"WET YOUR WHISTLE\" \"AT\" THE \"LOCAL\" BAR";

			case PARK:
			return "GO AND \"APPRECIATE\" SOME \"NATURE\" AT THE PARK";

			case STORE:
			return "HEAD TO THE STORE AND \"BUY\" SOME \"GUM\"";

			case BOOKSTORE:
			return "\"GO\" TO THE BOOKSTORE AND \"BROWSE\" FOR A \"BOOK\"";

			case PHARMACY:
			return "\"GET\" SOME \"CORTISONE CREAM\" FROM THE \"GUY\" AT THE \"PHARMACY\"";

			case CLASSROOM:
			return "GO TO THE \"SCHOOL\" AND \"EDUCATE\" SOME \"CHILDREN\"";

			case OFFICE:
			return "GET TO THE \"OFFICE\" AND \"HELP\" YOUR \"CO-WORKERS\"";

			case FOODCOURT:
			return "\"HEAD DOWN\" TO THE FOODCOURT AND \"SELL SOME HOTDOGS\"";

			case GYM:
			return "GO \"TAKE A CLASS\" AND \"WORKOUT\" AT THE GYM";

			case DISCO:
			return "\"DANCE\" YOUR ASS OFF AT THE \"DISCO\"";			

			case CINEMA:
			return "CATCH A \"FLICK\" AT THE CINEMA";			

			case CHURCH:
			return "\"MEET\" YOUR \"MAKER\" DOWN AT THE CHURCH";			
		}
	}


	public static function getApartmentWarning():Int
	{
		apartmentWarningLevel++;
		return apartmentWarningLevel;
	}



	public static function evicted():Void
	{
		home = ALLEYHOME;
		hasHome = false;
	}


	public static function sendAvenger():Bool
	{
		switch (thisScene)
		{
			// They don't come to the jail or the tutorial or the church
			case JAIL,CHURCH:
			return false;

			// They do come anywhere else
			case CAFE,RESTAURANT,BAR,STORE,BOOKSTORE,PHARMACY,GYM,DISCO:
			// return (Math.random() < avengerProbability && Math.random() < 0.5);	
			return false;

			case PARK,FOODCOURT,ALLEY:
			// return (Math.random() < avengerProbability && Math.random() < 0.7);	
			return false;

			case OFFICE,CLASSROOM,CINEMA:
			// return (Math.random() < avengerProbability && Math.random() < 0.2);	
			return false;

			case APARTMENT:
			return (Math.random() < avengerProbability && Math.random() < 0.75);	

			case ALLEYHOME:
			return (Math.random() < avengerProbability && Math.random() < 0.75);	

		}
	}


	public static function updateAvengerProbability(P:Float):Void
	{
		if (thisScene == APARTMENT) return;

		if (P > 250) avengerProbability += 0.2;
		else if (P > 100) avengerProbability += 0.1;
		else if (P > 50) avengerProbability += 0.05;
		else if (P > 25) avengerProbability += 0.01;
		else if (P == 0 && thisScene != ALLEYHOME) avengerProbability = Math.max(0,avengerProbability - 0.1);
		
		// trace("avengerProbability: " + avengerProbability);
	}

	// TRANSITIONS //

	public static function getNextScene():Dynamic
	{
		// trace("Story.getNextScene()");
		// trace("nextScene = " + nextScene);

		thisScene = nextScene;
		return sceneTypeToClass(nextScene);
	}


	public static function getHomeNextDestination():JostleEnums.SceneType
	{
		if (hasJob && date.getDay() < 5) return job;
		else return getNextDestination();
	}


	public static function getNextDestination():JostleEnums.SceneType
	{
		nextSceneIndex = (nextSceneIndex + 1) % Texts.DESTINATIONS.length;
		var d:JostleEnums.SceneType = Texts.DESTINATIONS[nextSceneIndex];	

		// Account for variants
		if (d == CAFE)
		{
			var r:Float = Math.random();
			if (r < 0.33) d = RESTAURANT;
			else if (r < 0.66) d = BAR;
		}
		else if (d == STORE)
		{
			var r:Float = Math.random();
			if (r < 0.33) d = PHARMACY;
			else if (r < 0.66) d = BOOKSTORE;
		}

		return d;
	}


	public static function getLocationTitle():String
	{
		switch (thisScene)
		{
			case ALLEY:
			return "ALLEY";

			case ALLEYHOME:
			return "HOME SWEET HOME";

			case APARTMENT:
			return "YOUR APARTMENT";

			case CLASSROOM:
			if (firstClassroom)
			{
				firstClassroom = false;
				return "NEW JOB:\nSUBSTITUTE TEACHER";
			}
			else
			{
				return "JOB:\nSUBSTITUTE TEACHER";
			}

			case OFFICE:
			if (firstOffice)
			{
				firstOffice = false;
				return "NEW JOB:\nOFFICE WORKER";
			}
			else
			{
				return "JOB:\nOFFICE WORKER";
			}

			case FOODCOURT:
			if (firstFoodcourt)
			{
				firstFoodcourt = false;
				return "NEW JOB:\nFOODCOURT VENDOR";
			}
			else
			{
				return "JOB:\nFOODCOURT VENDOR";
			}

			case CAFE:
			Texts.CAFES.sort(Helpers.randomSort);
			return Texts.CAFES[0][0];

			case RESTAURANT:
			Texts.RESTAURANTS.sort(Helpers.randomSort);
			return Texts.RESTAURANTS[0][0];

			case BAR:
			Texts.BARS.sort(Helpers.randomSort);
			return Texts.BARS[0][0];

			case JAIL:
			Texts.JAILS.sort(Helpers.randomSort);
			return Texts.JAILS[0][0];

			case STORE:
			Texts.STORES.sort(Helpers.randomSort);
			return Texts.STORES[0][0];

			case BOOKSTORE:
			Texts.BOOKSTORES.sort(Helpers.randomSort);
			return Texts.BOOKSTORES[0][0];

			case PHARMACY:
			Texts.PHARMACIES.sort(Helpers.randomSort);
			return Texts.PHARMACIES[0][0];

			case GYM:
			Texts.GYMS.sort(Helpers.randomSort);
			return Texts.GYMS[0][0];

			case DISCO:
			Texts.DISCOS.sort(Helpers.randomSort);
			return Texts.DISCOS[0][0];

			case PARK:
			Texts.PARKS.sort(Helpers.randomSort);
			return Texts.PARKS[0][0];

			case CINEMA:
			Texts.CINEMAS.sort(Helpers.randomSort);
			return Texts.CINEMAS[0][0];

			case CHURCH:
			Texts.CHURCHES.sort(Helpers.randomSort);
			return Texts.CHURCHES[0][0];
		}
	}


	public static function getRandomAddress():String
	{
		switch (thisScene)
		{
			case APARTMENT:
			return "108TH ST AND FRICK RD";

			case CLASSROOM:
			return "SALEM ELEMENTARY";

			case OFFICE:
			return "UNIFIED PAPER HANDLING CO.";

			case FOODCOURT:
			return "DEATHGATE MALL, BASEMENT LEVEL 2";

			case ALLEY:
			var addresses:Array<String> = 
			[
			"22ND AVE", "33RD ST", "100TH ST", "83RD AVE", 
			"QUIET DESPERATION ST", "NOWHERE RD", "WINCE AVE","WEEP ST"
			];
			addresses.sort(Helpers.randomSort);
			return addresses[0] + " AND " + addresses[1];

			case ALLEYHOME:
			var addresses:Array<String> = 
			[
			"22ND AVE", "33RD ST", "100TH ST", "83RD AVE", 
			"QUIET DESPERATION ST", "NOWHERE RD", "WINCE AVE","WEEP ST"
			];
			addresses.sort(Helpers.randomSort);
			return addresses[0] + " AND " + addresses[1];

			case CAFE:
			return Texts.CAFES[0][1];

			case RESTAURANT:
			return Texts.RESTAURANTS[0][1];

			case BAR:
			return Texts.BARS[0][1];

			case JAIL:
			return Texts.JAILS[0][1];

			case STORE:
			return Texts.STORES[0][1];

			case BOOKSTORE:
			return Texts.BOOKSTORES[0][1];

			case PHARMACY:
			return Texts.PHARMACIES[0][1];

			case GYM:
			return Texts.GYMS[0][1];

			case DISCO:
			return Texts.DISCOS[0][1];

			case PARK:
			return Texts.PARKS[0][1];

			case CINEMA:
			return Texts.CINEMAS[0][1];

			case CHURCH:
			Texts.CHURCHES.sort(Helpers.randomSort);
			return Texts.CHURCHES[0][1];
		}
	}


	public static function sceneTypeToClass(T:JostleEnums.SceneType):Dynamic
	{
		switch (T)
		{
			case ALLEY:
			return AlleyState;

			case ALLEYHOME:
			return AlleyHomeState;

			case CAFE,RESTAURANT,BAR:
			return CafeState;

			case APARTMENT:
			return ApartmentState;

			case JAIL: 
			return JailState;

			case PARK:
			return ParkState;

			case CLASSROOM:
			return ClassroomState;	

			case OFFICE:
			return OfficeState;	

			case FOODCOURT:
			return FoodcourtState;	

			case STORE,PHARMACY,BOOKSTORE:
			return StoreState;

			case GYM:
			return GymState;

			case DISCO:
			return DiscoState;

			case CINEMA:
			return CinemaState;

			case CHURCH:
			return ChurchState;
		}

		return null;
	}
}
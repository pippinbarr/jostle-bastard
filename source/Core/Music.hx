package;


import org.flixel.FlxBasic;
import org.flixel.FlxSound;
import org.flixel.FlxG;


enum Tempo
{
	SLOW;
	MEDIUM;
	FAST;
}

class Music extends FlxBasic
{
	private static var NUM_KICKS:Int = 7;
	private static var NUM_SNARES:Int = 5;
	private static var NUM_HIHATS:Int = 6;
	private static var NUM_SPLASHES:Int = 3;

	private static var TEMPO:Tempo = SLOW;
	private static var FRAMES_PER_BEAT:Int = 8;
	private static var BEATS_PER_BAR:Int = 8;

	private static var BLANK_TRACK_LINE:Array<String> = 		
	[
	""	
	];

	private static var BLANK_MELODY_LINE:Array<Int> = 
	[
	-1,
	];

	private static var ARRESTED:Array<String> = 
	[
	"k","","k","","k","","k","",
	"k","","k","","k","","k","",
	"k","","k","","k","","k","",
	"k","","k","","k","k","k","k",
	];


	private static var COMPLETED:Array<String> = 
	[
	"k","","s","","k","k","s","",
	"k","","s","","k","k","s","",
	"k","","s","","k","k","s","",
	"k","","s","","k","k","s","",
	];


	private static var FAST_DRUM_1:Array<String> = 
	[
	"k","h","k","h","k","h","k","h",
	"k","sh","k","sh","k","sh","k","p",
	"k","h","k","h","k","h","k","h",
	"k","sh","k","sh","k","ph","ph","p",
	];

	private static var FAST_DRUM_2:Array<String> = 
	[
	"kh","","ksh","","kh","","ksh","",
	"kh","sk","k","s","kh","","k","sp",
	"kh","k","skh","","kh","k","shk","",
	"kh","s","kh","s","kh","h","kph","ph",
	];

	private static var FAST_DRUM_3:Array<String> = 
	[
	"k","","skh","h","k","k","s","h",
	"k","","ksh","ph","k","k","sh","sh",
	"k","","ksh","h","k","k","s","h",
	"k","","ksh","ph","k","k","ksph","ksph",
	];

	private static var FAST_DRUM_4:Array<String> = 
	[
	"k","h","ks","h","k","h","ks","h",
	"k","hs","ks","h","k","h","kh","hp",
	"k","h","ks","h","k","h","ks","h",
	"k","hs","ks","h","k","hs","khs","ps",
	];

	private static var SLOW_DRUM_1:Array<String> = 
	[
	"k","s","","h","kp","","s","h",
	"k","s","","","k","","s","",
	"k","s","","","kp","","sh","h",
	"k","s","","s","k","","sp","sp",
	];

	private static var SLOW_DRUM_2:Array<String> = 
	[
	"k","","","s","k","","","s",
	"k","","h","h","k","","k","s",
	"k","","","s","k","","","s",
	"k","","h","h","k","","ks","ps",
	];

	private static var SLOW_DRUM_3:Array<String> = 
	[
	"k","","s","sh","k","","","sh",
	"k","s","","h","kp","s","","h",
	"k","","s","sh","k","","","sh",
	"k","s","","h","kp","","kp","sp",
	];

	private static var SLOW_DRUM_4:Array<String> = 
	[
	"k","","s","h","kp","","s","",
	"k","","s","h","k","k","s","s",
	"k","","s","h","kp","","s","",
	"kp","","h","h","kp","k","ps","s",
	];



	private static var FAST_DRUM_TRACKS:Array<Array<String>> = 
	[FAST_DRUM_1,FAST_DRUM_2,FAST_DRUM_3,FAST_DRUM_4];

	private static var SLOW_DRUM_TRACKS:Array<Array<String>> = 
	[SLOW_DRUM_1,SLOW_DRUM_2,SLOW_DRUM_3,SLOW_DRUM_4];

	private var slowMode:Bool = true;

	private var frames:Int = 0;
	private var beats:Int = 0;
	private var bars:Int = 0;

	private var drumTrack:Array<String>;
	private var drumIndex:Int = 0;

	private var kick:FlxSound;
	private var snare:FlxSound;
	private var hihat:FlxSound;
	private var splash:FlxSound;
	
	private var volume:Float = 0;
	private var volumeIncrement:Float = 0;

	private var playing:Bool = false;
	private var switchTrack:Bool = false;





	public function new():Void
	{
		super();

		createInstruments();
		switchTheTrack();
	}


	override public function update():Void
	{
		super.update();


		if (!playing) return;

		frames++;

		if (SceneState.score.justJostled && frames == FRAMES_PER_BEAT)
		{
			SceneState.score.justJostled = false;
			GameAssets.JOSTLE_MP3.play(true);
		}

		setVolumes();

		if (frames == FRAMES_PER_BEAT)
		{
			beats++;

			if (drumTrack[drumIndex].indexOf("k") != -1) kick.play(true);
			if (drumTrack[drumIndex].indexOf("s") != -1) snare.play(true);
			if (drumTrack[drumIndex].indexOf("h") != -1) hihat.play(true);
			if (drumTrack[drumIndex].indexOf("p") != -1) splash.play(true);

			frames = 0;
			drumIndex = (drumIndex + 1) % drumTrack.length;

			if (beats == BEATS_PER_BAR) 
			{
				beats = 0;
				bars++;
			}

			if (bars == 8) 
			{
				if (Math.random() < 0.25) return;
				drumIndex = 0;
				switchTheTrack();
			}
		}
	}


	private function setVolumes():Void
	{
		if (volumeIncrement == 0) return;

		volume += volumeIncrement;
		if (volume < 0) 
		{
			volume = 0;
			volumeIncrement = 0;
		}
		if (volume > 1) 
		{
			volume = 1;
			volumeIncrement = 0;
		}

		kick.volume = volume;
		snare.volume = volume;
		hihat.volume = volume;
		splash.volume = volume;
	}


	private function switchTheTrack():Void
	{
		if (drumTrack == COMPLETED || drumTrack == ARRESTED) return;

		frames = 0;
		beats = 0;
		bars = 0;

		if (slowMode)
		{
			drumTrack = SLOW_DRUM_TRACKS[Math.floor(Math.random() * SLOW_DRUM_TRACKS.length)];
		}
		else 
		{
			drumTrack = FAST_DRUM_TRACKS[Math.floor(Math.random() * FAST_DRUM_TRACKS.length)];
		}
	}


	override public function destroy():Void
	{

	}


	public function fadeIn():Void
	{		
		playing = true;
		volume = 0;
		volumeIncrement = 0.01;
	}

	public function fadeOut():Void
	{
		volumeIncrement = -0.1;
	}


	public function playCompleted():Void
	{
		drumTrack = COMPLETED;
		switchTheTrack();
		setTempo(MEDIUM);
	}

	public function playArrested():Void
	{
		drumTrack = ARRESTED;
		switchTheTrack();
		setTempo(FAST);
	}

	public function setTempo(T:Tempo):Void
	{
		if (T != TEMPO)
		{
			TEMPO = T;
			if (TEMPO == SLOW) FRAMES_PER_BEAT = 8;
			else if (TEMPO == MEDIUM) FRAMES_PER_BEAT = 6;
			else if (TEMPO == FAST) FRAMES_PER_BEAT = 4;

			switchTheTrack();
		}
	}


	public function getTempo():Tempo
	{
		return TEMPO;
	}


	public function inSlowMode():Bool
	{
		return slowMode;
	}


	public function setSlowMode():Void
	{
		if (!slowMode)
		{
			slowMode = true;
			switchTheTrack();
		}
	}

	public function setFastMode():Void
	{
		if (slowMode)
		{
			slowMode = false;
			switchTheTrack();
		}
	}


	private function generateRandomDrumTrack(Hits:Int):Array<String>
	{
		var track:Array<String> = new Array();
		for (i in 0...Hits)
		{
			var t:String = "";
			if (Math.random() < 0.25) t += "k";
			if (Math.random() < 0.2) t += "s";
			if (Math.random() < 0.3) t += "h";
			if (Math.random() < 0.1) t += "p";
			track.push(t);
		}

		return track;
	}


	private function createInstruments():Void
	{
		kick = new FlxSound();
		var kickType:Int = Math.floor(Math.random() * NUM_KICKS);
		kick.loadEmbedded("assets/mp3/kick/" + kickType + ".mp3",false,false);

		snare = new FlxSound();
		var snareType:Int = Math.floor(Math.random() * NUM_SNARES);
		snare.loadEmbedded("assets/mp3/snare/" + snareType + ".mp3",false,false);

		hihat = new FlxSound();
		var hihatType:Int = Math.floor(Math.random() * NUM_HIHATS);
		hihat.loadEmbedded("assets/mp3/hihat/" + hihatType + ".mp3",false,false);

		splash = new FlxSound();
		var splashType:Int = Math.floor(Math.random() * NUM_SPLASHES);
		splash.loadEmbedded("assets/mp3/splash/" + splashType + ".mp3",false,false);
	}

}
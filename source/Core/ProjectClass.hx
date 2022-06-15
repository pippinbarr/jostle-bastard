package;

import flash.Lib;

import org.flixel.FlxGame;
import org.flixel.FlxSound;
import org.flixel.FlxG;


class ProjectClass extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var ratio:Float = stageWidth / 640;

		super(stageWidth, stageHeight, TitleState, ratio, 30, 30);
		// super(stageWidth, stageHeight, DiscoState, ratio, 30, 30);

		GameAssets.JOSTLE_MP3 = new FlxSound();
		GameAssets.JOSTLE_MP3.loadEmbedded("assets/mp3/jostle.mp3",false,false);
		// GameAssets.JOSTLE_MP3.volume = 0;

		Texts.DESTINATIONS.sort(Helpers.randomSort);
		Story.setupDate();

		FlxG.keyMute = null;
		FlxG.keyVolumeDown = null;
		FlxG.keyVolumeUp = null;
	}
}

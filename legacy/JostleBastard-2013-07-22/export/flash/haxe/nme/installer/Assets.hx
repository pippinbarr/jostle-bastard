package nme.installer;


import format.display.MovieClip;
import haxe.Unserializer;
import nme.display.BitmapData;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.ByteArray;
import ApplicationMain;

#if swf
import format.SWF;
#end

#if xfl
import format.XFL;
#end


/**
 * ...
 * @author Joshua Granick
 */

class Assets {

	
	public static var cachedBitmapData:Hash<BitmapData> = new Hash<BitmapData>();
	#if swf private static var cachedSWFLibraries:Hash <SWF> = new Hash <SWF> (); #end
	#if xfl private static var cachedXFLLibraries:Hash <XFL> = new Hash <XFL> (); #end
	
	private static var initialized:Bool = false;
	private static var libraryTypes:Hash <String> = new Hash <String> ();
	private static var resourceClasses:Hash <Dynamic> = new Hash <Dynamic> ();
	private static var resourceTypes:Hash <String> = new Hash <String> ();
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			resourceClasses.set ("Beep", NME_assets_data_beep_mp3);
			resourceTypes.set ("Beep", "sound");
			resourceClasses.set ("assets/data/autotiles.png", NME_assets_data_autotiles_png);
			resourceTypes.set ("assets/data/autotiles.png", "image");
			resourceClasses.set ("assets/data/autotiles_alt.png", NME_assets_data_autotiles_alt_png);
			resourceTypes.set ("assets/data/autotiles_alt.png", "image");
			resourceClasses.set ("assets/data/base.png", NME_assets_data_base_png);
			resourceTypes.set ("assets/data/base.png", "image");
			resourceClasses.set ("assets/data/beep.mp3", NME_assets_data_beep_mp4);
			resourceTypes.set ("assets/data/beep.mp3", "music");
			resourceClasses.set ("assets/data/button.png", NME_assets_data_button_png);
			resourceTypes.set ("assets/data/button.png", "image");
			resourceClasses.set ("assets/data/button_a.png", NME_assets_data_button_a_png);
			resourceTypes.set ("assets/data/button_a.png", "image");
			resourceClasses.set ("assets/data/button_b.png", NME_assets_data_button_b_png);
			resourceTypes.set ("assets/data/button_b.png", "image");
			resourceClasses.set ("assets/data/button_c.png", NME_assets_data_button_c_png);
			resourceTypes.set ("assets/data/button_c.png", "image");
			resourceClasses.set ("assets/data/button_down.png", NME_assets_data_button_down_png);
			resourceTypes.set ("assets/data/button_down.png", "image");
			resourceClasses.set ("assets/data/button_left.png", NME_assets_data_button_left_png);
			resourceTypes.set ("assets/data/button_left.png", "image");
			resourceClasses.set ("assets/data/button_right.png", NME_assets_data_button_right_png);
			resourceTypes.set ("assets/data/button_right.png", "image");
			resourceClasses.set ("assets/data/button_up.png", NME_assets_data_button_up_png);
			resourceTypes.set ("assets/data/button_up.png", "image");
			resourceClasses.set ("assets/data/button_x.png", NME_assets_data_button_x_png);
			resourceTypes.set ("assets/data/button_x.png", "image");
			resourceClasses.set ("assets/data/button_y.png", NME_assets_data_button_y_png);
			resourceTypes.set ("assets/data/button_y.png", "image");
			resourceClasses.set ("assets/data/courier.ttf", NME_assets_data_courier_ttf);
			resourceTypes.set ("assets/data/courier.ttf", "font");
			resourceClasses.set ("assets/data/cursor.png", NME_assets_data_cursor_png);
			resourceTypes.set ("assets/data/cursor.png", "image");
			resourceClasses.set ("assets/data/default.png", NME_assets_data_default_png);
			resourceTypes.set ("assets/data/default.png", "image");
			resourceClasses.set ("assets/data/fontData10pt.png", NME_assets_data_fontdata10pt_png);
			resourceTypes.set ("assets/data/fontData10pt.png", "image");
			resourceClasses.set ("assets/data/fontData11pt.png", NME_assets_data_fontdata11pt_png);
			resourceTypes.set ("assets/data/fontData11pt.png", "image");
			resourceClasses.set ("assets/data/handle.png", NME_assets_data_handle_png);
			resourceTypes.set ("assets/data/handle.png", "image");
			resourceClasses.set ("assets/data/logo.png", NME_assets_data_logo_png);
			resourceTypes.set ("assets/data/logo.png", "image");
			resourceClasses.set ("assets/data/logo_corners.png", NME_assets_data_logo_corners_png);
			resourceTypes.set ("assets/data/logo_corners.png", "image");
			resourceClasses.set ("assets/data/logo_light.png", NME_assets_data_logo_light_png);
			resourceTypes.set ("assets/data/logo_light.png", "image");
			resourceClasses.set ("assets/data/nokiafc22.ttf", NME_assets_data_nokiafc22_ttf);
			resourceTypes.set ("assets/data/nokiafc22.ttf", "font");
			resourceClasses.set ("assets/data/stick.png", NME_assets_data_stick_png);
			resourceTypes.set ("assets/data/stick.png", "image");
			resourceClasses.set ("assets/data/vcr/flixel.png", NME_assets_data_vcr_flixel_png);
			resourceTypes.set ("assets/data/vcr/flixel.png", "image");
			resourceClasses.set ("assets/data/vcr/open.png", NME_assets_data_vcr_open_png);
			resourceTypes.set ("assets/data/vcr/open.png", "image");
			resourceClasses.set ("assets/data/vcr/pause.png", NME_assets_data_vcr_pause_png);
			resourceTypes.set ("assets/data/vcr/pause.png", "image");
			resourceClasses.set ("assets/data/vcr/play.png", NME_assets_data_vcr_play_png);
			resourceTypes.set ("assets/data/vcr/play.png", "image");
			resourceClasses.set ("assets/data/vcr/record_off.png", NME_assets_data_vcr_record_off_png);
			resourceTypes.set ("assets/data/vcr/record_off.png", "image");
			resourceClasses.set ("assets/data/vcr/record_on.png", NME_assets_data_vcr_record_on_png);
			resourceTypes.set ("assets/data/vcr/record_on.png", "image");
			resourceClasses.set ("assets/data/vcr/restart.png", NME_assets_data_vcr_restart_png);
			resourceTypes.set ("assets/data/vcr/restart.png", "image");
			resourceClasses.set ("assets/data/vcr/step.png", NME_assets_data_vcr_step_png);
			resourceTypes.set ("assets/data/vcr/step.png", "image");
			resourceClasses.set ("assets/data/vcr/stop.png", NME_assets_data_vcr_stop_png);
			resourceTypes.set ("assets/data/vcr/stop.png", "image");
			resourceClasses.set ("assets/data/vis/bounds.png", NME_assets_data_vis_bounds_png);
			resourceTypes.set ("assets/data/vis/bounds.png", "image");
			resourceClasses.set ("assets/HaxeFlixel.svg", NME_assets_haxeflixel_svg);
			resourceTypes.set ("assets/HaxeFlixel.svg", "text");
			resourceClasses.set ("assets/png/avatar-4x.png", NME_assets_png_avatar_4x_png);
			resourceTypes.set ("assets/png/avatar-4x.png", "image");
			resourceClasses.set ("assets/png/avatar-8x.png", NME_assets_png_avatar_8x_png);
			resourceTypes.set ("assets/png/avatar-8x.png", "image");
			resourceClasses.set ("assets/png/avatar-small.png", NME_assets_png_avatar_small_png);
			resourceTypes.set ("assets/png/avatar-small.png", "image");
			resourceClasses.set ("assets/png/avatar_hit-4x.png", NME_assets_png_avatar_hit_4x_png);
			resourceTypes.set ("assets/png/avatar_hit-4x.png", "image");
			resourceClasses.set ("assets/png/avatar_hit-8x-noalpha.png", NME_assets_png_avatar_hit_8x_noalpha_png);
			resourceTypes.set ("assets/png/avatar_hit-8x-noalpha.png", "image");
			resourceClasses.set ("assets/png/avatar_hit-8x.png", NME_assets_png_avatar_hit_8x_png);
			resourceTypes.set ("assets/png/avatar_hit-8x.png", "image");
			resourceClasses.set ("assets/png/cafe_counter.png", NME_assets_png_cafe_counter_png);
			resourceTypes.set ("assets/png/cafe_counter.png", "image");
			resourceClasses.set ("assets/png/cafe_counter_hit.png", NME_assets_png_cafe_counter_hit_png);
			resourceTypes.set ("assets/png/cafe_counter_hit.png", "image");
			resourceClasses.set ("assets/png/cafe_table_and_chairs.png", NME_assets_png_cafe_table_and_chairs_png);
			resourceTypes.set ("assets/png/cafe_table_and_chairs.png", "image");
			resourceClasses.set ("assets/png/cafe_table_and_chairs_hit.png", NME_assets_png_cafe_table_and_chairs_hit_png);
			resourceTypes.set ("assets/png/cafe_table_and_chairs_hit.png", "image");
			resourceClasses.set ("assets/png/cafe_test.png", NME_assets_png_cafe_test_png);
			resourceTypes.set ("assets/png/cafe_test.png", "image");
			resourceClasses.set ("assets/png/cafe_walls.png", NME_assets_png_cafe_walls_png);
			resourceTypes.set ("assets/png/cafe_walls.png", "image");
			resourceClasses.set ("assets/png/cafe_walls_hit.png", NME_assets_png_cafe_walls_hit_png);
			resourceTypes.set ("assets/png/cafe_walls_hit.png", "image");
			resourceClasses.set ("assets/png/enemy-4x.png", NME_assets_png_enemy_4x_png);
			resourceTypes.set ("assets/png/enemy-4x.png", "image");
			resourceClasses.set ("assets/png/enemy-8x.png", NME_assets_png_enemy_8x_png);
			resourceTypes.set ("assets/png/enemy-8x.png", "image");
			resourceClasses.set ("assets/png/person_frames.png", NME_assets_png_person_frames_png);
			resourceTypes.set ("assets/png/person_frames.png", "image");
			resourceClasses.set ("assets/pxa/person_frames.pxa/0.pxi", NME_assets_pxa_person_frames_pxa_0_pxi);
			resourceTypes.set ("assets/pxa/person_frames.pxa/0.pxi", "binary");
			resourceClasses.set ("assets/pxa/person_frames.pxa/1.pxi", NME_assets_pxa_person_frames_pxa_1_pxi);
			resourceTypes.set ("assets/pxa/person_frames.pxa/1.pxi", "binary");
			resourceClasses.set ("assets/pxa/person_frames.pxa/2.pxi", NME_assets_pxa_person_frames_pxa_2_pxi);
			resourceTypes.set ("assets/pxa/person_frames.pxa/2.pxi", "binary");
			resourceClasses.set ("assets/pxa/person_frames.pxa/CelData.plist", NME_assets_pxa_person_frames_pxa_celdata_plist);
			resourceTypes.set ("assets/pxa/person_frames.pxa/CelData.plist", "text");
			
			
			initialized = true;
			
		}
		
	}
	
	
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id).toLowerCase () == "image") {
			
			if (useCache && cachedBitmapData.exists (id)) {
				
				return cachedBitmapData.get (id);
				
			} else {
				
				var data = cast (Type.createInstance (resourceClasses.get (id), []), BitmapData);
				
				if (useCache) {
					
					cachedBitmapData.set (id, data);
					
				}
				
				return data;
				
			}
			
		} else if (id.indexOf (":") > -1) {
			
			var libraryName = id.substr (0, id.indexOf (":"));
			var symbolName = id.substr (id.indexOf (":") + 1);
			
			if (libraryTypes.exists (libraryName)) {
				
				#if swf
				
				if (libraryTypes.get (libraryName) == "swf") {
					
					if (!cachedSWFLibraries.exists (libraryName)) {
						
						cachedSWFLibraries.set (libraryName, new SWF (getBytes ("libraries/" + libraryName + ".swf")));
						
					}
					
					return cachedSWFLibraries.get (libraryName).getBitmapData (symbolName);
					
				}
				
				#end
				
				#if xfl
				
				if (libraryTypes.get (libraryName) == "xfl") {
					
					if (!cachedXFLLibraries.exists (libraryName)) {
						
						cachedXFLLibraries.set (libraryName, Unserializer.run (getText ("libraries/" + libraryName + "/" + libraryName + ".dat")));
						
					}
					
					return cachedXFLLibraries.get (libraryName).getBitmapData (symbolName);
					
				}
				
				#end
				
			} else {
				
				trace ("[nme.Assets] There is no asset library named \"" + libraryName + "\"");
				
			}
			
		} else {
			
			trace ("[nme.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
			
		}
		
		return null;
		
	}
	
	
	public static function getBytes (id:String):ByteArray {
		
		initialize ();
		
		if (resourceClasses.exists (id)) {
			
			return Type.createInstance (resourceClasses.get (id), []);
			
		} else {
			
			trace ("[nme.Assets] There is no ByteArray asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getFont (id:String):Font {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id).toLowerCase () == "font") {
			
			return cast (Type.createInstance (resourceClasses.get (id), []), Font);
			
		} else {
			
			trace ("[nme.Assets] There is no Font asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getMovieClip (id:String):MovieClip {
		
		initialize ();
		
		var libraryName = id.substr (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		
		if (libraryTypes.exists (libraryName)) {
			
			#if swf
			
			if (libraryTypes.get (libraryName) == "swf") {
				
				if (!cachedSWFLibraries.exists (libraryName)) {
					
					cachedSWFLibraries.set (libraryName, new SWF (getBytes ("libraries/" + libraryName + ".swf")));
					
				}
				
				return cachedSWFLibraries.get (libraryName).createMovieClip (symbolName);
				
			}
			
			#end
			
			#if xfl
			
			if (libraryTypes.get (libraryName) == "xfl") {
				
				if (!cachedXFLLibraries.exists (libraryName)) {
					
					cachedXFLLibraries.set (libraryName, Unserializer.run (getText ("libraries/" + libraryName + "/" + libraryName + ".dat")));
					
				}
				
				return cachedXFLLibraries.get (libraryName).createMovieClip (symbolName);
				
			}
			
			#end
			
		} else {
			
			trace ("[nme.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		return null;
		
	}
	
	
	public static function getSound (id:String):Sound {
		
		initialize ();
		
		if (resourceTypes.exists (id)) {
			
			if (resourceTypes.get (id).toLowerCase () == "sound" || resourceTypes.get (id).toLowerCase () == "music") {
				
				return cast (Type.createInstance (resourceClasses.get (id), []), Sound);
				
			}
			
		}
		
		trace ("[nme.Assets] There is no Sound asset with an ID of \"" + id + "\"");
		
		return null;
		
	}
	
	
	public static function getText (id:String):String {
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
	//public static function loadBitmapData(id:String, handler:BitmapData -> Void, useCache:Bool = true):BitmapData
	//{
		//return null;
	//}
	//
	//
	//public static function loadBytes(id:String, handler:ByteArray -> Void):ByteArray
	//{	
		//return null;
	//}
	//
	//
	//public static function loadText(id:String, handler:String -> Void):String
	//{
		//return null;
	//}
	
	
}
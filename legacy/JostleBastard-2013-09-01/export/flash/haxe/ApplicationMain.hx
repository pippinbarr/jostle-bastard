#if nme

import Main;
import nme.display.DisplayObject;
import nme.Assets;
import nme.events.Event;

class ApplicationMain {

	static var mPreloader:NMEPreloader;

	public static function main() {
		var call_real = true;
		
		//nme.Lib.setPackage("Zaphod", "JostleBastard", "com.example.myapp", "0.0.1");
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		
		if (loaded < total || true) /* Always wait for event */ {
			call_real = false;
			mPreloader = new NMEPreloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener(nme.events.Event.ENTER_FRAME, onEnter);
		}
		
		
		#if !fdb
		//haxe.Log.trace = flashTrace;
		#end
		
		if (call_real)
			begin();
	}

	#if !fdb
	//private static function flashTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		//var className = pos.className.substr(pos.className.lastIndexOf('.') + 1);
		//var message = className+"::"+pos.methodName+":"+pos.lineNumber+": " + v;
		//
		//if (nme.external.ExternalInterface.available)
			//nme.external.ExternalInterface.call("console.log", message);
		//else untyped flash.Boot.__trace(v, pos);
    //}
	#end

	private static function begin() {
		var hasMain = false;
		
		for (methodName in Type.getClassFields(Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod(Main, Reflect.field (Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(Main, []);
			if (Std.is(instance, nme.display.DisplayObject)) {
				nme.Lib.current.addChild(cast instance);
			}
		}
	}

	static function onEnter(_) {
		var loaded = nme.Lib.current.loaderInfo.bytesLoaded;
		var total = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
		}
	}

	private static function preloader_onComplete(event:Event):Void {
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		begin();
	}
}

#else

import Main;

class ApplicationMain {
	
	public static function main() {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod(Main, Reflect.field (Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(Main, []);
			if (Std.is(instance, flash.display.DisplayObject)) {
				flash.Lib.current.addChild(cast instance);
			}
		}
	}
}

#end
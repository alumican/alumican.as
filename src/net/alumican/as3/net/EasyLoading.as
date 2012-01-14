package net.alumican.as3.net
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * EasyLoadeng
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class EasyLoading 
	{
		/**
		 * 外部画像及び外部SWFの読み込みをおこなう
		 * @param	url
		 * @param	params
		 * @return
		 */
		public static function loadClip(url:String, params:Object):Loader {
			
			var onProgress:Function      = params.onProgress;
			var onInit:Function          = params.onInit;
			var onIOError:Function       = params.onIOError;
			var onSecurityError:Function = params.onSecurityError;
			
			var loaderContext:LoaderContext = params.loaderContext;
			var loader:Loader               = (params.loader != null) ? params.loader : new Loader();
			
			var progressHandler:Function = function(e:ProgressEvent):void {
				if (onProgress != null) onProgress(e);
			}
			
			var initHandler:Function = function(e:Event):void {
				removeAllEventListeners();
				if (onInit != null) onInit(e);
			}
			
			var IOErrorHandler:Function = function(e:IOErrorEvent):void {
				removeAllEventListeners();
				if (onIOError != null) onIOError(e);
			}
			
			var securityErrorHandler:Function = function(e:SecurityErrorEvent):void {
				removeAllEventListeners();
				if (onSecurityError != null) onSecurityError(e);
			}
			
			
			var removeAllEventListeners:Function = function():void {
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS           , progressHandler     );
				loader.contentLoaderInfo.removeEventListener(Event.INIT                       , initHandler         );
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      );
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS           , progressHandler     );
			loader.contentLoaderInfo.addEventListener(Event.INIT                       , initHandler         );
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR            , IOErrorHandler      );
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			loader.load(new URLRequest(url), loaderContext);
			
			return loader;
		}
	}
}
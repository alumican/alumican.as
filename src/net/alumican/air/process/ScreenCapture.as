package net.alumican.air.process
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 外部プロセスの起動と終了
	 */
	public class ScreenCapture extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const COMPLETE:String   = "onComplete";
		static public const ERROR_DATA:String = "onErrorData";
		static public const IO_ERROR:String   = "onErrorData";
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * プロセス
		 */
		private var _process:NativeProcess;
		
		/**
		 * プロセスの起動情報
		 */
		private var _startupInfo:NativeProcessStartupInfo;
		
		/**
		 * 取得した画像
		 */
		public function get bmd():BitmapData { return _bmd.clone(); }
		private var _bmd:BitmapData;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function ScreenCapture():void
		{
		}
		
		/**
		 * スクリーンショットを撮影する
		 * @param	fullscreen
		 */
		public function capture(fullscreen:Boolean = true):void
		{
			var args:Vector.<String> = new Vector.<String>();
			args[0] = fullscreen ? "1" : "0";
			
			//プロセス情報の生成
			_startupInfo            = new NativeProcessStartupInfo();
			_startupInfo.executable = File.applicationDirectory.resolvePath("screencapture.exe");
			_startupInfo.arguments  = args;
			
			//プロセスの生成
			_process = new NativeProcess();
			_process.addEventListener(NativeProcessExitEvent.EXIT          , _processExitHandler);
			_process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA    , _processStandardErrorDataHandler);
			_process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, _processStandardOutputIOErrorHandler);
			_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR , _processStandardErrorIOErrorHandler);
			_process.start(_startupInfo);
		}
		
		private function _removeEventHandlers():void
		{
			_process.removeEventListener(NativeProcessExitEvent.EXIT          , _processExitHandler);
			_process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA    , _processStandardErrorDataHandler);
			_process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, _processStandardOutputIOErrorHandler);
			_process.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR , _processStandardErrorIOErrorHandler);
		}
		
		/**
		 * プロセスの終了ハンドラ
		 * @param	e
		 */
		private function _processExitHandler(e:NativeProcessExitEvent):void 
		{
			var c:Clipboard = Clipboard.generalClipboard;
			_bmd = c.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
			
			if (!_bmd)
			{
				_loadCapture();
			}
			else
			{
				dispatchEvent(new Event(ScreenCapture.COMPLETE));
			}
			_removeEventHandlers();
		}
		
		private function _loadCapture():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
			loader.load(new URLRequest(File.applicationDirectory.resolvePath("capture.png").nativePath));
		}
		
		private function _loadCompleteHandler(e:Event):void 
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
			_bmd = Bitmap(loader.content).bitmapData;
			dispatchEvent(new Event(ScreenCapture.COMPLETE));
		}
		
		private function _loadIOErrorHandler(e:IOErrorEvent):void 
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
			dispatchEvent(new Event(ScreenCapture.IO_ERROR));
		}
		
		/**
		 * プロセスの標準エラーハンドラ
		 * @param	e
		 */
		private function _processStandardErrorDataHandler(e:ProgressEvent):void 
		{
			dispatchEvent(new Event(ScreenCapture.ERROR_DATA));
			_removeEventHandlers();
		}
		
		/**
		 * プロセスのIOエラーハンドラ
		 * @param	e
		 */
		private function _processStandardOutputIOErrorHandler(e:IOErrorEvent):void 
		{
			dispatchEvent(new Event(ScreenCapture.IO_ERROR));
			_removeEventHandlers();
		}
		
		/**
		 * プロセスのIOエラーハンドラ
		 * @param	e
		 */
		private function _processStandardErrorIOErrorHandler(e:IOErrorEvent):void
		{
			dispatchEvent(new Event(ScreenCapture.IO_ERROR));
			_removeEventHandlers();
		}
	}
}
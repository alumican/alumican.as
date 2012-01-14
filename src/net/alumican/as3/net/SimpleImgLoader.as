package net.alumican.as3.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * SimpleImgLoader
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class SimpleImgLoader
	{
		//----------------------------------------
		//STATIC CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 読み込み完了ハンドラ
		 */
		public var onLoadComplete:Function;
		
		/**
		 * 読み込み進捗ハンドラ
		 */
		public var onLoadProgress:Function;
		
		/**
		 * 読み込みIOエラーハンドラ
		 */
		public var onLoadIOError:Function;
		
		/**
		 * 読み込みセキュリティエラーハンドラ
		 */
		public var onLoadSecurityError:Function;
		
		/**
		 * Loader
		 */
		private var _loader:Loader;
		
		/**
		 * LoaderContext
		 */
		private var _context:LoaderContext;
		
		/**
		 * コールバックパラメータ
		 */
		public var onLoadCompleteParams:Array;
		public var onLoadProgressParams:Array;
		public var onLoadIOErrorParams:Array;
		public var onLoadSecurityErrorParams:Array;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * SimpleImgLoaderインスタンスを生成します．
		 */
		public function SimpleImgLoader():void
		{
		}
		
		/**
		 * データを読み込みます．
		 * @param	url		読み込むデータのURL
		 * @param	context	LoaderContext
		 * @return
		 */
		public function load(url:String, context:LoaderContext = null):Loader
		{
			_context = (context != null) ? context : new LoaderContext(true);
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _loadInitHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _loadProgressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _loadSecurityErrorHandler);
			
			_loader.load(new URLRequest(url), _context);
			
			return _loader;
		}
		
		/**
		 * ロードを中止する
		 */
		public function cancel():void
		{
			if (_loader != null)
			{
				try
				{
					_loader.close();
				}
				catch (e:Error) { }
				
				_loader.contentLoaderInfo.removeEventListener(Event.INIT, _loadInitHandler);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _loadProgressHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _loadIOErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loadSecurityErrorHandler);
				_loader = null;
			}
			
			_context = null;
		}
		
		/**
		 * 廃棄する
		 */
		public function dispose():void
		{
			cancel();
			
			onLoadComplete      = null;
			onLoadProgress      = null;
			onLoadIOError       = null;
			onLoadSecurityError = null;
			
			onLoadCompleteParams      = null;
			onLoadProgressParams      = null;
			onLoadIOErrorParams       = null;
			onLoadSecurityErrorParams = null;
		}
		
		/**
		 * 読み込み完了ハンドラ
		 * @param	e
		 */
		private function _loadInitHandler(e:Event):void 
		{
			//コールバック関数の呼び出し
			if (onLoadComplete != null)
			{
				var bmp:Bitmap = new Bitmap( Bitmap(_loader.content).bitmapData.clone() );
				var args:Array = onLoadCompleteParams ? [bmp].concat(onLoadCompleteParams) : [bmp];
				onLoadComplete.apply(null, args);
			}
			
			dispose();
		}
		
		/**
		 * 読み込み進捗ハンドラ
		 * @param	e
		 */
		private function _loadProgressHandler(e:ProgressEvent):void 
		{
			//コールバック関数の呼び出し
			if (onLoadProgress != null)
			{
				var args:Array = onLoadProgressParams ? [e.bytesLoaded, e.bytesTotal].concat(onLoadProgressParams) : [e.bytesLoaded, e.bytesTotal];
				onLoadProgress.apply(null, args);
			}
		}
		
		/**
		 * IOエラーハンドラ
		 * @param	e
		 */
		private function _loadIOErrorHandler(e:IOErrorEvent):void 
		{
			//コールバック関数の呼び出し
			if (onLoadIOError != null)
			{
				var args:Array = onLoadIOErrorParams ? [e].concat(onLoadIOErrorParams) : [e];
				onLoadIOError.apply(null, args);
			}
			
			dispose();
		}
		
		/**
		 * セキュリティエラーハンドラ
		 * @param	e
		 */
		private function _loadSecurityErrorHandler(e:SecurityErrorEvent):void 
		{
			//コールバック関数の呼び出し
			if (onLoadSecurityError != null)
			{
				var args:Array = onLoadSecurityErrorParams ? [e].concat(onLoadSecurityErrorParams) : [e];
				onLoadSecurityError.apply(null, args);
			}
			
			dispose();
		}
	}
}
package net.alumican.as3.display 
{
	import flash.display.Shader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.ShaderFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author alumican.net
	 */
	public class ExShader extends Shader implements IEventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * バイトコードを取得/設定する(シャローコピー)
		 */
		public function get byteCode():ByteArray { return _byteCode; }
		override public function set byteCode(value:ByteArray):void { super.byteCode = _byteCode = value; }
		private var _byteCode:ByteArray;
		
		/**
		 * 外部PBJファイル読み込み
		 */
		private var _loader:URLLoader;
		
		/**
		 * 外部PBJファイル読み込みイベント発行
		 */
		private var _dispatcher:EventDispatcher;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	code	ByteArray
		 */
		public function ExShader(code:ByteArray = null):void
		{
			_byteCode = code;
			_dispatcher = new EventDispatcher(this);
			super(code);
		}
		
		/**
		 * ByteArrayから生成する(ディープコピー)
		 * @param	byte	ByteArray
		 */
		public function fromByte(byte:ByteArray):void
		{
			var copy:ByteArray = new ByteArray();
			copy.writeBytes(byte);
			byteCode = copy;
		}
		
		/**
		 * Vectorから生成する
		 * @param	vector	int型のVetorデータ
		 */
		public function fromVector(vector:Vector.<int>):void
		{
			var byte:ByteArray = new ByteArray();
			var n:int = vector.length;
			for (var i:int = 0; i < n; ++i)
			{
				byte.writeByte(vector[i]);
			}
			byteCode = byte;
		}
		
		/**
		 * 外部PBJファイルから生成する
		 * @param	url	外部PBJファイルへのパス
		 */
		public function fromURL(url:String):void
		{
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, _loaderCompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _loaderErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderErrorHandler);
			_loader.addEventListener(Event.OPEN, dispatchEvent);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_loader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_loader.load( new URLRequest(url) );
		}
		
		/**
		 * 外部PBJファイルの読み込み完了ハンドラ
		 * @param	e
		 */
		private function _loaderCompleteHandler(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, _loaderCompleteHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderErrorHandler);
			_loader.removeEventListener(Event.OPEN, dispatchEvent);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_loader.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			byteCode = ByteArray(_loader.data);
			dispatchEvent(e);
		}
		
		/**
		 * 外部PBJファイルの読み込み失敗ハンドラ
		 * @param	e
		 */
		private function _loaderErrorHandler(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, _loaderCompleteHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loaderErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _loaderErrorHandler);
			_loader.removeEventListener(Event.OPEN, dispatchEvent);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			_loader.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			dispatchEvent(e);
		}
		
		/**
		 * Shaderから生成する
		 * @param	shader	Shader
		 */
		/*
		public function fromShader(shader:Shader):void
		{
		}
		*/
		
		/**
		 * ShaderFilterから生成する
		 * @param	filter	ShaderFilter
		 */
		/*
		public function fromFilter(filter:ShaderFilter):void
		{
		}
		*/
		
		/**
		 * ShaderFilterを返す
		 * @return	フィルタデータ
		 */
		public function toFilter():ShaderFilter
		{
			return new ShaderFilter(this);
		}
		
		/**
		 * Vector表現を返す
		 * @return	Number型のVectorデータ
		 */
		public function toVector():Vector.<int>
		{
			if (_byteCode == null) return new Vector.<int>();
			
			var position:int = _byteCode.position;
			_byteCode.position = 0;
			
			var vector:Vector.<int> = new Vector.<int>();
			while(_byteCode.bytesAvailable)
			{
				vector.push(_byteCode.readByte());
			}
			
			_byteCode.position = position;
			return vector;
		}
		
		/**
		 * ByteArray表現を返す(ディープコピー)
		 * @return	ByteArray
		 */
		public function toByteArray():ByteArray
		{
			if (_byteCode == null) return new ByteArray();
			
			var byte:ByteArray = new ByteArray();
			byte.writeBytes(_byteCode);
			
			return byte;
		}
		
		/**
		 * 文字列表現を返す
		 * @return	文字列表現
		 */
		public function toString():String 
		{
			return "[object " + getQualifiedClassName(this) + "]";
		}
		
		
		
		
		
		//----------------------------------------
		//INTERFACE flash.events.IEventDispatcher
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
	}
}
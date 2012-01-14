package net.alumican.as3.framework.thread.net
{
	import flash.net.URLRequest;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	import org.libspark.thread.utils.SerialExecutor;
	
	/**
	 * XMLLoadersThread
	 * 複数xmlデータ読み込み用スレッド
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class XMLsLoaderThread extends Thread
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		/**
		 * 読み込まれたxmlを格納する配列
		 */
		public function get xmls():Array { return _xmls; }
		private var _xmls:Array;
		
		/**
		 * 読みこむxmlのurlを格納する配列
		 */
		public function get urls():Array { return _urls; }
		private var _urls:Array;
		
		/**
		 * 1枚毎に読み込むためのSerialExecutor
		 */
		private var _loaders:SerialExecutor;
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function XMLsLoaderThread(urls:Array = null):void
		{
			_xmls = new Array();
			_urls = (urls != null) ? urls : new Array();
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 読み込む画像を貯める
		 * @param	url
		 */
		public function addURL(url:String):void 
		{
			_urls.push(url);
		}
		
		/**
		 * 実行関数
		 */
		override protected function run():void 
		{
			_loaders = new SerialExecutor();
			var n:uint = _urls.length;
			for (var i:uint = 0; i < n; ++i) 
			{
				_loaders.addThread( new URLLoaderThread(new URLRequest(_urls[i] as String)) );
			}
			_loaders.start();
			_loaders.join();
			next(_loaderCompleteHandler);
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		
		/**
		 * 読みこみ完了ハンドラ
		 */
		private function _loaderCompleteHandler():void
		{
			var n:uint = _loaders.numThreads;
			for (var i:uint = 0; i < n; ++i)
			{
				_xmls.push( new XML( URLLoaderThread(_loaders.getThreadAt(i)).loader.data ) );
			}
		}
	}
}
package net.alumican.as3.framework.thread.net
{
	import flash.errors.IOError;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	import org.libspark.thread.utils.Progress;
	
	/**
	 * XMLLoaderThread
	 * xmlデータ読み込み用スレッド
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class XMLLoaderThread extends Thread
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		/**
		 * 読み込まれたxmlデータ
		 */
		public function get xml():XML { return _xml; }
		private var _xml:XML;
		
		/**
		 * 読み込み用スレッド
		 */
		public function get loader():URLLoaderThread { return _loader; }
		private var _loader:URLLoaderThread;
		
		
		
		
		
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
		public function XMLLoaderThread(request:URLRequest, loader:URLLoader = null)
		{
			//読み込み用スレッドの生成
			_loader = new URLLoaderThread(request, loader);
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 実行関数
		 */
		override protected function run():void 
		{
			_loader.run();
			
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
			_xml = new XML(_loader.loader.data);
		}
	}
}
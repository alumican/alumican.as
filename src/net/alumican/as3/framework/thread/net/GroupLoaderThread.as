package net.alumican.as3.framework.thread.net
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.display.LoaderThread;
	import org.libspark.thread.utils.Executor;
	import org.libspark.thread.utils.IProgress;
	import org.libspark.thread.utils.IProgressNotifier;
	import org.libspark.thread.utils.Progress;
	import org.libspark.thread.utils.SerialExecutor;
	
	/**
	 * GroupLoaderThread
	 * URLをpushしてstartするとBitmapの入った配列を返してくれるスレッド
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class GroupLoaderThread extends Thread implements IProgressNotifier 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		/**
		 * 画像読み込み用Loader
		 */
		public function get loader():LoaderThread { return _loader; }
		private var _loader:LoaderThread;
		
		/**
		 * URL配列
		 */
		public function get urls():Array { return _urls; }
		private var _urls:Array;
		
		/**
		 * Bitmap配列
		 */
		public function get bmps():Array { return _bmps; }
		private var _bmps:Array;
		
		/**
		 * 進捗状況
		 */
		public function get progress():IProgress { return _progress; }
		private var _progress:Progress;
		
		/**
		 * 1枚読み込まれる毎に呼び出されるコールバック関数
		 */
		public function get onProgress():Function { return _onProgress; }
		public function set onProgress(value:Function):void { _onProgress = value; }
		private var _onProgress:Function;
		
		
		
		
		
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
		public function GroupLoaderThread():void 
		{
			_urls = new Array();
			_bmps = new Array();
			
			_progress = new Progress();
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
			var url:String = _urls[_bmps.length];
			
			_loader = new LoaderThread(new URLRequest(url), new LoaderContext(true));
			_loader.start();
			_loader.join();
			
			if (!_progress.isStarted)
			{
				_progress.start(_urls.length);
			}
			
			// 割り込みハンドラを設定
			interrupted(_interruptedHandler);
			
			next(_loaderCompleteHandler);
			
			//例外ハンドラの設定
			error(IOError      , _errorHandler);
			error(SecurityError, _errorHandler);
		}
		
		/**
		 * まだ開始を通知していなければ通知する
		 * 
		 * @private
		 */
		private function _notifyStartIfNeeded(total:Number):void
		{
			if (!_progress.isStarted)
			{
				_progress.start(total);
			}
		}
		
		/**
		 * スレッド終了処理
		 *
		 * @access protected
		 * @param
		 * @return void
		 */
		protected override function finalize():void
		{
			_loader = null;
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		
		/**
		 * Loaderから呼び出される1枚毎の読み込み完了ハンドラ
		 */
		private function _loaderCompleteHandler():void
		{
			var bmp:Bitmap = _loader.loader.content as Bitmap;
			
			var success:Boolean;
			
			if (bmp == null)
			{
				//読み込めなかったとき
				bmp = new Bitmap(new BitmapData(10, 10, true, 0x00000000));
				success = false;
			}
			else
			{
				success = true;
			}
			
			_bmps.push(bmp);
			
			var loaded:uint = _bmps.length;
			var total:uint  = _urls.length;
			
			if (loaded == total)
			{
				_completeHandler();
			}
			else {
				_progressHandler(loaded);
				
				//次の画像を読み込み
				run();
			}
			
			//コールバック関数の呼び出し
			_onProgress(loaded - 1, loaded, total, success);
		}
		
		/**
		 * 1枚読み込み完了ハンドラ
		 * 
		 * @private
		 */
		private function _progressHandler(loadedCount:uint):void
		{
			_notifyStartIfNeeded(_urls.length);
			
			//進捗を通知
			_progress.progress(loadedCount);
		}
		
		/**
		 * 全画像読み込み完了ハンドラ
		 * 
		 * @private
		 */
		private function _completeHandler():void
		{
			_notifyStartIfNeeded(_urls.length);
			
			_loader = null;
			
			//完了を通知
			_progress.complete();
		}
		
		/**
		 * 例外ハンドラ
		 *
		 * @access private
		 * @param e 発生した例外
		 * @param thread 発生元のスレッド
		 * @return void
		 */
		private function _errorHandler(e:Error, t:Thread):void
		{
			_notifyStartIfNeeded(0);
			
			//失敗を通知
			_progress.fail();
			
			//最後まで続ける
			next(_loaderCompleteHandler);
			
			//IOError をスロー
			//throw new IOError(e.message);
		}
		
		/**
		 * 割り込みハンドラ
		 */
		private function _interruptedHandler():void
		{
			_notifyStartIfNeeded(0);
			
			//ロードをキャンセル
			_loader.interrupt();
			
			//キャンセルを通知
			_progress.cancel();
		}
	}
}
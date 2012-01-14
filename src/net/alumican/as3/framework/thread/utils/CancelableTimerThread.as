package net.alumican.as3.framework.thread.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IOError;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import ken39arg.logging.Logger;
	import net.alumican.as3.threads.display.GroupLoaderThread;
	import net.alumican.as3.threads.utils.TimerThread;
	import org.libspark.thread.Monitor;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.display.LoaderThread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	import org.libspark.thread.threads.tweener.TweenerThread;
	import org.libspark.thread.utils.Executor;
	import org.libspark.thread.utils.ParallelExecutor;
	import utils.InitUtil;
	import org.libspark.thread.threads.utils.WaitThread
	
	/**
	 * CancelableTimerThread
	 * cancelメソッドによるタイマー中断処理を持ったタイマー
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class CancelableTimerThread extends Thread 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		private var _timer:Timer;
		
		
		
		
		
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
		public function IndexControllerSlideshowTimer(time:uint):void 
		{
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER, _timerHandler);
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 実行関数
		 */
		override protected function run():void
		{
			wait();
			
			_timer.start();
		}
		
		/**
		 * 終了関数
		 */
		override protected function finalize():void 
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
				_timer = null;
			}
			
			notifyAll();
		}
		
		/**
		 * タイマー中断
		 */
		public function cancel():void
		{
			finalize();
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		
		/**
		 * タイマー完了ハンドラ
		 * @param	e
		 */
		private function _timerHandler(e:TimerEvent):void 
		{
			_timer = null;
			
			notifyAll();
		}
	}
}
package net.alumican.as3.framework.thread.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.utils.WaitThread;
	
	/**
	 * TimerThread
	 * 一定時間後に何かするスレッド
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class TimerThread extends Thread
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		/**
		 * タイマー
		 */
		private var _timer:Timer;
		
		/**
		 * 待機時間(ミリ秒)
		 */
		public function get interval():uint { return _interval; }
		public function set interval(value:uint):void { _interval = value; }
		private var _interval:uint;
		
		/**
		 * 待機後に実行したい関数
		 */
		public function get handler():Function { return _handler; }
		public function set handler(value:Function):void { _handler = value; }
		private var _handler:Function;
		
		/**
		 * ループ回数(0で無限)
		 */
		public function get loop():uint { return _loop; }
		public function set loop(value:uint):void { _loop = value; }
		private var _loop:uint;
		
		/**
		 * 現在のループ回数
		 */
		public function get currentLoop():uint { return _currentLoop; }
		private var _currentLoop:uint;
		
		
		
		
		
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
		 * @param	time	待機時間(ミリ秒)
		 * @param	handler	待機後に実行したい関数
		 * @param	loop	ループ回数(0で無限)
		 */
		public function TimerThread(interval:uint, handler:Function = null, loop:uint = 1):void 
		{
			_interval = interval;
			_handler  = handler;
			_loop     = loop;
			
			_currentLoop = 0;
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * 実行関数
		 */
		override protected function run():void 
		{
			_timer = new Timer(_interval, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
            _timer.start();
			
			wait();
		}
		
		/**
		 * 終了関数
		 */
        override protected function finalize():void 
        {
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
				_timer.stop();
				_timer = null;
				_handler = null;
			}
			
			super.finalize();
			
			notifyAll();
        }
		
		/**
		 * タイマー中断
		 */
		public function cancel():void
		{
			finalize();
		}
		
		/**
		 * タイマーリセット
		 */
		public function restart():void
		{
			if (_timer)
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
		
		/**
		 * タイマー到達時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _timerHandler(e:TimerEvent):void
		{
			if (_handler != null) _handler();
			
			if (_loop == 0)
			{
				//無限ループ
				next(run);
			}
			else
			{
				//ループ回数に到達していない場合
				if (++_currentLoop < _loop)
				{
					next(run);
				}
				else
				{
					notifyAll();
				}
			}
		}
	}
}
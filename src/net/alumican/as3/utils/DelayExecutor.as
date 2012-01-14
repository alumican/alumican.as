package net.alumican.as3.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * DelayExecutor
	 * 一定時間後に指定した関数を一度だけ実行する
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class DelayExecutor 
	{
		//----------------------------------------
		//VARIABLES
		
		/**
		 * タイマー完了時に実行する関数
		 */
		public var onComplete:Function;
		
		/**
		 * 遅延時間(ミリ秒)
		 */
		public var delay:uint;
		
		/**
		 * trueの場合はタイマー完了後に実行関数とのバインドを解除する
		 */
		public var autoClear:Boolean;
		
		/**
		 * タイマー動作中であればtrueとなる
		 */
		public function get running():Boolean { return (_timer == null) ? false : _timer.running; }
		
		/**
		 * タイマー
		 */
		private var _timer:Timer;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	onComplete	実行関数
		 * @param	delay		遅延時間(ミリ秒)
		 * @param	autoClear	trueの場合はタイマー完了後に実行関数とのバインドを解除する
		 */
		public function DelayExecutor(onComplete:Function = null, delay:uint = 0, autoClear:Boolean = true):void 
		{
			this.onComplete = onComplete;
			this.delay      = delay;
			this.autoClear  = autoClear;
		}
		
		/**
		 * タイマー開始
		 * @return	DelayExecutorインスタンス
		 */
		public function start():DelayExecutor
		{
			if (_timer != null) stop();
			_timer = new Timer((delay > 0) ? delay : 1, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
			_timer.start();
			return this;
		}
		
		/**
		 * タイマー停止
		 * @return	DelayExecutorインスタンス
		 */
		public function stop():DelayExecutor
		{
			if (_timer != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
				_timer = null;
			}
			return this;
		}
		
		/**
		 * タイマー完了ハンドラ
		 * @param	e	TimerEvent
		 */
		private function _timerHandler(e:TimerEvent):void 
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _timerHandler);
			_timer = null;
			if (onComplete != null) onComplete(this);
			if (autoClear) onComplete = null;
		}
		
		/**
		 * DelayExecutorインスタンスを生成する
		 * @param	onComplete	実行関数
		 * @param	delay		遅延時間(ミリ秒)
		 * @param	autoClear	trueの場合はタイマー完了後に実行関数とのバインドを解除する
		 * @return	DelayExecutorインスタンス
		 */
		static public function register(onComplete:Function, delay:uint, autoClear:Boolean = true):DelayExecutor
		{
			return new DelayExecutor(onComplete, delay, autoClear);
		}
		
		/**
		 * Functionのプロトタイプを拡張する
		 * func["delay"](3000, [arg1, arg2]);
		 */
		static public function bindToFunction():void
		{
			Function.prototype.delay = function(delay:uint, args:Array = null):void
			{
				var f:Function = this;
				DelayExecutor.register(function(executor:DelayExecutor):void { f.apply(null, args); }, delay, true).start();
			}
		}
	}
}
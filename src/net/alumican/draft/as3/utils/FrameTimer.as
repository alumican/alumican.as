package
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	
	/**
	 * FrameTimer
	 * 
	 * @author Yukiya Okuda<alumican.net>
	 */
	public class FrameTimer extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		public function get currentFrame():int { return _currentFrame; }
		private var _currentFrame:int;
		
		public function get delay():int { return _delay; }
		public function set delay(value:int):void { _delay = value; }
		private var _delay:int;
		
		public function get currentCount():int { return _currentCount; }
		private var _currentCount:int;
		
		public function get repeatCount():int { return _repeatCount; }
		public function set repeatCount(value:int):void { _repeatCount = value; }
		private var _repeatCount:int;
		
		public function get running():Boolean { return _running; }
		private var _running:Boolean;
		
		private var _ticker:Shape;
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function FrameTimer(delay:int, repeatCount:int = 0):void
		{
			_currentFrame = 0;
			_delay = delay;
			_currentCount = 0;
			_repeatCount = repeatCount;
			_running = false;
			_ticker = new Shape();
		}
		
		/**
		 * 開始
		 */
		public function start():void
		{
			if (_running) return;
			_running = true;
			
			_ticker.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			_check();
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			if (!_running) return;
			_running = false;
			
			_ticker.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		}
		
		/**
		 * リセット
		 */
		public function reset():void
		{
			stop();
			_currentFrame = 0;
			_currentCount = 0;
		}
		
		private function _enterFrameHandler(e:Event):void 
		{
			++_currentFrame;
			_check();
		}
		
		private function _check():void
		{
			if (_currentFrame >= _delay)
			{
				++_currentCount;
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				_currentFrame = 0;
			}
			
			if (_repeatCount > 0 && _currentCount >= _repeatCount)
			{
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				reset();
			}
		}
	}
}
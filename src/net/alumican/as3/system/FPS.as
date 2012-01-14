package net.alumican.as3.system
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * FPS
	 * 
	 * @author Yukiya Okuda
	 */
	public class FPS
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 初期化済みの場合はtrue
		 */
		static public function get isInitialized():Boolean { return _isInitialized; }
		static private var _isInitialized:Boolean = false;
		
		/**
		 * Tweenライブラリの時間指定などに掛ける係数
		 */
		static public function get cTime():Number { return _cTime; }
		static private var _cTime:Number;
		
		/**
		 * 毎フレームの移動量などに掛ける係数
		 */
		static public function get cFrame():Number { return _cFrame; }
		static private var _cFrame:Number;
		
		/**
		 * リリース時フレームレート
		 */
		static public function get releaseRate():Number { return _releaseRate; }
		static public function set releaseRate(value:Number):void { _releaseRate = value; _applyRate(); }
		static private var _releaseRate:Number;
		
		/**
		 * 開発時フレームレート
		 */
		static public function get debugRate():Number { return _debugRate; }
		static public function set debugRate(value:Number):void { _debugRate = value; _applyRate(); }
		static private var _debugRate:Number;
		
		/**
		 * 再生速度(フレームレートは操作しない)
		 */
		static public function get speed():Number { return _speed; }
		static public function set speed(value:Number):void { _speed = value; _applyRate(); }
		static private var _speed:Number;
		
		/**
		 * 計測された実際のフレームレート
		 */
		static public function get actualRate():Number { return _actualRate; }
		static private var _actualRate:Number;
		
		/**
		 * 計測された実際のフレームレート(平均値)
		 */
		static public function get averageRate():Number { return _averageRate; }
		static private var _averageRate:Number;
		
		/**
		 * 計測中はtrue
		 */
		static public function get isMeasureing():Boolean { return _isMeasureing; }
		static private var _isMeasureing:Boolean;
		
		static private var _measureInterval:Number;
		static private var _measureTime:int;
		static private var _measureFrame:int;
		static private var _measureCount:int;
		
		/**
		 * Stage参照
		 */
		static private var _stage:Stage;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function FPS():void
		{
		}
		
		/**
		 * 初期化
		 */
		static public function initialize(stage:Stage):void
		{
			if (_isInitialized) return;
			_isInitialized = true;
			
			_stage = stage;
			_isMeasureing = false;
			_releaseRate = _debugRate = _stage.frameRate;
			_speed = 1;
			_applyRate();
		}
		
		/**
		 * 破棄
		 */
		static public function finalize():void
		{
			if (!_isInitialized) return;
			stopMeasure();
			_stage = null;
			_isInitialized = false;
		}
		
		/**
		 * 計測開始
		 */
		static public function startMeasure(interval:Number = 1000):void
		{
			if (!_isInitialized) return;
			if (_isMeasureing) return;
			_isMeasureing = true;
			
			_averageRate = 0;
			_measureInterval = interval;
			_measureCount = 0;
			_measureFrame = 0;
			_measureTime = getTimer();
			_stage.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		}
		
		/**
		 * 計測停止
		 */
		static public function stopMeasure():void
		{
			if (!_isInitialized) return;
			if (!_isMeasureing) return;
			_isMeasureing = false;
			
			_stage.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		}
		
		static private function _enterFrameHandler(e:Event):void
		{
			++_measureFrame;
			var time:int = getTimer();
			var elapsed:int = time - _measureTime;
			if (elapsed >= _measureInterval)
			{
				++_measureCount;
				_actualRate = 1000 * _measureCount / elapsed;
				_averageRate = (_averageRate * (_measureCount - 1) + _actualRate) / _measureCount;
			}
		}
		
		static private function _applyRate():void
		{
			if (!_isInitialized) return;
			_stage.frameRate = _releaseRate;
			_cTime = 1 / _speed;
			_cFrame = _debugRate / _releaseRate * _speed;
		}
	}
}
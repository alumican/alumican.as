package net.alumican.as3.algorithm.ga
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.alumican.as3.algorithm.ga.events.*;
	import net.alumican.as3.algorithm.ga.packets.*;
	
	/**
	 * GA
	 * 遺伝的アルゴリズム全体を統括するクラス
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class GA extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 一世代を構成する個体集合
		 */
		public function get generation():Generation { return __generation; }
		private var __generation:Generation;
		
		/**
		 * 評価環境
		 */
		public function get world():World { return __world; }
		private var __world:World;
		
		/**
		 * 現在の世代数
		 */
		public function get age():uint { return __age; }
		private var __age:uint;
		
		/**
		 * 現在の世代の中で最も優秀な個体
		 */
		public function get genius():Agent { return __genius; }
		private var __genius:Agent;
		
		/**
		 * ステップ完了時のコールバック関数
		 */
		public var onStepComplete:Function;
		
		/**
		 * 現在ステップ処理中の場合はtrue
		 */
		public function get _isRunning():Boolean { return __isRunning; }
		private var __isRunning:Boolean;
		
		/**
		 * 評価後の停止時間(ユーザー側で再起処理を行う場合にスタックオーバーフローを防止する)
		 */
		public function get sleepTime():uint { return __sleepTime; }
		public function set sleepTime(value:uint):void { __sleepTimer.delay = __sleepTime = value; }
		private var __sleepTime:uint;
		
		/**
		 * 一時停止用
		 */
		private var __sleepTimer:Timer;
		private var __tmpGenius:Agent;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param generation 一世代を構成する個体集合
		 * @param world      評価環境
		 */
		public function GA(generation:Generation, world:World):void 
		{
			__generation = generation;
			__world      = world;
			
			//イベントハンドラの登録
			__world.addEventListener(EvaluateEvent.COMPLETE, _evaluateCompleteHandler);
			__generation.addEventListener(HeredityEvent.COMPLETE, _heredityCompleteHandler);
			
			//世代数の初期化
			__age = 0;
			
			//ステップ処理中フラグの初期化
			__isRunning = false;
			
			__sleepTime  = 1;
			__sleepTimer = new Timer(__sleepTime, 1);
			__sleepTimer.addEventListener(TimerEvent.TIMER, _sleepTimerHandler);
		}
		
		/**
		 * 世代を更新する
		 * @return 成否
		 */
		public function step():Boolean
		{
			//処理中もしくは個体数が1以下の場合は何もしない
			if (__isRunning || __generation.agentCount < 2) return false;
			
			//ステップ開始
			__isRunning = true;
			
			//交配
			__generation._heredity();
			
			return true;
		}
		
		/**
		 * 交配完了ハンドラ
		 * @param	e
		 */
		private function _heredityCompleteHandler(e:HeredityEvent):void 
		{
			//評価
			__world._evaluate(__generation);
		}
		
		/**
		 * 評価完了ハンドラ
		 * @param	e
		 */
		private function _evaluateCompleteHandler(e:EvaluateEvent):void 
		{
			__tmpGenius = e.genius;
			
			if (__sleepTime > 0)
			{
				__sleepTimer.reset();
				__sleepTimer.start();
			}
			else
			{
				_notifyStepComplete(__tmpGenius);
			}
		}
		
		/**
		 * 評価後の一時停止完了ハンドラ
		 * @param	e
		 */
		private function _sleepTimerHandler(e:TimerEvent):void 
		{
			_notifyStepComplete(__tmpGenius);
		}
		
		/**
		 * 世代更新完了を通知する
		 * @param	genius
		 */
		private function _notifyStepComplete(genius:Agent):void
		{
			//現世代の最優秀個体
			__genius = genius;
			
			//世代数の更新
			++__age;
			
			//ステップ終了
			__isRunning = false;
			
			//コールバック関数の呼び出し
			if (onStepComplete != null) onStepComplete(__genius, __age);
			
			//世代更新完了イベントの発行
			dispatchEvent( new GAEvent(GAEvent.STEP_COMPLETE, __genius, __age) );
		}
	}
}
package net.alumican.as3.algorithm.ga.events
{
	import flash.events.Event;
	import net.alumican.as3.algorithm.ga.Agent;
	import net.alumican.as3.algorithm.ga.Generation;
	
	/**
	 * EvaluateEvent
	 * 世代の評価をやりとりするイベントクラス
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class EvaluateEvent extends Event
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * イベントタイプ
		 */
		static public const REQUEST:String  = "onRequest";
		static public const COMPLETE:String = "onComplete";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		public function get generation():Generation { return _generation; }
		private var _generation:Generation;
		
		public function get genius():Agent { return _genius; }
		private var _genius:Agent;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param type
		 * @param genius
		 * @param bubbles
		 * @param cancelable
		 */
		public function EvaluateEvent(type:String, generation:Generation, genius:Agent = null, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			_generation = generation;
			_genius     = genius;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 自身のコピーを返す
		 * @return
		 */
		override public function clone():Event
		{
			return new EvaluateEvent(type, _generation, _genius, bubbles, cancelable);
		}
	}
}
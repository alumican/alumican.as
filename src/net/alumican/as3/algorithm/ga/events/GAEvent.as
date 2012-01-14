package net.alumican.as3.algorithm.ga.events
{
	import flash.events.Event;
	import net.alumican.as3.algorithm.ga.Agent;
	import net.alumican.as3.algorithm.ga.Generation;
	
	/**
	 * GAEvent
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class GAEvent extends Event
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * ステップ完了時のイベントタイプ
		 */
		static public const STEP_COMPLETE:String = "onStepComplete";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		public function get genius():Agent { return _genius; }
		private var _genius:Agent;
		
		public function get age():uint { return _age; }
		private var _age:uint;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param type
		 * @param genius
		 * @param age
		 * @param bubbles
		 * @param cancelable
		 */
		public function GAEvent(type:String, genius:Agent = null, age:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			_genius = genius;
			_age    = age;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 自身のコピーを返す
		 * @return
		 */
		override public function clone():Event
		{
			return new GAEvent(type, _genius, _age, bubbles, cancelable);
		}
	}
}
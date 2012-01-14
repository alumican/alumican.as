package net.alumican.as3.algorithm.ga.events
{
	import flash.events.Event;
	import net.alumican.as3.algorithm.ga.Agent;
	import net.alumican.as3.algorithm.ga.Generation;
	
	/**
	 * HeredityEvent
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class HeredityEvent extends Event
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
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function HeredityEvent(type:String, gbubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 自身のコピーを返す
		 * @return
		 */
		override public function clone():Event
		{
			return new HeredityEvent(type, bubbles, cancelable);
		}
	}
}
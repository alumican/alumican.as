package net.alumican.as3.framework.progression4.events
{
	import flash.events.Event;
	
	/**
	 * ActionEvent
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class ActionEvent extends Event
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const START:String    = "onStart";
		static public const COMPLETE:String = "onComplete";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function ActionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 自身のコピーを返す
		 * @return
		 */
		override public function clone():Event
		{
			return new ActionEvent(type, bubbles, cancelable);
		}
	}
}
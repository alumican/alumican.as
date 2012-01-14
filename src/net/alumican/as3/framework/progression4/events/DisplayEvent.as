package net.alumican.as3.framework.progression4.events
{
	import flash.events.Event;
	
	/**
	 * DisplayEvent
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class DisplayEvent extends Event
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const SHOW_START:String    = "onShowStart";
		static public const SHOW_COMPLETE:String = "onShowComplete";
		static public const HIDE_START:String    = "onHideStart";
		static public const HIDE_COMPLETE:String = "onHideComplete";
		
		
		
		
		
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
		public function DisplayEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 自身のコピーを返す
		 * @return
		 */
		override public function clone():Event
		{
			return new DisplayEvent(type, bubbles, cancelable);
		}
	}
}
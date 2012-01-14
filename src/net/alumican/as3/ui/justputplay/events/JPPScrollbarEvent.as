package net.alumican.as3.ui.justputplay.events {
	
	import flash.events.Event;
	
	/**
	 * JPPScrollbarEvent
	 * <p>JPPScrollbar用のイベントです．</p>
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class JPPScrollbarEvent extends Event {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		/**
		 * <p>スクロール開始時に発行されるイベントです．</p>
		 */
		static public const SCROLL_START:String = "onScrollStart";
		
		/**
		 * <p>スクロール進捗時に発行されるイベントです．</p>
		 */
		static public const SCROLL_PROGRESS:String = "onScrollProgress";
		
		/**
		 * <p>スクロール完了時に発行されるイベントです．</p>
		 */
		static public const SCROLL_COMPLETE:String = "onScrollComplete";
		
		
		
		
		
		//--------------------------------------------------------------------------
		// VARIABLES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function JPPScrollbarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void {
			super(type, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * overrided clone method
		 * @return
		 */
		override public function clone():Event {
			return new JPPScrollbarEvent(type, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
	}
}
package net.alumican.as3.ui.justputplay.events {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * JPPMouseEvent.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class JPPMouseEvent extends MouseEvent {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		//RELEASE_OUTSIDE event
		static public const RELEASE_OUTSIDE:String = "onReleaseOutside";
		
		//DRAG_OVER event
		static public const DRAG_OVER:String       = "onDragOver";
		
		//DRAG_OUT event
		static public const DRAG_OUT:String        = "onDragOut";
		
		//like AS2 onRollOver event (exclusive with drag over event)
		static public const EX_ROLL_OVER:String    = "onExclusiveRollOver";
		
		//like AS2 onRollOut event (exclusive with drag out event)
		static public const EX_ROLL_OUT:String     = "onExclusiveRollOut";
		
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------
		
		//customable data
		private var _userData:*;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		//_userData
		public function get userData():* { return _userData; }
		public function set userData(data:*):void { _userData = data; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function JPPMouseEvent(type:String, userData:* = null, bubbles:Boolean = false, cancelable:Boolean = false):void {
			_userData = userData;
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
			return new JPPMouseEvent(type, userData, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
	}
}
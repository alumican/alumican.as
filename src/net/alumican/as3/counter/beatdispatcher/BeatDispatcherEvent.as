package net.alumican.as3.counter.beatdispatcher {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * BeatDispatcherEvent.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class BeatDispatcherEvent extends Event {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		//on measure event
		static public const MEASURE:String  = "onMeasure";
		
		//on beat event
		static public const BEAT:String = "onBeat";
		
		//on tick event
		static public const TICK:String = "onTick";
		
		//on start event
		static public const START:String  = "onStart";
		
		//on complete event
		static public const COMPLETE:String  = "onComplete";
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------
		
		//instance
		private var _dispatcher:BeatDispatcher;
		
		//status
		private var _currentMeasure:uint;
		private var _currentBeat:uint;
		private var _currentTick:uint;
		
		private var _currentPosition:uint;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GETTER/SETTER
		//--------------------------------------------------------------------------
		
		//instance
		public function get dispatcher():BeatDispatcher { return _dispatcher; }
		
		//status
		public function get currentMeasure():uint { return _currentMeasure; }
		public function get currentBeat():uint { return _currentBeat; }
		public function get currentTick():uint { return _currentTick; }
		
		public function get currentPosition():uint { return _currentPosition; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BeatDispatcherEvent(type:String, dispatcher:BeatDispatcher, currentMeasure:uint, currentBeat:uint, currentTick:uint, currentPosition:uint, bubbles:Boolean = false, cancelable:Boolean = false):void {
			_dispatcher      = dispatcher;
			
			_currentMeasure  = currentMeasure;
			_currentBeat     = currentBeat;
			_currentTick     = currentTick;
			
			_currentPosition = currentPosition;
			
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
			return new BeatDispatcherEvent(type, dispatcher, currentMeasure, currentBeat, currentTick, currentPosition, bubbles, cancelable);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
	}
}
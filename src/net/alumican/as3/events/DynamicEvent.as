package net.alumican.as3.events {
	
	import flash.events.Event;
	
	public class DynamicEvent extends Event {
		
		//User Data
		private var _data:*;
		public function get data():* { return _data; }
		public function set data(value:*):void { _data = value; }
		
		public function DynamicEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false):void {
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new DynamicEvent(type, data, bubbles, cancelable);
		}
	}
}
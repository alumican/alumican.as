package net.alumican.as3.ui.justputplay.buttons {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import net.alumican.as3.ui.justputplay.events.JPPMouseEvent;
	
	/**
	 * JPPBasicButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class JPPBasicButton extends MovieClip implements IJPPBasicButton {
		
		//--------------------------------------------------------------------------
		// KILL ALL EVENTS AUTOMATICALLY
		//--------------------------------------------------------------------------
		
		//if true, automatically kill all event listener at the same time of removed from stage
		private var _useAutoKillEvents:Boolean;
		
		public function get useAutoKillEvents():Boolean { return _useAutoKillEvents; }
		public function set useAutoKillEvents(value:Boolean):void { _useAutoKillEvents = value; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SWITCH BUTTON MODE PROPERTY AUTOMATICALLY
		//--------------------------------------------------------------------------
		
		//if true, automatically switch buttonMode property of hitArea in accordance with buttonEnabled
		private var _useAutoButtonMode:Boolean;
		
		public function get useAutoButtonMode():Boolean { return _useAutoButtonMode; }
		public function set useAutoButtonMode(value:Boolean):void {
			_useAutoButtonMode = value;
			if (_useAutoButtonMode) {
				hitArea.buttonMode = mouseEnabled;
			}
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CUSTOM HITAREA
		//--------------------------------------------------------------------------
		
		/*
		//refference of hitArea
		private var _hitArea:DisplayObject;
		
		public function get hitObject():DisplayObject { return _hitArea; }
		public function set hitObject(value:DisplayObject):void { _hitArea = value; }
		*/
		
		
		
		
		//--------------------------------------------------------------------------
		// ENABLED / DISABLED
		//--------------------------------------------------------------------------
		
		//enable/disable this and childrens
		public function set buttonEnabled(flag:Boolean):void {
			mouseEnabled  = flag;
			mouseChildren = flag;
			if (_useAutoButtonMode) {
				hitArea.buttonMode = flag;
			}
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// MOUSE STATUS
		//--------------------------------------------------------------------------
		
		//status of rollOver or not
		private var _isRollOver:Boolean;
		
		//status of press or not
		private var _isPress:Boolean;
		
		public function get isRollOver():Boolean { return _isRollOver; }
		public function get isPress():Boolean    { return _isPress;    }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF BUTTON EVENT
		//--------------------------------------------------------------------------
		
		//functions
		private var _onClick:Function;
		private var _onDoubleClick:Function;
		private var _onRollOver:Function;
		private var _onRollOut:Function;
		private var _onMouseDown:Function;
		private var _onMouseUp:Function;
		private var _onMouseMove:Function;
		private var _onMouseOver:Function;
		private var _onMouseOut:Function;
		private var _onMouseWheel:Function;
		private var _onDragOver:Function;
		private var _onDragOut:Function;
		private var _onExRollOver:Function;
		private var _onExRollOut:Function;
		private var _onReleaseOutside:Function;
		
		//getter/setter
		public function get onClick():Function                { return _onClick; }
		public function set onClick(f:Function):void          { _presetAddShortcut(MouseEvent.CLICK             , "_onClick"         , f); }
		
		public function get onDoubleClick():Function          { return _onDoubleClick; }
		public function set onDoubleClick(f:Function):void    { doubleClickEnabled = (f == null) ? false : true;
		                                                        _presetAddShortcut(MouseEvent.DOUBLE_CLICK       , "_onDoubleClick"   , f); }
		
		public function get onRollOver():Function             { return _onRollOver; }
		public function set onRollOver(f:Function):void       { _presetAddShortcut(MouseEvent.ROLL_OVER         , "_onRollOver"      , f); }
		
		public function get onRollOut():Function              { return _onRollOut; }
		public function set onRollOut(f:Function):void        { _presetAddShortcut(MouseEvent.ROLL_OUT          , "_onRollOut"       , f); }
		
		public function get onMouseDown():Function            { return _onMouseDown; }
		public function set onMouseDown(f:Function):void      { _presetAddShortcut(MouseEvent.MOUSE_DOWN        , "_onMouseDown"     , f); }
		
		public function get onMouseUp():Function              { return _onMouseUp; }
		public function set onMouseUp(f:Function):void        { _presetAddShortcut(MouseEvent.MOUSE_UP          , "_onMouseUp"       , f); }
		
		public function get onMouseMove():Function            { return _onMouseMove; }
		public function set onMouseMove(f:Function):void      { _presetAddShortcut(MouseEvent.MOUSE_MOVE        , "_onMouseMove"     , f); }
		
		public function get onMouseOver():Function            { return _onMouseOver; }
		public function set onMouseOver(f:Function):void      { _presetAddShortcut(MouseEvent.MOUSE_OVER        , "_onMouseOver"     , f); }
		
		public function get onMouseOut():Function             { return _onMouseOut; }
		public function set onMouseOut(f:Function):void       { _presetAddShortcut(MouseEvent.MOUSE_OUT         , "_onMouseOut"      , f); }
		
		public function get onMouseWheel():Function           { return _onMouseWheel; }
		public function set onMouseWheel(f:Function):void     { _presetAddShortcut(MouseEvent.MOUSE_WHEEL       , "_onMouseWheel"    , f); }
		
		public function get onDragOver():Function             { return _onDragOver; }
		public function set onDragOver(f:Function):void       { _presetAddShortcut(JPPMouseEvent.DRAG_OVER      , "_onDragOver"      , f); }
		
		public function get onDragOut():Function              { return _onDragOut; }
		public function set onDragOut(f:Function):void        { _presetAddShortcut(JPPMouseEvent.DRAG_OUT       , "_onDragOut"       , f); }
		
		public function get onExRollOver():Function           { return _onExRollOver; }
		public function set onExRollOver(f:Function):void     { _presetAddShortcut(JPPMouseEvent.EX_ROLL_OVER   , "_onExRollOver"    , f); }
		
		public function get onExRollOut():Function            { return _onExRollOut; }
		public function set onExRollOut(f:Function):void      { _presetAddShortcut(JPPMouseEvent.EX_ROLL_OUT    , "_onExRollOut"     , f); }
		
		public function get onReleaseOutside():Function       { return _onReleaseOutside; }
		public function set onReleaseOutside(f:Function):void { _presetAddShortcut(JPPMouseEvent.RELEASE_OUTSIDE, "_onReleaseOutside", f); }
		
		/**
		 * override shortcut function
		 * @param	type
		 * @param	newFunc
		 * @param	oldFunc
		 */
		private function _presetAddShortcut(type:String, propName:String, f:Function):void {
			var prop:Function = this[propName];
			if (prop != null) {
				removeEventListener(type, prop);
			}
			if (f != null) {
				addEventListener(type, f);
			}
			this[propName] = f;
		}
		
		/**
		 * remobe shortcut function
		 * @param	type
		 * @param	f
		 */
		/*
		private function _presetRemoveShortcut(type:String, f:Function):void {
			if (f != null) {
				removeEventListener(type, f);
			}
		}
		*/
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF ADDED / REMOVED TO STAGE EVENT
		//--------------------------------------------------------------------------
		
		//called when Event.ADDED_TO_STAGE
		private var _onInit:Function;
		
		//called when Event.REMOVED_FROM_STAGE
		private var _onRemoved:Function;
		
		//getter/setter
		public function get onInit():Function          { return _onInit;    }
		public function set onInit(f:Function):void    { _onInit = f;       }
		
		public function get onRemoved():Function       { return _onRemoved; }
		public function set onRemoved(f:Function):void { _onRemoved = f;    }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// THIS DISPLAY OBJECT CONTAINER FOR ACCESS FROM INTERFACE
		//--------------------------------------------------------------------------
		
		//get this as DisplayObjectContainer
		public function get container():DisplayObjectContainer { return this; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------
		
		//refference of stage
		private var _stage:Stage;
		
		//stacking all added event handlers
		private var _eventHandlerStack:Dictionary;		
		
		
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GENERAL GETTER / SETTER
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function JPPBasicButton():void {
			super();
			
			_isRollOver = false;
			_isPress = false;
			
			_useAutoKillEvents = false;
			
			_useAutoButtonMode = true;
			
			_eventHandlerStack = new Dictionary(true);
			
			buttonMode = true;
			
			hitArea = this;
			
			addEventListener(Event.ADDED_TO_STAGE, _presetAddedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _presetRemovedFromStageHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------
		
		/**
		 * overrided addEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			if (listener == null) {
				_traceWarning(new Error());
				return;
			}
			
			try {
				//_addEventListenerToTarget(_hitArea, type, listener, useCapture, priority, useWeakReference);
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			} catch (e) {
				_traceException(new Error(e));
				return;
			}
			//trace(this, type);
			
			//stack event handler
			if (_eventHandlerStack[type] == null) {
				_eventHandlerStack[type] = new Dictionary(true);
			}
			_eventHandlerStack[type][listener] = { type:type, listener:listener, useCapture:useCapture, priority:priority, useWeakReference:useWeakReference };
		}
		
		/**
		 * overrided removeEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (listener == null) {
				_traceWarning(new Error());
				return;
			}
			
			try {
				//_removeEventListenerFromTarget(_hitArea, type, listener, useCapture);
				super.removeEventListener(type, listener, useCapture);
			} catch (e) {
				_traceException(new Error(e));
				return;
			}
			
			//unstack event handler
			if(_eventHandlerStack[type] != null) {
				delete _eventHandlerStack[type][listener];
			}
			var c:uint = 0;
			for (var name:String in _eventHandlerStack[type]) {
				++c;
			}
			if (c == 0) {
				delete _eventHandlerStack[type];
			}
			//for (var name:String in _eventHandlerStack) trace(name + " : "  + _eventHandlerStack[name]);
			
		}
		
		/**
		 * remove all event listener
		 */
		public function kill(stageObject:Stage = null):void {
			
			var stage:Stage = stageObject != null ? stageObject : this.stage;
			
			buttonEnabled = false;
			
			//kill preset event handler
			for (var type:String in _eventHandlerStack) {
				for each (var data:Object in _eventHandlerStack[type]) {
					//trace(this, type);
					try {
						//_removeEventListenerFromTarget(_hitArea, type, data.listener, data.useCapture);
						super.removeEventListener(type, data.listener, data.useCapture);
					} catch (e) {
						_traceException(new Error(e));
					}
					
					delete _eventHandlerStack[type].type;
					delete _eventHandlerStack[type].listener;
					delete _eventHandlerStack[type].useCapture;
					delete _eventHandlerStack[type].priority;
					delete _eventHandlerStack[type].useWeakReference;
				}
				
				delete _eventHandlerStack[type];
				
				/*
				for (var listener:String in _eventHandlerStack[type]) {
					trace(type + " : " + listener);
					removeEventListener(type, _eventHandlerStack[type][listener]);
				}
				*/
			}
			
			//メモリリーク実験
			//_eventHandlerStack = new Dictionary(true);
			
			try {
				stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
			} catch (e) {
				_traceException(new Error(e));
			}
			
			
			
			
			
			//メモリリーク実験
			
			//kill preset event handler
			removeEventListener(Event.ADDED_TO_STAGE, _presetAddedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, _presetRemovedFromStageHandler);
			
			removeEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			
			_onClick = null;
			_onDoubleClick = null;
			_onRollOver = null;
			_onRollOut = null;
			_onMouseDown = null;
			_onMouseUp = null;
			_onMouseMove = null;
			_onMouseOver = null;
			_onMouseOut = null;
			_onMouseWheel = null;
			_onDragOver = null;
			_onDragOut = null;
			_onExRollOver = null;
			_onExRollOut = null;
			_onReleaseOutside = null;
			
			_onInit = null;
			_onRemoved = null;
			_stage = null;
			_eventHandlerStack = null;
		}
		
		/**
		 * addEventListener to target DisplayObject
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		/*
		private function _addEventListenerToTarget(target:DisplayObject, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			if (target === this) {
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			} else {
				target.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		*/
		
		/**
		 * removeEventListener from target DisplayObject
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		/*
		private function _removeEventListenerFromTarget(target:DisplayObject, type:String, listener:Function, useCapture:Boolean = false):void {
			if (target === this) {
				super.removeEventListener(type, listener, useCapture);
			} else {
				target.removeEventListener(type, listener, useCapture);
			}
		}
		*/
		
		/**
		 * trace warning
		 * @param	e
		 */
		private function _traceWarning(e:Error):void {
			trace("@WARNING : " + e.message + "\n@" + e.getStackTrace());
		}
		
		/**
		 * trace exception
		 * @param	e
		 */
		private function _traceException(e:Error):void {
			trace("@EXCEPTION : " + e.message + "\n@" + e.getStackTrace());
		}
		
		/**
		 * translocate event listeners from src to dst
		 * @param	src
		 * @param	dst
		 */
		/*
		private function _translocateEventListener(src:DisplayObject, dst:DisplayObject):void {
			for (var type:String in _eventHandlerStack) {
				for each (var data:Object in _eventHandlerStack[type]) {
					trace(_hitArea, type);
					
					//removeEventListener from src
					try {
						_removeEventListenerFromTarget(src, type, data.listener, data.useCapture);
					} catch (e) {
						_traceException(new Error(e));
					}
					
					//addEventListener from dst
					try {
						_addEventListenerToTarget(dst, type, data.listener, data.useCapture, data.priority, data.useWeakReference);
					} catch (e) {
						_traceException(new Error(e));
					}
				}
			}
		}
		*/
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		
		/**
		 * roll over event
		 * @param	e
		 */
		private function _presetRollOverHandler(e:MouseEvent):void {
			//update isRollOver status
			_isRollOver = true;
			
			if (e.buttonDown) {
				//for drag over
				dispatchEvent(new JPPMouseEvent(JPPMouseEvent.DRAG_OVER));
				
			} else {
				//for roll over event like AS2
				dispatchEvent(new JPPMouseEvent(JPPMouseEvent.EX_ROLL_OVER));
			}
		}
		
		/**
		 * roll out event
		 * @param	e
		 */
		private function _presetRollOutHandler(e:MouseEvent):void {
			//update isRollOver status
			_isRollOver = false;
			
			if (e.buttonDown) {
				//for drag out
				dispatchEvent(new JPPMouseEvent(JPPMouseEvent.DRAG_OUT));
				
			} else {
				//for roll over event like AS2
				dispatchEvent(new JPPMouseEvent(JPPMouseEvent.EX_ROLL_OUT));
			}
		}
		
		/**
		 * mouse down event
		 * @param	e
		 */
		private function _presetMouseDownHandler(e:MouseEvent):void {
			//update isPress status
			_isPress = true;
			
			//for release outside
			stage.addEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
		}
		
		/**
		 * mouse up on stage event
		 * @param	e
		 */
		private function _presetStageMouseUpHandler(e:MouseEvent):void {
			try {
				stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
			} catch (e) {
				_traceException(new Error(e));
			}
			
			//update isPress status
			_isPress = false;
			
			//for release outside
			if (!_isRollOver) {
				dispatchEvent(new JPPMouseEvent(JPPMouseEvent.RELEASE_OUTSIDE));
			}
		}
		
		/**
		 * added to stage event
		 * @param	e
		 */
		private function _presetAddedToStageHandler(e:Event):void {
			//removeEventListener(Event.ADDED_TO_STAGE, _presetAddedToStageHandler);
			
			//get stage refference
			_stage = stage;
			
			//for _isRollOver status
			addEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			
			//for _isPress status
			addEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			
			//execute shortcut function
			if (_onInit != null) {
				_onInit(e);
			}
			
		}
		
		/**
		 * removed from stage event
		 * @param	e
		 */
		private function _presetRemovedFromStageHandler(e:Event):void {
			//removeEventListener(Event.REMOVED_FROM_STAGE, _presetRemovedFromStageHandler);
			//removeEventListener(Event.ADDED_TO_STAGE, _presetAddedToStageHandler);
			
			_isRollOver = false;
			_isPress    = false;
			
			//kill preset event listener
			removeEventListener(MouseEvent.ROLL_OVER, _presetRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, _presetRollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, _presetMouseDownHandler);
			
			try {
				stage.removeEventListener(MouseEvent.MOUSE_UP, _presetStageMouseUpHandler);
			} catch (e) {
				_traceException(new Error(e));
			}
			
			//kill all event listener
			if (_useAutoKillEvents) {
				kill();
			}
			
			//execute shortcut function
			if (_onRemoved != null) {
				_onRemoved(e);
			}
		}
	}
}
package net.alumican.as3.ui.justputplay.buttons {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import jp.nium.impls.IDisplayObject;
	
	/**
	 * IJPPBasicButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public interface IJPPBasicButton extends IDisplayObject {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GENERAL GETTER / SETTER
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// KILL ALL EVENTS AUTOMATICALLY
		//--------------------------------------------------------------------------
		
		//if true, automatically kill all event listener at the same time of removed from stage
		function get useAutoKillEvents():Boolean;
		function set useAutoKillEvents(value:Boolean):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SWITCH BUTTON MODE PROPERTY AUTOMATICALLY
		//--------------------------------------------------------------------------
		
		//if true, automatically switch buttonMode property of hitArea in accordance with buttonEnabled
		function get useAutoButtonMode():Boolean;
		function set useAutoButtonMode(value:Boolean):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CUSTOM HITAREA
		//--------------------------------------------------------------------------
		
		//refference of hitArea
		//function get hitArea():Sprite;
		//function set hitArea(value:Sprite):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// ENABLED / DISABLED
		//--------------------------------------------------------------------------
		
		//enable/disable this and childrens
		function set buttonEnabled(flag:Boolean):void ;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// MOUSE STATUS
		//--------------------------------------------------------------------------
		
		//status of rollOver or not
		function get isRollOver():Boolean;
		
		//status of press or not
		function get isPress():Boolean;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF BUTTON EVENT
		//--------------------------------------------------------------------------
		
		//short cut functions
		function get onClick():Function;
		function set onClick(f:Function):void;
		
		function get onDoubleClick():Function;
		function set onDoubleClick(f:Function):void;
		
		function get onRollOver():Function;
		function set onRollOver(f:Function):void;
		
		function get onRollOut():Function;
		function set onRollOut(f:Function):void;
		
		function get onMouseDown():Function;
		function set onMouseDown(f:Function):void;
		
		function get onMouseUp():Function;
		function set onMouseUp(f:Function):void;
		
		function get onMouseMove():Function;
		function set onMouseMove(f:Function):void;
		
		function get onMouseOver():Function;
		function set onMouseOver(f:Function):void;
		
		function get onMouseOut():Function;
		function set onMouseOut(f:Function):void;
		
		function get onMouseWheel():Function;
		function set onMouseWheel(f:Function):void;
		
		function get onDragOver():Function;
		function set onDragOver(f:Function):void;
		
		function get onDragOut():Function;
		function set onDragOut(f:Function):void;
		
		function get onExRollOver():Function;
		function set onExRollOver(f:Function):void;
		
		function get onExRollOut():Function;
		function set onExRollOut(f:Function):void;
		
		function get onReleaseOutside():Function;
		function set onReleaseOutside(f:Function):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF ADDED / REMOVED TO STAGE EVENT
		//--------------------------------------------------------------------------
		
		//called when Event.ADDED_TO_STAGE
		function get onInit():Function;
		function set onInit(f:Function):void;
		
		//called when Event.REMOVED_FROM_STAGE
		function get onRemoved():Function;
		function set onRemoved(f:Function):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GET DISPLAY OBJECT CONTAINER FOR ACCESS FROM INTERFACE
		//--------------------------------------------------------------------------
		
		//get this as DisplayObjectContainer
		function get container():DisplayObjectContainer;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		
		
		
		
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
		//function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		
		/**
		 * overrided removeEventListener
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		//function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
		
		/**
		 * remove all event listener
		 */
		function kill(stageObject:Stage = null):void;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
	}
}
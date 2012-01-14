package net.alumican.as3.ui.justputplay.buttons {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.alumican.as3.justputplay.buttons.JPPBasicButton;
	import net.alumican.as3.justputplay.events.JPPMouseEvent;
	
	/**
	 * JPPSwitchFrameButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class JPPLabelButton extends JPPBasicButton {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------		
		
		//parameters
		private var _labelRollOver:String;
		private var _labelRollOut:String;
		private var _labelUseGotoAndPlay:Boolean;
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GENERAL GETTER / SETTER
		//--------------------------------------------------------------------------
		
		//_labelRollOver
		public function get labelRollOver():String { return _labelRollOver; }
		public function set labelRollOver(value:String):void { _labelRollOver = value; }
		
		//_labelRollOut
		public function get labelRollOut():String { return _labelRollOut; }
		public function set labelRollOut(value:String):void { _labelRollOut = value; }
		
		//_labelUseGotoAndPlay
		public function get labelUseGotoAndPlay():Boolean { return _labelUseGotoAndPlay; }
		public function set labelUseGotoAndPlay(value:Boolean):void { _labelUseGotoAndPlay = value; }
		
		
		
		
		
		//--------------------------------------------------------------------------
		// ENABLED / DISABLED
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// MOUSE STATUS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF BUTTON EVENT
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// SHORTCUT FUNCTIONS OF ADDED / REMOVED TO STAGE EVENT
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// CONSTRUCTOR
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function JPPLabelButton():void {
			super();
			
			//初期パラメータ
			_labelRollOver       = "rollOver";
			_labelRollOut        = "rollOut";
			_labelUseGotoAndPlay = false;
			
			//初期表示設定
			gotoAndStop(_labelRollOut);
			
			addEventListener(MouseEvent.ROLL_OVER, _effectRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT , _effectRollOutHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// METHODS
		//--------------------------------------------------------------------------		
		
		/**
		 * remove all event listener
		 */
		override public function kill():void {
			super.kill();
			
			removeEventListener(MouseEvent.ROLL_OVER, _effectRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT , _effectRollOutHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		/**
		 * ロールオーバー時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOverHandler(e:MouseEvent):void {
			//フレーム移動
			(_labelUseGotoAndPlay) ? gotoAndPlay(_labelRollOver) : gotoAndStop(_labelRollOver);
		}
		
		/**
		 * ロールアウト時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOutHandler(e:MouseEvent):void {
			//フレーム移動
			(_labelUseGotoAndPlay) ? gotoAndPlay(_labelRollOut) : gotoAndStop(_labelRollOut);
		}
	}
}
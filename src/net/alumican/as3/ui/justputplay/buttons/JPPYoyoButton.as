package net.alumican.as3.ui.justputplay.buttons {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.alumican.as3.justputplay.buttons.JPPBasicButton;
	import net.alumican.as3.justputplay.events.JPPMouseEvent;
	
	/**
	 * JPPYoyoButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class JPPYoyoButton extends JPPBasicButton {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------		
		
		//parameters
		private var _yoyoFrameFrom:uint;
		private var _yoyoFrameTo:uint;
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GENERAL GETTER / SETTER
		//--------------------------------------------------------------------------
		
		//_yoyoFrameFrom
		public function get yoyoFrameFrom():uint { return _yoyoFrameFrom; }
		public function set yoyoFrameFrom(value:uint):void {
			_yoyoFrameFrom = (value < 1          ) ? 1 :
			                 (value > totalFrames) ? totalFrames :
							                         value;
		}
		
		//_yoyoFrameTo
		public function get yoyoFrameTo():uint { return _yoyoFrameTo; }
		public function set yoyoFrameTo(value:uint):void {
			_yoyoFrameTo = (value < 1          ) ? 1 :
			               (value > totalFrames) ? totalFrames :
						                           value;
		}
		
		
		
		
		
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
		public function JPPYoyoButton():void {
			super();
			
			//初期パラメータ
			_yoyoFrameFrom = 1;
			_yoyoFrameTo   = totalFrames;
			
			//初期表示設定
			stop();
			
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
			removeEventListener(Event.ENTER_FRAME   , _effectRollOverEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME   , _effectRollOutEnterFrameHandler);
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		/**
		 * ロールオーバー時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOverHandler(e:MouseEvent):void {
			
			//毎フレームタイムラインを進めるためのイベントハンドラを登録する
			addEventListener(Event.ENTER_FRAME, _effectRollOverEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, _effectRollOutEnterFrameHandler);
		}
		
		/**
		 * ロールアウト時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOutHandler(e:MouseEvent):void {
			
			//毎フレームタイムラインを戻すためのイベントハンドラを登録する
			addEventListener(Event.ENTER_FRAME, _effectRollOutEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, _effectRollOverEnterFrameHandler); ;
		}
		
		/**
		 * ロールオーバー用EnterFrameイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOverEnterFrameHandler(e:Event):void {
			//タイムラインを進める
			nextFrame();
			if (currentFrame >= _yoyoFrameTo) {
				removeEventListener(Event.ENTER_FRAME, _effectRollOverEnterFrameHandler);
			}
		}
		
		/**
		 * ロールアウト用EnterFrameイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOutEnterFrameHandler(e:Event):void {
			//タイムラインを戻す
			prevFrame();
			if (currentFrame <= _yoyoFrameFrom) {
				removeEventListener(Event.ENTER_FRAME, _effectRollOutEnterFrameHandler);
			}
		}
	}
}
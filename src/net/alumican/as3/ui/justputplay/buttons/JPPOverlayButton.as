package net.alumican.as3.ui.justputplay.buttons {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import caurina.transitions.Tweener;
	import net.alumican.as3.justputplay.buttons.JPPBasicButton;
	import net.alumican.as3.justputplay.events.JPPMouseEvent;
	
	/**
	 * JPPOverlayButton.as
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class JPPOverlayButton extends JPPBasicButton {
		
		//--------------------------------------------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------------------------------------------
		
		
		
		
		
		//--------------------------------------------------------------------------
		// variable
		//--------------------------------------------------------------------------		
		
		//transition parameters
		private var _overlayTarget:DisplayObject;
		private var _overlayAlphaFrom:Number;
		private var _overlayAlphaTo:Number;
		private var _overlayTime:Number;
		private var _overlayDelay:Number;
		private var _overlayTransition:String;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// STAGE INSTANCES
		//--------------------------------------------------------------------------
		
		//オーバーレイ表示用のDisplayObject
		public var overlay:DisplayObject;
		
		
		
		
		
		//--------------------------------------------------------------------------
		// GENERAL GETTER / SETTER
		//--------------------------------------------------------------------------
		
		//_overlayTarget
		public function get overlayTarget():DisplayObject { return _overlayTarget; }
		public function set overlayTarget(value:DisplayObject):void { _overlayTarget = value; }
		
		//_overlayAlphaFrom
		public function get overlayAlphaFrom():Number { return _overlayAlphaFrom; }
		public function set overlayAlphaFrom(value:Number):void { _overlayAlphaFrom = value; }
		
		//_overlayAlphaTo
		public function get overlayAlphaTo():Number { return _overlayAlphaTo; }
		public function set overlayAlphaTo(value:Number):void { _overlayAlphaTo = value; }
		
		//_overlayTime
		public function get overlayTime():Number { return _overlayTime; }
		public function set overlayTime(value:Number):void { _overlayTime = value; }
		
		//_overlayDelay
		public function get overlayDelay():Number { return _overlayDelay; }
		public function set overlayDelay(value:Number):void { _overlayDelay = value; }
		
		//_overlayTransition
		public function get overlayTransition():String { return _overlayTransition; }
		public function set overlayTransition(value:String):void { _overlayTransition = value; }
		
		
		
		
		
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
		public function JPPOverlayButton():void {
			super();
			
			//初期パラメータ
			_overlayTarget     = overlay;
			_overlayAlphaFrom  = 0.0;
			_overlayAlphaTo    = 1.0;
			_overlayTime       = 0.5;
			_overlayDelay      = 0.0;
			_overlayTransition = "easeOutQuart";
			
			//初期表示設定
			hideOverlay(false);
			
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
		
		/**
		 * オーバーレイを表示する
		 * @param	useTween
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	alphaTo
		 * @param	target
		 */
		public function showOverlay(useTween:Boolean = true, time:Number = undefined, delay:Number = undefined, transition:String = null, alpha:Number = undefined, target:DisplayObject = null):void {
			time       = time       || _overlayTime;
			delay      = delay      || _overlayDelay;
			transition = transition || _overlayTransition;
			alpha      = alpha      || _overlayAlphaTo;
			target     = target     || _overlayTarget;
			
			Tweener.removeTweens(target);
			target.visible = true;
			
			if (useTween) {
				//アニメーション有り
				Tweener.addTween(target, {
					alpha:alpha,
					time:time,
					delay:delay,
					transition:transition
				});
				
			} else {
				//アニメーション無し
				target.alpha = alpha;
			}
		}
		
		/**
		 * オーバーレイを非表示にする
		 * @param	useTween
		 * @param	time
		 * @param	delay
		 * @param	transition
		 * @param	alphaTo
		 * @param	target
		 */
		public function hideOverlay(useTween:Boolean = true, time:Number = undefined, delay:Number = undefined, transition:String = null, alpha:Number = undefined, target:DisplayObject = null):void {
			time       = time       || _overlayTime;
			delay      = delay      || _overlayDelay;
			transition = transition || _overlayTransition;
			alpha      = alpha      || _overlayAlphaFrom;
			target     = target     || _overlayTarget;
			
			Tweener.removeTweens(target);
			target.visible = true;
			
			if (useTween) {
				//アニメーション有り
				Tweener.addTween(target, {
					alpha:alpha,
					time:time,
					delay:delay,
					transition:transition,
					onComplete:function():void {
						if (alpha == 0) {
							target.visible = false;
						}
					}
				});
				
			} else {
				//アニメーション無し
				target.alpha = alpha;
				if (alpha == 0) {
					target.visible = false;
				}
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		// EVENT HANDLER
		//--------------------------------------------------------------------------
		/**
		 * ロールオーバー時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOverHandler(e:MouseEvent):void {
			//オーバーレイを表示する
			showOverlay();
		}
		
		/**
		 * ロールアウト時に呼び出されるイベントハンドラ
		 * @param	e
		 */
		private function _effectRollOutHandler(e:MouseEvent):void {
			//オーバーレイを非表示にする
			hideOverlay();
		}
	}
}
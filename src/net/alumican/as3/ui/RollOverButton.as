package net.alumican.as3.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.alumican.as3.ui.justputplay.buttons.JPPBasicButton;
	
	/**
	 * RollOverButton
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class RollOverButton extends MovieClip
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * イベントハンドラ
		 */
		public function get clickEvent():Function { return __clickEvent || _clickEvent; }
		public function set clickEvent(value:Function):void { __clickEvent = value; }
		private var __clickEvent:Function;
		
		public function get rollOverEvent():Function { return __rollOverEvent || _rollOverEvent; }
		public function set rollOverEvent(value:Function):void { __rollOverEvent = value; }
		private var __rollOverEvent:Function;
		
		public function get rollOutEvent():Function { return __rollOutEvent || _rollOutEvent; }
		public function set rollOutEvent(value:Function):void { __rollOutEvent = value; }
		private var __rollOutEvent:Function;
		
		public function get rollOverEffect():Function { return __rollOverEffect || _rollOverEffect; }
		public function set rollOverEffect(value:Function):void { __rollOverEffect = value; }
		private var __rollOverEffect:Function;
		
		public function get rollOutEffect():Function { return __rollOutEffect || _rollOutEffect; }
		public function set rollOutEffect(value:Function):void { __rollOutEffect = value; }
		private var __rollOutEffect:Function;
		
		public function get selectEffect():Function { return __selectEffect || _selectEffect; }
		public function set selectEffect(value:Function):void { __selectEffect = value; }
		private var __selectEffect:Function;
		
		public function get unselectEffect():Function { return __unselectEffect || _unselectEffect; }
		public function set unselectEffect(value:Function):void { __unselectEffect = value; }
		private var __unselectEffect:Function;
		
		/**
		 * ロールオーバー中であればtrue
		 */
		public function get isRollOver():Boolean { return _isRollOver; }
		private var _isRollOver:Boolean;
		
		/**
		 * 選択中であればtrue
		 */
		public function get isSelected():Boolean { return _isSelected; }
		private var _isSelected:Boolean;
		
		/**
		 * ボタン領域
		 */
		public function get area():JPPBasicButton { return _area; }
		public function set area(value:JPPBasicButton):void
		{
			_killButtonArea();
			_area = value;
			_resisterButtonArea();
		}
		private var _area:JPPBasicButton;
		
		/**
		 * ボタンの有効/無効を切り替える
		 */
		public function set buttonEnabled(value:Boolean):void
		{
			_buttonEnabled = value;
			if (_area) _area.buttonEnabled = _buttonEnabled;
		}
		private var _buttonEnabled:Boolean;
		
		/**
		 * タブストップの有効/無効を切り替える
		 */
		/*
		public function set tabEnabled(value:Boolean):void
		{
			_tabEnabled = value;
			if (_area) _area.tabEnabled = _tabEnabled;
		}
		*/
		private var _tabEnabled:Boolean = false;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function RollOverButton():void 
		{
			_buttonEnabled = true;
			_tabEnabled    = false;
			_isRollOver    = false;
			_isSelected    = false;
			
			rollOutEffect(false);
			unselectEffect(false);
		}
		
		/**
		 * 廃棄する
		 */
		public function dispose():void
		{
			__clickEvent = null;
			__rollOverEvent = null;
			__rollOutEvent = null;
			__rollOverEffect = null;
			__rollOutEffect = null;
			__selectEffect = null;
			__unselectEffect = null;
			_isRollOver = false;
			_isSelected = false;
			
			_killButtonArea();
		}
		
		/**
		 * 選択
		 * @param	useTransition
		 */
		public function select(useTransition:Boolean = true):void
		{
			if (_isSelected) return;
			_isSelected = true;
			rollOutEffect();
			selectEffect();
		}
		
		/**
		 * 非選択
		 * @param	useTransition
		 */
		public function unselect(useTransition:Boolean = true):void
		{
			if (!_isSelected) return;
			_isSelected = false;
			unselectEffect();
			if (_isRollOver) rollOverEffect();
		}
		
		/**
		 * クリック時イベント(オーバーライド用)
		 * @param	e
		 */
		protected function _clickEvent(e:MouseEvent):void
		{
		}
		
		/**
		 * ロールオーバー時イベント(オーバーライド用)
		 * @param	e
		 */
		protected function _rollOverEvent(e:MouseEvent):void
		{
		}
		
		/**
		 * ロールアウト時イベント(オーバーライド用)
		 * @param	e
		 */
		protected function _rollOutEvent(e:MouseEvent):void
		{
		}
		
		/**
		 * 選択時演出(オーバーライド用)
		 * @param	useTransition
		 */
		protected function _selectEffect(useTransition:Boolean = true):void
		{
		}
		
		/**
		 * 非選択時演出(オーバーライド用)
		 * @param	useTransition
		 */
		protected function _unselectEffect(useTransition:Boolean = true):void
		{
		}
		
		/**
		 * ロールオーバー時演出(オーバーライド用)
		 * @param	useTransition
		 */
		protected function _rollOverEffect(useTransition:Boolean = true):void
		{
		}
		
		/**
		 * ロールアウト時演出(オーバーライド用)
		 * @param	useTransition
		 */
		protected function _rollOutEffect(useTransition:Boolean = true):void
		{
		}
		
		/**
		 * ボタンエリアを登録する
		 */
		private function _resisterButtonArea():void
		{
			if (!_area) return;
			_area.onClick       = _preClickHandler;
			_area.onRollOver    = _preRollOverHandler;
			_area.onRollOut     = _preRollOutHandler;
			_area.tabEnabled    = _tabEnabled;
			_area.buttonEnabled = _buttonEnabled;
		}
		
		/**
		 * ボタンエリアを破棄する
		 */
		private function _killButtonArea():void
		{
			if (!_area) return;
			_area.onClick    = null;
			_area.onRollOver = null;
			_area.onRollOut  = null;
			_area.kill();
		}
		
		
		
		
		
		//----------------------------------------
		//EVENT HANDLERS
		
		/**
		 * クリックハンドラ
		 * @param	e
		 */
		protected function _preClickHandler(e:MouseEvent):void
		{
			clickEvent(e);
		}
		
		/**
		 * ロールオーバーハンドラ
		 * @param	e
		 */
		protected function _preRollOverHandler(e:MouseEvent):void
		{
			_isRollOver = true;
			rollOverEvent(e);
			if (_isSelected) return;
			rollOverEffect(true);
		}
		
		/**
		 * ロールアウトハンドラ
		 * @param	e
		 */
		protected function _preRollOutHandler(e:MouseEvent):void
		{
			_isRollOver = false;
			rollOutEvent(e);
			if (_isSelected) return;
			rollOutEffect(true);
		}
	}
}
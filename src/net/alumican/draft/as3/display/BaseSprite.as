package study_teaser.display.common
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 一般的なSprite
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class BaseSprite extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 現在表示中ならtrue
		 */
		public function get isShowing():Boolean { return _isShowing; }
		private var _isShowing:Boolean;
		
		public function get isShowTransition():Boolean { return _isShowTransition; }
		private var _isShowTransition:Boolean;
		
		public function get isHideTransition():Boolean { return _isHideTransition; }
		private var _isHideTransition:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function BaseSprite():void
		{
			//初期表示設定
			_isShowing = true;
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		
		
		
		
		/**
		 * 非表示処理
		 * @param	useTween
		 */
		protected function _showTransition(notifyComplete:Function, useTween:Boolean = true):void
		{
			visible = true;
			notifyComplete();
		}
		
		/**
		 * 非表示処理
		 * @param	useTween
		 */
		protected function _hideTransition(notifyComplete:Function, useTween:Boolean = true):void
		{
			visible = false;
			notifyComplete();
		}
		
		/**
		 * リサイズ処理
		 * @param	useTween
		 */
		protected function _resizeTransition(stage:Stage, isInit:Boolean):void
		{
		}
		
		
		
		
		
		/**
		 * 表示する
		 * @param	useTween
		 */
		public function show(notifyComplete:Function = null, useTween:Boolean = true):void
		{
			if (_isShowing) return;
			_isShowing = true;
			_isShowTransition = true;
			
			function $complete():void
			{
				_isShowTransition = false;
				if (notifyComplete != null) notifyComplete();
			}
			
			//表示モーションの開始
			_showTransition($complete, useTween);
			
			//リサイズ
			resize(stage, false);
		}
		
		/**
		 * 非表示にする
		 * @param	useTween
		 */
		public function hide(notifyComplete:Function = null, useTween:Boolean = true):void
		{
			if (!_isShowing) return;
			_isShowing = false;
			_isHideTransition = true;
			
			function $complete():void
			{
				_isHideTransition = false;
				if (notifyComplete != null) notifyComplete();
			}
			
			//非表示モーションの開始
			_hideTransition($complete, useTween);
		}
		
		/**
		 * リサイズ関数
		 * @param	stage
		 * @param	isInit
		 */
		public function resize(stage:Stage, isInit:Boolean):void
		{
			if (!_isShowing && !_isHideTransition) return;
			
			_resizeTransition(stage, isInit);
		}
		
		
		
		
		
		/**
		 * ステージへの追加ハンドラ
		 * @param	e
		 */
		private function _addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			//初期表示設定
			//_isShowing = true;
			//hide(null, false);
		}
	}
}
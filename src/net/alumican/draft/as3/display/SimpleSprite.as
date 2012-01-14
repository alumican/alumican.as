package net.alumican.as3.display
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 一般的なSprite
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class SimpleSprite extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 現在表示中ならtrue
		 */
		protected var _isShowing:Boolean;
		
		/**
		 * ステージへの参照
		 */
		protected var _stage:Stage;
		
		/**
		 * 初期状態で表示状態になっている場合はtrue
		 */
		private var _initVisible:Boolean;
		
		/**
		 * scaleX, scaleYを同時に変更する
		 */
		public function set scaleXY(value:Number):void { scaleX = scaleY = value; }
		
		/**
		 * scaleX, scaleY, scaleZを同時に変更する
		 */
		public function set scaleXYZ(value:Number):void { scaleX = scaleY = scaleZ = value; }
		
		/**
		 * ステージに配置されたときに実行される関数
		 */
		public function get initialize():Function { return __initialize; }
		public function set initialize(value:Function):void { __initialize = value; }
		private var __initialize:Function;
		
		/**
		 * ステージから削除されたときに実行される関数
		 */
		public function get finalize():Function { return __finalize || _finalize; }
		public function set finalize(value:Function):void { __finalize = value; }
		private var __finalize:Function;
		
		/**
		 * ステージがリサイズされたときに実行される関数
		 */
		public function get resize():Function { return __resize || _resize; }
		public function set resize(value:Function):void { __resize = value; }
		private var __resize:Function;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function SimpleSprite(initVisible:Boolean = false):void
		{
			_initVisible = initVisible;
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		
		
		
		
		/**
		 * ステージに配置されたときに実行される関数(オーバーライド用)
		 */
		protected function _initialize():void
		{
		}
		
		/**
		 * ステージから削除されたときに実行される関数(オーバーライド用)
		 */
		protected function _finalize():void
		{
		}
		
		/**
		 * ステージがリサイズされたときに実行される関数(オーバーライド用)
		 */
		protected function _resize():void
		{
		}
		
		
		
		
		
		/**
		 * 表示モーション
		 * @param	useTween
		 */
		protected function _showMotion(useTween:Boolean = true):void
		{
			visible = true;
		}
		
		/**
		 * 非表示モーション
		 * @param	useTween
		 */
		protected function _hideMotion(useTween:Boolean = true):void
		{
			visible = false;
		}
		
		
		
		
		
		/**
		 * 表示する
		 * @param	useTween
		 */
		public function show(useTween:Boolean = true):void
		{
			if (_isShowing) return;
			_isShowing = true;
			
			//表示モーションの開始
			_showMotion(useTween);
		}
		
		/**
		 * 非表示にする
		 * @param	useTween
		 */
		public function hide(useTween:Boolean = true):void
		{
			if (!_isShowing) return;
			_isShowing = false;
			
			//非表示モーションの開始
			_hideMotion(useTween);
		}
		
		
		
		
		
		/**
		 * ディスプレイリストへの追加ハンドラ
		 * @param	e
		 */
		private function _addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
			
			//ステージへの参照を保持
			_stage = stage;
			
			if (_initVisible)
			{
				//最初は表示にする
				_isShowing = false;
				show(false);
			}
			else
			{
				//最初は非表示にする
				_isShowing = true;
				hide(false);
			}
			
			//初期化関数の実行
			_initialize();
		}
		
		/**
		 * ディスプレイリストからの削除ハンドラ
		 * @param	e
		 */
		private function _removedFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.removeEventListener(Event.RESIZE, _stageResizeHandler);
			
			//終了関数の実行
			_finalize();
			
			//後処理
			_stage = null;
			__initialize = null;
			__finalize = null;
			__resize = null;
		}
		
		/**
		 * ステージのリサイズハンドラ
		 * @param	e
		 */
		private function _stageResizeHandler(e:Event):void 
		{
			//リサイズ関数の実行
			_resize();
		}
	}
}
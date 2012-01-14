package net.alumican.iphone.display
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	import net.alumican.as3.profiler.logger.LoggerUtil;
	
	/**
	 * ドキュメントクラス
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Document extends Sprite
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		/**
		 * デバッグモードで実行時にはtrue
		 */
		public function get isDebugMode():Boolean { return _isDebugMode; }
		private var _isDebugMode:Boolean;
		
		/**
		 * 画面サイズ
		 */
		public function get stageWidth():int  { return 320; }
		public function get stageHeight():int { return 480; }
		
		
		
		
		
		//-------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//-------------------------------------
		// METHODS
		
		/**
		 * 初期化関数
		 * @param	stage
		 */
		public function initialize(stage:Stage):*
		{
			return this;
		}
		
		
		
		
		
		/**
		 * コンストラクタ
		 */
		public function Document(debugMode:Boolean = false):void
		{
			_isDebugMode = debugMode;
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		/**
		 * ステージ配置時のハンドラ
		 * @param	e
		 */
		protected function _addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			//ステージの設定
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//ロガーの初期化
			LoggerUtil.setup(_isDebugMode);
			
			//初期化関数の呼び出し
			LoggerUtil.init = initialize(stage);
		}
	}
}
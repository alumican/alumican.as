package net.alumican.as3.framework.progression4.pages 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import jp.progression.casts.CastDocument;
	import jp.progression.core.proto.Configuration;
	import jp.progression.debug.Debugger;
	import net.alumican.as3.profiler.logger.LoggerUtil;
	
	/**
	 * ProgressionDocument
	 * 
	 * @author alumican
	 */
	public class ProgressionDocument extends CastDocument
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * Loggerを有効化する場合はtrue
		 */
		private var _debugMode:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	debugMode
		 * @param	managerId
		 * @param	rootClass
		 * @param	config
		 * @param	initObject
		 */
		public function ProgressionDocument(debugMode:Boolean = false, managerId:String = null, rootClass:Class = null, config:Configuration = null, initObject:Object = null):void 
		{
			_debugMode = debugMode;
			
			//自動的に作成される Progression インスタンスの初期設定を行います。
			//生成されたインスタンスにアクセスする場合には manager プロパティを参照してください。
			super(managerId, rootClass, config, initObject);
		}
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		protected override function atReady():void
		{
			//ステージの初期化
			stage.align     = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality   = StageQuality.HIGH;
			
			//終了ハンドラの登録
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			//ロガーの初期化
			LoggerUtil.setup(_debugMode);
			
			//開発者用に Progression の動作状況を出力します。
			if (_debugMode) Debugger.addTarget(manager);
			
			//コンテキストメニューを非表示にする
			//_configContextMenu();
			
			//外部同期機能を有効化します。
			//manager.sync = true;
			
			//初期化関数の呼び出し
			LoggerUtil.init = initialize(stage);
			
			//最初の座標合わせ
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
			resize(stage, true);
			
			//最初のシーンに移動します。
			manager.goto(manager.syncedSceneId);
		}
		
		/**
		 * ステージから削除時のハンドラ
		 * @param	e
		 */
		protected function _removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			
			//終了関数の呼び出し
			LoggerUtil.fin = finalize(stage);
		}
		
		/**
		 * ステージリサイズ時のハンドラ
		 * @param	e
		 */
		protected function _stageResizeHandler(e:Event):void
		{
			LoggerUtil.resize = resize(stage, false);
		}
		
		/**
		 * コンテキストメニューを非表示にする
		 */
		protected function _configContextMenu():void
		{
			var context = new ContextMenu();
			context.hideBuiltInItems();
			contextMenu = context;
		}
		
		/**
		 * 初期化関数
		 * @param	stage
		 */
		public function initialize(stage:Stage):*
		{
			return this;
		}
		
		/**
		 * 終了関数
		 * @param	stage
		 */
		public function finalize(stage:Stage):*
		{
			return this;
		}
		
		/**
		 * リサイズ関数
		 * @param	stage
		 * @param	isInit
		 */
		public function resize(stage:Stage, isInit:Boolean):*
		{
			return this;
		}
	}
}
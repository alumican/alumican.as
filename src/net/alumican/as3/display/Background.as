package net.alumican.as3.display
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 背景クラス
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Background extends Sprite
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		/**
		 * 描画関数
		 * @param	stage
		 */
		public function get draw():Function { return __draw || _draw; }
		public function set draw(value:Function):void { __draw = value; if (stage) draw(stage); }
		private var __draw:Function;
		
		
		
		
		
		//-------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//-------------------------------------
		// METHODS
		
		/**
		 * 描画関数(オーバーライド用)
		 * @param	stage
		 */
		protected function _draw(stage:Stage):void
		{
		}
		
		/**
		 * ベタ塗り
		 * @param	color
		 * @param	alpha
		 * @return
		 */
		public function createFillColor(color:uint = 0xffffff, alpha:Number = 1.0):Function
		{
			return function(stage:Stage):void
			{
				var g:Graphics = graphics;
				g.clear();
				g.beginFill(color, alpha);
				g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				g.endFill();
			}
		}
		
		
		
		
		
		/**
		 * コンストラクタ
		 */
		public function Background():void
		{
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		/**
		 * ステージ配置時のハンドラ
		 * @param	e
		 */
		protected function _addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
			draw(stage);
		}
		
		/**
		 * ステージから削除時のハンドラ
		 * @param	e
		 */
		protected function _removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStageHandler);
			stage.removeEventListener(Event.RESIZE, _stageResizeHandler);
		}
		
		/**
		 * ステージリサイズ時のハンドラ
		 * @param	e
		 */
		protected function _stageResizeHandler(e:Event):void
		{
			draw(stage);
		}
	}
}
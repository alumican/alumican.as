package net.alumican.as3.utils
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * StageReference
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class StageReference extends EventDispatcher
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		static public const DEFAULT_WIDTH:uint  = 1024;
		static public const DEFAULT_HEIGHT:uint = 768;
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		/**
		 * インスタンスの取得
		 */
		static public function get instance():StageReference { return _instance ? _instance : (_instance = new StageReference(new SingletonEnforcer())); }
		static private var _instance:StageReference;
		
		
		
		
		
		/**
		 * 実際のステージ参照
		 */
		public function get stage():Stage { return _stage; }
		private var _stage:Stage;
		
		/**
		 * ステージサイズ
		 */
		public function get stageX():int      { return _stageX;      }
		public function get stageY():int      { return _stageY;      }
		public function get stageWidth():int  { return _stageWidth;  }
		public function get stageHeight():int { return _stageHeight; }
		private var _stageX:int      = 0;
		private var _stageY:int      = 0;
		private var _stageWidth:int  = DEFAULT_WIDTH;
		private var _stageHeight:int = DEFAULT_HEIGHT;
		
		/**
		 * ステージの四隅の座標
		 */
		public function get stageTop():int    { return _stageX;      }
		public function get stageLeft():int   { return _stageY;      }
		public function get stageRight():int  { return _stageRight;  }
		public function get stageBottom():int { return _stageBottom; }
		private var _stageRight:int  = _stageX + _stageWidth;
		private var _stageBottom:int = _stageY + _stageHeight;
		
		/**
		 * デバッグ用ステージ矩形
		 * useFlexibleDebugRect = true の場合は，実際のステージからのマージンとなる
		 */
		public function get debugRect():Rectangle { return _debugRect; }
		public function set debugRect(value:Rectangle):void { _debugRect = value; updateStageRect(); }
		private var _debugRect:Rectangle = null;
		
		/**
		 * 実際のステージ矩形
		 */
		public function get actualRect():Rectangle { return _actualRect; }
		private var _actualRect:Rectangle;
		
		/**
		 * デバッグ用矩形を実際のステージサイズに合わせて伸縮される場合はtrue
		 */
		public function get useFlexibleDebugRect():Boolean { return _useFlexibleDebugRect; }
		public function set useFlexibleDebugRect(value:Boolean):void { _useFlexibleDebugRect = value; updateStageRect(); }
		private var _useFlexibleDebugRect:Boolean = true;
		
		/**
		 * ステージ矩形のデバッグ表示をおこなう場合はtrue
		 */
		public function get useDebugView():Boolean { return _useDebugView; }
		public function set useDebugView(value:Boolean):void { _useDebugView = value; _updateDebugView(); }
		private var _useDebugView:Boolean = false;
		private var _debugView:Shape;
		
		/**
		 * ステージ矩形のデバッグ表示設定
		 */
		public function get debugViewLineColor():uint { return _debugViewLineColor; }
		public function set debugViewLineColor(value:uint):void { _debugViewLineColor = value; _updateDebugView(); }
		public function get debugViewLineAlpha():uint { return _debugViewLineAlpha; }
		public function set debugViewLineAlpha(value:uint):void { _debugViewLineAlpha = value; _updateDebugView(); }
		public function get debugViewFillColor():uint { return _debugViewFillColor; }
		public function set debugViewFillColor(value:uint):void { _debugViewFillColor = value; _updateDebugView(); }
		public function get debugViewFillAlpha():uint { return _debugViewFillAlpha; }
		public function set debugViewFillAlpha(value:uint):void { _debugViewFillAlpha = value; _updateDebugView(); }
		private var _debugViewLineColor:uint   = 0x6565ff;
		private var _debugViewLineAlpha:Number = 1.0;
		private var _debugViewFillColor:uint   = 0x0000ff;
		private var _debugViewFillAlpha:Number = 0.1;
		
		/**
		 * ステージのリサイズイベントをリスンする場合はtrue
		 */
		public function get isListening():Boolean { return _isListening; }
		public function set isListening(value:Boolean):void 
		{
			_isListening = value;
			if (_isListening)
			{
				_stage.addEventListener(Event.RESIZE, _resizeHandler, false, int.MAX_VALUE);
			}
			else
			{
				_stage.removeEventListener(Event.RESIZE, _resizeHandler);
			}
		}
		private var _isListening:Boolean = false;
		
		/**
		 * マウス座標
		 */
		public function get mouseX():int { var p:int = _stage.mouseX - _stageX; return (p < 0) ? 0 : (p > _stageWidth ) ? _stageWidth  : p; }
		public function get mouseY():int { var p:int = _stage.mouseY - _stageY; return (p < 0) ? 0 : (p > _stageHeight) ? _stageHeight : p; }
		
		
		
		
		
		//-------------------------------------
		//METHODS
		
		public function StageReference(pvt:SingletonEnforcer):void
		{
			_actualRect = new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
		}
		
		/**
		 * 初期化関数
		 * @param	stage
		 */
		public function initialize(stage:Stage, listen:Boolean = true):void
		{
			_stage = stage;
			isListening = listen;
			updateStageRect();
		}
		
		/**
		 * 終了関数
		 */
		public function finalize():void
		{
			if (_debugView && _stage.contains(_debugView)) _stage.removeChild(_debugView);
			isListening = false;
			_debugView = null;
			_debugRect = null;
			_stage = null;
		}
		
		
		
		
		
		/**
		 * リサイズハンドラ
		 * @param	e
		 */
		private function _resizeHandler(e:Event):void 
		{
			updateStageRect();
			dispatchResizeEvent();
		}
		
		/**
		 * リサイズイベントを発行する
		 */
		public function dispatchResizeEvent():void
		{
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		
		
		
		/**
		 * ステージ矩形を計算する
		 */
		public function updateStageRect():void
		{
			if (_debugRect)
			{
				//--------------------------------------------
				//デバッグ用ステージ矩形の生成
				
				if (_useFlexibleDebugRect)
				{
					//----------------------------------------
					//実際のステージ矩形に合わせて伸縮するステージ矩形
					_stageX      = _debugRect.x;
					_stageY      = _debugRect.y;
					_stageRight  = _stage.stageWidth  - _debugRect.width;
					_stageBottom = _stage.stageHeight - _debugRect.height;
					_stageWidth  = _stageRight  - _stageX;
					_stageHeight = _stageBottom - _stageY;
				}
				else
				{
					//----------------------------------------
					//伸縮しないステージ矩形
					_stageWidth  = _debugRect.width;
					_stageHeight = _debugRect.height;
					_stageX      = isNaN(_debugRect.x) ? ((_stage.stageWidth  - _stageWidth ) * 0.5) : _debugRect.x;
					_stageY      = isNaN(_debugRect.y) ? ((_stage.stageHeight - _stageHeight) * 0.5) : _debugRect.y;
					_stageRight  = _stageX + _stageWidth;
					_stageBottom = _stageY + _stageHeight;
				}
			}
			else
			{
				//--------------------------------------------
				//実際のステージ矩形を適用
				_stageX      = 0;
				_stageY      = 0;
				_stageWidth  = _stage.stageWidth;
				_stageHeight = _stage.stageHeight;
				_stageRight  = _stageX + _stageWidth;
				_stageBottom = _stageY + _stageHeight;
			}
			
			//実際のステージ矩形
			_actualRect.x      = 0;
			_actualRect.y      = 0;
			_actualRect.width  = _stage.stageWidth;
			_actualRect.height = _stage.stageHeight;
			
			//デバッグ表示矩形を更新する
			_updateDebugView();
		}
		
		/**
		 * デバッグ表示矩形を更新する
		 */
		private function _updateDebugView():void
		{
			if (_useDebugView)
			{
				//デバッグ表示矩形をステージへ追加する
				_createDebugView();
				_stage.addChild(_debugView);
			}
			else
			{
				//デバッグ表示矩形をステージから削除する
				if (_debugView && _stage.contains(_debugView)) _stage.removeChild(_debugView);
			}
		}
		
		/**
		 * デバッグ表示矩形を生成する
		 */
		private function _createDebugView():void
		{
			if (!_debugView) _debugView = new Shape();
			var g:Graphics = _debugView.graphics;
			g.clear();
			g.lineStyle(1, _debugViewLineColor, _debugViewLineAlpha);
			g.beginFill(_debugViewFillColor, _debugViewFillAlpha);
			g.drawRect(_stageX, _stageY, _stageWidth, _stageHeight);
			g.endFill();
		}
		
		/**
		 * 文字列表記
		 * @return
		 */
		override public function toString():String 
		{
			return "StageReference : x=" + _fillBlank(_stageX.toString()) + ", y=" + _fillBlank(_stageY.toString()) + ", width=" + _fillBlank(_stageWidth.toString()) + ", height=" + _fillBlank(_stageHeight.toString());
		}
		
		/**
		 * テキストフォーマット
		 * @param	value
		 * @return
		 */
		private function _fillBlank(value:String):String
		{
			return ("    " + value).substr(-4, 4);
		}
	}
}

internal class SingletonEnforcer { }
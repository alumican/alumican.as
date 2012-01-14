package net.alumican.as3.framework.flartoolkit.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	
	/**
	 * FLARToolkitにPV3Dモデルを簡単に合成するクラス
	 * FLARToolkitのスタートアップキットに入っていたものを改造
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class FLARAppPV3D extends FLARAppBase
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const START:String         = "onStart";
		static public const STOP:String          = "onStop";
		static public const RENDER_BEFORE:String = "onRenderBefore";
		static public const RENDER_AFTER:String  = "onRenderAfter";
		
		static public const READY:String              = "onReady";
		static public const DETECTOR_COMPLETE:String  = "onDetectorComplete";
		static public const DETECTOR_EXCEPTION:String = "onDetectorException";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 入力映像とPapervision3Dのビューポートを配置するSprite
		 */
		public function get container():Sprite { return _container; }
		private var _container:Sprite;
		
		/**
		 * Papervision3Dのビューポート
		 */
		private var _pv3dViewport:Viewport3D;
		public function get pv3dViewport():Viewport3D { return _pv3dViewport; }
		
		/**
		 * Papervision3Dのカメラ
		 */
		private var _pv3dCamera:FLARCamera3D;
		public function get pv3dCamera():FLARCamera3D { return _pv3dCamera; }
		
		/**
		 * Papervision3Dのシーン
		 */
		private var _pv3dScene:Scene3D;
		public function get pv3dScene():Scene3D { return _pv3dScene; }
		
		/**
		 * Papervision3Dのレンダラー
		 */
		private var _pv3dRenderer:LazyRenderEngine;
		public function get pv3dRenderer():LazyRenderEngine { return _pv3dRenderer; }
		
		/**
		 * Papervision3Dの軸補正済みベースオブジェクト(3Dオブジェクトはこのベースオブジェクトに追加していく)
		 */
		public function get pv3dBaseNode():FLARBaseNode { return _pv3dBaseNode; }
		private var _pv3dBaseNode:FLARBaseNode;
		
		/**
		 * 表示画面の幅
		 */
		public function get screenWidth():Number { return _screenWidth; }
		public function set screenWidth(value:Number):void { if (value == _screenWidth) return; _screenWidth = value; _applyScreenSize(); }
		private var _screenWidth:Number;
		
		/**
		 * 表示画面の高さ
		 */
		public function get screenHeight():Number { return _screenHeight; }
		public function set screenHeight(value:Number):void { if (value == _screenHeight) return; _screenHeight = value; _applyScreenSize(); }
		private var _screenHeight:Number;
		
		/**
		 * 映像を左右反転するならtrue
		 */
		public function get mirror():Boolean { return (_container.scaleX < 0); }
		public function set mirror(value:Boolean):void
		{
			if (value)
			{
				_container.scaleX = -1;
				_container.x      = _screenWidth;
			}
			else
			{
				_container.scaleX = 1;
				_container.x      = 0;
			}
		}
		
		/**
		 * レンダリング開始時に呼ばれる関数
		 */
		public function get onStart():Function { return __onStart || _onStart; }
		public function set onStart(value:Function):void { __onStart = value; }
		private var __onStart:Function;
		
		/**
		 * レンダリング停止時に呼ばれる関数
		 */
		public function get onStop():Function { return __onStop || _onStop; }
		public function set onStop(value:Function):void { __onStop = value; }
		private var __onStop:Function;
		
		/**
		 * Papervisionの3Dレンダリング直前に呼ばれる関数
		 */
		public function get onRenderBefore():Function { return __onRenderBefore || _onRenderBefore; }
		public function set onRenderBefore(value:Function):void { __onRenderBefore = value; }
		private var __onRenderBefore:Function;
		
		/**
		 * Papervisionの3Dレンダリング直後に呼ばれる関数
		 */
		public function get onRenderAfter():Function { return __onRenderAfter || _onRenderAfter; }
		public function set onRenderAfter(value:Function):void { __onRenderAfter = value; }
		private var __onRenderAfter:Function;
		
		/**
		 * 準備完了後に自動開始する場合にはtrue
		 */
		private var _autoStart:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	screenWidth  表示サイズ(幅)
		 * @param	screenHeight 表示サイズ(高さ)
		 */
		public function FLARAppPV3D(screenWidth:Number = 640, screenHeight:Number = 480, autoStart:Boolean = true):void
		{
			_screenWidth  = screenWidth;
			_screenHeight = screenHeight;
			_autoStart    = autoStart;
			
			//VideoとPV3Dオブジェクトを入れるコンテナ
			_container = addChild(new Sprite()) as Sprite;
		}
		
		/**
		 * 初期化関数
		 */
		protected override function _onReady():void
		{
			super._onReady();
			
			//Videoを拡大して背景として配置
			_container.addChild(videoCapture);
			
			//Papervision3Dのビューポートを生成
			_pv3dViewport = _container.addChild( new Viewport3D(flarCameraWidth, flarCameraHeight) ) as Viewport3D;
			_pv3dViewport.x = -4; // -4pix ???
			
			//Papervision3Dのカメラを生成
			_pv3dCamera = new FLARCamera3D(flarParam);
			
			//Papervision3Dのシーンを生成
			_pv3dScene = new Scene3D();
			
			//Papervision3Dのレンダラーを生成
			_pv3dRenderer = new LazyRenderEngine(_pv3dScene, _pv3dCamera, _pv3dViewport);
			
			//Papervision3Dのシーンに軸を補正したベースオブジェクトを配置
			_pv3dBaseNode = _pv3dScene.addChild(new FLARBaseNode(FLARBaseNode.AXIS_MODE_PV3D)) as FLARBaseNode;
			
			//スクリーンサイズの適用
			_applyScreenSize();
			
			//自動開始
			if (_autoStart) startRender();
		}
		
		/**
		 * レンダリング開始
		 */
		public function startRender():void
		{
			if (!isReady) return;
			addEventListener(Event.ENTER_FRAME, _update);
			onStart();
			dispatchEvent( new Event(START) );
		}
		
		/**
		 * レンダリング停止
		 */
		public function stopRender():void
		{
			removeEventListener(Event.ENTER_FRAME, _update);
			onStop();
			dispatchEvent( new Event(STOP) );
		}
		
		/**
		 * レンダリング更新
		 */
		public function render():void
		{
			//マーカー検出
			detect();
			
			//検出に成功すれば変換行列を更新
			if (isCodeDetected) _pv3dBaseNode.setTransformMatrix(flarResultMatrix);
			
			_onRenderBefore();
			dispatchEvent( new Event(RENDER_BEFORE) );
			
			//Papervision3Dをレンダリング
			_pv3dRenderer.render();
			
			onRenderAfter();
			dispatchEvent( new Event(RENDER_AFTER) );
		}
		
		/**
		 * スクリーンサイズを適用する
		 */
		private function _applyScreenSize():void
		{
			if (isReady)
			{
				videoCapture.width   = _screenWidth;
				videoCapture.height  = _screenHeight;
				
				_pv3dViewport.scaleX = _screenWidth  / flarCameraWidth;
				_pv3dViewport.scaleY = _screenHeight / flarCameraHeight;
				
				mirror = mirror;
			}
		}
		
		/**
		 * 毎フレーム更新ハンドラ
		 * @param	e
		 */
		private function _update(e:Event = null):void
		{
			render();
		}
		
		/**
		 * レンダリング開始時に呼ばれる関数(オーバーライド用)
		 */
		protected function _onStart():void
		{
		}
		
		/**
		 * レンダリング停止時に呼ばれる関数(オーバーライド用)
		 */
		protected function _onStop():void
		{
		}
		
		/**
		 * Papervisionの3Dレンダリング直前に呼ばれる関数(オーバーライド用)
		 */
		protected function _onRenderBefore():void
		{
		}
		
		/**
		 * Papervisionの3Dレンダリング直後に呼ばれる関数(オーバーライド用)
		 */
		protected function _onRenderAfter():void
		{
		}
	}
}
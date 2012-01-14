package net.alumican.as3.display
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 簡単にローディングアイコンを設置できる
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class LoadingIcon extends Sprite
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//-------------------------------------
		//VARIABLES
		
		/**
		 * 最初にプリローダーを描画する関数
		 */
		public function get constructor():Function { return __constructor || _constructor; }
		public function set constructor(value:Function):void { __constructor = value; }
		private var __constructor:Function;
		
		/**
		 * 毎フレームプリローダーをアニメーションさせる関数
		 */
		public function get updator():Function { return __updator || _updator; }
		public function set updator(value:Function):void { __updator = value; }
		private var __updator:Function;
		
		/**
		 * インスタンスを破棄する関数
		 */
		public function get disposer():Function { return __disposer || _disposer; }
		public function set disposer(value:Function):void { __disposer = value; }
		private var __disposer:Function;
		
		/**
		 * 現在アニメーション中ならtrue
		 */
		public function get isPlaying():Boolean { return _isPlaying; }
		private var _isPlaying:Boolean;
		
		private var _canvas:MovieClip;
		
		
		
		
		
		//-------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//-------------------------------------
		// METHODS
		
		/**
		 * 最初にプリローダーを描画する関数(オーバーライド用)
		 * @param	canvas
		 */
		protected function _constructor(canvas:MovieClip):void
		{
		}
		
		/**
		 * 毎フレームプリローダーをアニメーションさせる関数(オーバーライド用)
		 * @param	canvas
		 */
		protected function _updator(canvas:MovieClip):void
		{
		}
		
		/**
		 * インスタンスを破棄する関数(オーバーライド用)
		 * @param	canvas
		 */
		protected function _disposer(canvas:MovieClip):void
		{
		}
		
		/**
		 * アニメーション開始
		 */
		public function play():void
		{
			if (_isPlaying) return;
			_isPlaying = true;
			
			if (!_canvas) constructor( _canvas = addChild( new MovieClip() ) as MovieClip );
			addEventListener(Event.ENTER_FRAME, _updateHandler);
		}
		
		/**
		 * アニメーション停止
		 */
		public function stop():void
		{
			if (!_isPlaying) return;
			_isPlaying = false;
			
			removeEventListener(Event.ENTER_FRAME, _updateHandler);
		}
		
		/**
		 * 破棄
		 */
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, _updateHandler);
			disposer(_canvas);
			if (contains(_canvas)) removeChild(_canvas);
			_canvas = null;
			__constructor = null;
			__updator = null;
			__disposer = null;
		}
		
		/**
		 * コンストラクタ
		 */
		public function LoadingIcon():void
		{
			_isPlaying = false;
		}
		
		/**
		 * アニメーション中に毎フレーム呼ばれるハンドラ
		 * @param	e
		 */
		private function _updateHandler(e:Event):void 
		{
			updator(_canvas);
		}
		
		
		
		
		
		/**
		 * バーがくるくる回る
		 * @param	n
		 * @param	direction
		 * @param	frameInterval
		 * @param	thickness
		 * @param	insideRadius
		 * @param	outsideRadius
		 * @param	startColor
		 * @param	endColor
		 * @param	startAlpha
		 * @param	endAlpha
		 */
		public function setCircleBarsIcon(n:uint = 12, direction:Boolean = true, frameInterval:uint = 2, thickness:Number = 2, insideRadius:Number = 6, outsideRadius:Number = 10, startColor:uint = 0x666666, endColor:uint = 0x666666, startAlpha:uint = 1.0, endAlpha:uint = 0.0):void
		{
			constructor = function(canvas:MovieClip):void
			{
				var g:Graphics = canvas.graphics,
				    pi2:Number = Math.PI * 2,
				    r0:uint = startColor >> 16 & 0xff,
				    g0:uint = startColor >> 8  & 0xff,
				    b0:uint = startColor       & 0xff,
				    r1:uint = endColor   >> 16 & 0xff,
				    g1:uint = endColor   >> 8  & 0xff,
				    b1:uint = endColor         & 0xff,
				    angle:Number,
				    color:Number,
				    x0:Number,
				    y0:Number,
				    x1:Number,
				    y1:Number,
				    ratio0:Number,
				    ratio1:Number;
				
				for (var i:uint = 0; i < n; ++i) 
				{
					ratio0 = i / n; 
					ratio1 = 1 - ratio0;
					
					angle = pi2 * ratio0 * (direction ? -1 : 1);
					
					x0 = Math.cos(angle) * insideRadius;
					y0 = Math.sin(angle) * insideRadius;
					
					x1 = Math.cos(angle) * outsideRadius;
					y1 = Math.sin(angle) * outsideRadius;
					
					color = (r0 * ratio0 + r1 * ratio1) << 16 | 
					        (g0 * ratio0 + g1 * ratio1) << 8  |
					        (b0 * ratio0 + b1 * ratio1);
					
					g.lineStyle(thickness, color, startAlpha * ratio0 + endAlpha * ratio1);
					g.moveTo(x0, y0);
					g.lineTo(x1, y1);
				}
				
				canvas.rotateIndex   = 0;
				canvas.rotateStep    = 360 / n * (direction ? -1 : 1);
				canvas.frameIndex    = 0;
				canvas.frameInterval = frameInterval;
			}
			
			updator = function(canvas:MovieClip):void
			{
				if (++canvas.frameIndex % canvas.frameInterval == 0) canvas.rotation = (++canvas.rotateIndex) * canvas.rotateStep;
			}
			
			disposer = function(canvas:MovieClip):void
			{
				canvas.graphics.clear();
				delete canvas.rotateIndex0;
				delete canvas.rotateStep;
				delete canvas.frameIndex;
				delete canvas.frameInterval;
			}
		}
		
		
		
		
		
		/**
		 * ドットがくるくる回る
		 * @param	n
		 * @param	direction
		 * @param	frameInterval
		 * @param	thickness
		 * @param	insideRadius
		 * @param	outsideRadius
		 * @param	startColor
		 * @param	endColor
		 * @param	startAlpha
		 * @param	endAlpha
		 */
		public function setCircleDotsIcon(n:uint = 8, direction:Boolean = true, frameInterval:uint = 2, radius:Number = 15, dotSize:Number = 6, startColor:uint = 0x000000, endColor:uint = 0x000000, startAlpha:Number = 1.0, endAlpha:Number = 0.2):void
		{
			constructor = function(canvas:MovieClip):void
			{
				var g:Graphics = canvas.graphics,
				    pi2:Number = Math.PI * 2,
				    r0:uint = startColor >> 16 & 0xff,
				    g0:uint = startColor >> 8  & 0xff,
				    b0:uint = startColor       & 0xff,
				    r1:uint = endColor   >> 16 & 0xff,
				    g1:uint = endColor   >> 8  & 0xff,
				    b1:uint = endColor         & 0xff,
				    angle:Number,
				    color:Number,
				    x:Number,
				    y:Number,
				    ratio0:Number,
				    ratio1:Number;
				
				for (var i:uint = 0; i < n; ++i) 
				{
					ratio0 = i / n; 
					ratio1 = 1 - ratio0;
					
					angle = pi2 * ratio0 * (direction ? -1 : 1);
					
					x = Math.cos(angle) * radius;
					y = Math.sin(angle) * radius;
					
					color = (r0 * ratio0 + r1 * ratio1) << 16 | 
					        (g0 * ratio0 + g1 * ratio1) << 8  |
					        (b0 * ratio0 + b1 * ratio1);
					
					g.beginFill(color, startAlpha * ratio0 + endAlpha * ratio1);
					g.drawCircle(x, y, dotSize / 2);
				}
				
				canvas.rotateIndex   = 0;
				canvas.rotateStep    = 360 / n * (direction ? -1 : 1);
				canvas.frameIndex    = 0;
				canvas.frameInterval = frameInterval;
			}
			
			updator = function(canvas:MovieClip):void
			{
				if (++canvas.frameIndex % canvas.frameInterval == 0) canvas.rotation = (++canvas.rotateIndex) * canvas.rotateStep;
			}
			
			disposer = function(canvas:MovieClip):void
			{
				canvas.graphics.clear();
				delete canvas.rotateIndex0;
				delete canvas.rotateStep;
				delete canvas.frameIndex;
				delete canvas.frameInterval;
			}
		}
	}
}
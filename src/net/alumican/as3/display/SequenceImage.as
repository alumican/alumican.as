package net.alumican.as3.display
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * SequenceImage
	 * 
	 * @author alumican
	 */
	public class SequenceImage extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		private var _bmp:Bitmap;
		private var _bmds:Array;
		
		/**
		 * 現在のフレームインデックス
		 */
		public function get currentFrame():int { return _currentFrame; }
		public function set currentFrame(value:int):void { goto(value); }
		private var _currentFrame:int;
		
		/**
		 * 総フレーム数
		 */
		public function get totalFrames():int { return _totalFrames; }
		private var _totalFrames:int;
		
		/**
		 * 再生中であればtrue
		 */
		public function get isPlaying():Boolean { return _isPlaying; }
		private var _isPlaying:Boolean;
		
		/**
		 * 指定フレームが範囲外の場合、および再生完了後にループする場合はtrue
		 */
		public function get useLoop():Boolean { return _useLoop; }
		public function set useLoop(value:Boolean):void { _useLoop = value; }
		private var _useLoop:Boolean;
		
		/**
		 * 逆向きに再生をおこなう場合はtrue
		 */
		public function get useReverse():Boolean { return _useReverse; }
		public function set useReverse(value:Boolean):void { _useReverse = value; }
		private var _useReverse:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function SequenceImage():void
		{
			_bmds         = new Array();
			_bmp          = addChild( new Bitmap() ) as Bitmap;
			_isPlaying    = false;
			_currentFrame = 0;
			_totalFrames  = 0;
			_useLoop      = true;
			_useReverse   = false;
		}
		
		/**
		 * 画像をセットします
		 * @param	bitmapDatas
		 */
		public function setSequenceImages(bitmapDatas:Array):void
		{
			_bmds = bitmapDatas.concat();
			_totalFrames = _bmds.length;
			_currentFrame = -1;
			goto(0);
		}
		
		/**
		 * 指定フレームへジャンプして停止します
		 * @param	frame
		 */
		public function gotoAndStop(frame:int):void
		{
			goto(frame);
			stop();
		}
		
		/**
		 * 指定フレームへジャンプして再生します
		 * @param	frame
		 */
		public function gotoAndPlay(frame:int):void
		{
			goto(frame);
			play();
		}
		
		/**
		 * 停止します
		 */
		public function stop():void
		{
			if (!_isPlaying) return;
			_isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * 再生します
		 */
		public function play():void
		{
			if (_isPlaying) return;
			_isPlaying = true;
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * 1フレーム進みます
		 */
		public function nextFrame():void
		{
			goto(_currentFrame + 1);
		}
		
		/**
		 * 1フレーム戻ります
		 */
		public function prevFrame():void
		{
			goto(_currentFrame - 1);
		}
		
		/**
		 * 指定フレームへジャンプします
		 * @param	frame
		 * @return
		 */
		public function goto(frame:int):Boolean
		{
			var old:int = _currentFrame;
			
			if (_useLoop)
			{
				_currentFrame = (frame <  0           ) ? (frame % _totalFrames + _totalFrames - 1) :
				                (frame >= _totalFrames) ? (frame % _totalFrames                   ) : frame
			}
			else
			{
				_currentFrame = (frame <  0           ) ? 0                  :
				                (frame >= _totalFrames) ? (_totalFrames - 1) : frame;
			}
			
			if (_currentFrame != old)
			{
				_bmp.bitmapData = _bmds[_currentFrame];
				dispatchEvent( new Event(Event.CHANGE) );
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 再生アニメーション更新ハンドラ
		 * @param	e
		 */
		private function _update(e:Event):void
		{
			if (_useReverse)
			{
				if(!goto(_currentFrame - 1)) stop();
			}
			else
			{
				if(!goto(_currentFrame + 1)) stop();
			}
		}
	}
}
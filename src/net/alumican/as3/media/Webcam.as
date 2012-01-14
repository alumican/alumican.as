package net.alumican.as3.media
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	/**
	 * Webcam
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Webcam 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * Camera
		 */
		public function get camera():Camera { return _camera; }
		private var _camera:Camera;
		
		/**
		 * Video
		 */
		public function get video():Video { return _video; }
		private var _video:Video;
		
		/**
		 * Cameraとの接続が成功しているならtrue
		 */
		public function get isConnected():Boolean { return _camera != null; }
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * Constructor.
		 */
		public function Webcam():void 
		{
		}
		
		/**
		 * Webカメラと接続する
		 * @param	width
		 * @param	height
		 * @param	name
		 * @return
		 */
		public function connect(width:Number = 320, height:Number = 240, name:String = null):Boolean
		{
			if (_camera) return false;
			_camera = Camera.getCamera(name);
			if (_camera)
			{
				_video = new Video(width, height);
				_video.attachCamera(_camera);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Videoのスクリーンショットを取得する
		 * @param	dst
		 * @param	matrix
		 * @param	colorTransform
		 * @param	blendMode
		 * @param	clipRect
		 * @param	smoothing
		 * @return
		 */
		public function getCapture(dst:BitmapData = null, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode, clipRect:Rectangle = null, smoothing:Boolean = false):BitmapData
		{
			if (!_video) return null;
			if (!dst) dst = new BitmapData(_video.videoWidth, _video.videoHeight, false);
			dst.draw(_video, matrix, colorTransform, blendMode, clipRect, smoothing);
			return dst;
		}
	}
}
package net.alumican.as3.framework.flartoolkit.display
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	
	[Event(name = "init"         ,type = "flash.events.Event")]
	[Event(name = "init"         ,type = "flash.events.Event")]
	[Event(name = "ioError"      ,type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError",type = "flash.events.SecurityErrorEvent")]
	
	/**
	 * FLARToolkitを簡単に始めるクラス
	 * FLARToolkitのスタートアップキットに入っていたものを改造
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class FLARAppBase extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const READY:String              = "onReady";
		static public const DETECTOR_COMPLETE:String  = "onDetectorComplete";
		static public const DETECTOR_EXCEPTION:String = "onDetectorException";
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * FLARToolkitのカメラパラメータ
		 */
		public function get flarParam():FLARParam { return _flarParam; }
		private var _flarParam:FLARParam;
		
		/**
		 * FLARToolkitのマーカーパターン
		 */
		public function get flarCode():FLARCode { return _flarCode; }
		private var _flarCode:FLARCode;
		
		/**
		 * FLARToolkitのマーカー検出元画像データ
		 */
		public function get flarRaster():FLARRgbRaster_BitmapData { return _flarRaster; }
		private var _flarRaster:FLARRgbRaster_BitmapData;
		
		/**
		 * FLARToolkitのマーカー検出器
		 */
		public function get flarDetector():FLARSingleMarkerDetector { return _flarDetector; }
		private var _flarDetector:FLARSingleMarkerDetector;
		
		/**
		 * FLARToolkitのマーカー検出後に得られる変換行列
		 */
		public function get flarResultMatrix():FLARTransMatResult { return _flarResultMatrix; }
		private var _flarResultMatrix:FLARTransMatResult;
		
		/**
		 * FLARToolkitのマーカーが検出されていればtrue (detect関数を実行することで値が更新される)
		 */
		public function get isCodeDetected():Boolean { return _isCodeDetected; }
		private var _isCodeDetected:Boolean;
		
		/**
		 * FLARToolkitのマーカー検出の閾値(2値画像化の閾値)
		 */
		public function get flarThresholdRaster():Number { return _flarThresholdRaster; }
		public function set flarThresholdRaster(value:Number):void { _flarThresholdRaster = value; }
		private var _flarThresholdRaster:Number = 80;
		
		/**
		 * FLARToolkitのマーカー検出の閾値(検出されたマーカー候補の，正解画像との一致率)
		 */
		public function get flarThresholdConfidence():Number { return _flarThresholdConfidence; }
		public function set flarThresholdConfidence(value:Number):void { _flarThresholdConfidence = value; }
		private var _flarThresholdConfidence:Number = 0.5;
		
		/**
		 * FLARToolkitのマーカーの水平方向分割数
		 */
		public function get flarCodeDivisionX():int { return _flarCodeDivisionX; }
		public function set flarCodeDivisionX(value:int):void { _flarCodeDivisionX = value; }
		private var _flarCodeDivisionX:int;
		
		/**
		 * FLARToolkitのマーカーの垂直方向分割数
		 */
		public function get flarCodeDivisionY():int { return _flarCodeDivisionY; }
		public function set flarCodeDivisionY(value:int):void { _flarCodeDivisionY = value; }
		private var _flarCodeDivisionY:int;
		
		/**
		 * FLARToolkitのマーカー全体(本体＋枠)における，マーカ本体部分の割合(幅)
		 */
		public function get flarCodePercentWidth():uint { return _flarCodePercentWidth; }
		public function set flarCodePercentWidth(value:uint):void { _flarCodePercentWidth = value; }
		private var _flarCodePercentWidth:uint;
		
		/**
		 * FLARToolkitのマーカー全体(本体＋枠)における，マーカ本体部分の割合(高さ)
		 */
		public function get flarCodePercentHeight():uint { return _flarCodePercentHeight; }
		public function set flarCodePercentHeight(value:uint):void { _flarCodePercentHeight = value; }
		private var _flarCodePercentHeight:uint;
		
		/**
		 * FLARToolkitの準備が完了している場合はtrue
		 */
		public function get isReady():Boolean { return _isReady; }
		private var _isReady:Boolean;
		
		/**
		 * カメラパラメータファイルURL
		 */
		private var _flarParamURL:String;
		
		/**
		 * マーカーパターンファイルURL
		 */
		private var _flarCodeURL:String;
		
		/**
		 * マーカーサイズ(mm)
		 */
		private var _flarCodePhysicalWidth:int;
		
		/**
		 * 各種設定ファイル読み込みLoader
		 */
		private var _loader:URLLoader;
		
		/**
		 * 入力カメラ
		 */
		private var _flarCamera:Camera;
		
		/**
		 * 入力カメラの幅
		 */
		public function get flarCameraWidth():int { return _flarCameraWidth; }
		private var _flarCameraWidth:int;
		
		/**
		 * 入力カメラの高さ
		 */
		public function get flarCameraHeight():int { return _flarCameraHeight; }
		private var _flarCameraHeight:int;
		
		/**
		 * 入力カメラをセットするVideo
		 */
		private var _video:Video;
		
		/**
		 * FLARToolkitの入力となるVideoのキャプチャ画像
		 */
		public function get videoCapture():Bitmap { return _videoCapture; }
		private var _videoCapture:Bitmap;
		
		/**
		 * 初期化が完了したときに呼ばれる関数
		 */
		public function get onReady():Function { return __onReady || _onReady; }
		public function set onReady(value:Function):void { __onReady = value; }
		private var __onReady:Function;
		
		/**
		 * マーカー検出において例外が発生せずに終了した場合の関数
		 */
		public function get onDetectorComplete():Function { return __onDetectorComplete || _onDetectorComplete; }
		public function set onDetectorComplete(value:Function):void { __onDetectorComplete = value; }
		private var __onDetectorComplete:Function;
		
		/**
		 * マーカー検出において例外が発生したときに呼ばれる関数
		 */
		public function get onDetectorException():Function { return __onDetectorException || _onDetectorException; }
		public function set onDetectorException(value:Function):void { __onDetectorException = value; }
		private var __onDetectorException:Function;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function FLARAppBase():void
		{
		}
		
		/**
		 * 初期化関数
		 * @param	paramURL
		 * @param	codeURL
		 * @param	cameraWidth
		 * @param	cameraHeight
		 * @param	codePhysicalWidth マーカーの物理サイズ(mm)
		 * @param	codeDivisionX
		 * @param	codeDivisionY
		 * @param	codePercentWidth
		 * @param	codePercentHeight
		 */
		public function initialize(paramURL:String, codeURL:String, cameraWidth:int = 320, cameraHeight:int = 240, codePhysicalWidth:int = 80, codeDivisionX:int = 16, codeDivisionY:int = 16, codePercentWidth:uint = 50, codePercentHeight:uint = 50):void
		{
			_flarInit(paramURL, codeURL, cameraWidth, cameraHeight, codePhysicalWidth, codeDivisionX, codeDivisionY, codePercentWidth, codePercentHeight);
		}
		
		/**
		 * FLARToolkitの初期化関数
		 * @param	paramURL
		 * @param	codeURL
		 * @param	cameraWidth
		 * @param	cameraHeight
		 * @param	codePhysicalWidth
		 * @param	codeDivisionX
		 * @param	codeDivisionY
		 * @param	codePercentWidth
		 * @param	codePercentHeight
		 */
		private function _flarInit(paramURL:String, codeURL:String, cameraWidth:int, cameraHeight:int, codePhysicalWidth:int, codeDivisionX:int, codeDivisionY:int, codePercentWidth:uint, codePercentHeight:uint):void
		{
			_flarParamURL          = paramURL;
			_flarCodeURL           = codeURL;
			_flarCameraWidth       = cameraWidth;
			_flarCameraHeight      = cameraHeight;
			_flarCodePhysicalWidth = codePhysicalWidth;
			_flarCodeDivisionX     = codeDivisionX;
			_flarCodeDivisionY     = codeDivisionY;
			_flarCodePercentWidth  = codePercentWidth;
			_flarCodePercentHeight = codePercentHeight;
			
			_flarResultMatrix = new FLARTransMatResult();
			_isCodeDetected   = false;
			_isReady          = false;
			
			//カメラパラメータファイルの読み込み
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, _flarParamLoadCompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader.load(new URLRequest(_flarParamURL));
		}
		
		/**
		 * カメラパラメータファイルの読み込み完了ハンドラ
		 * @param	e
		 */
		private function _flarParamLoadCompleteHandler(e:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, _flarParamLoadCompleteHandler);
			
			//カメラパラメータクラスの生成
			_flarParam = new FLARParam();
			_flarParam.loadARParam(_loader.data);
			_flarParam.changeScreenSize(_flarCameraWidth, _flarCameraHeight);
			
			//マーカーパターンファイルの読み込み
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _flarCodeLoadCompleteHandler);
			_loader.load(new URLRequest(_flarCodeURL));
		}
		
		/**
		 * マーカーパターンファイルの読み込み完了ハンドラ
		 * @param	e
		 */
		private function _flarCodeLoadCompleteHandler(e:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, _flarCodeLoadCompleteHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			
			//マーカーパターンクラスの生成
			_flarCode = new FLARCode(_flarCodeDivisionX, _flarCodeDivisionY, _flarCodePercentWidth, _flarCodePercentHeight);
			_flarCode.loadARPatt(_loader.data);
			
			_loader = null;
			
			//webカメラの取得
			_flarCamera = Camera.getCamera();
			if (!_flarCamera) throw new Error('No webcam!!!!');
			
			//Videoへの取り込み
			_flarCamera.setMode(_flarCameraWidth, _flarCameraHeight, 30);
			_video = new Video(_flarCameraWidth, _flarCameraHeight);
			_video.attachCamera(_flarCamera);
			_videoCapture = new Bitmap(new BitmapData(_flarCameraWidth, _flarCameraHeight, false, 0), PixelSnapping.AUTO, true);
			
			//FLARToolkitの立ち上げ
			_flarRaster = new FLARRgbRaster_BitmapData(_videoCapture.bitmapData);
			_flarDetector = new FLARSingleMarkerDetector(_flarParam, _flarCode, _flarCodePhysicalWidth);
			_flarDetector.setContinueMode(true);
			
			_isReady = true;
			
			onReady();
			dispatchEvent( new Event(READY) );
		}
		
		/**
		 * マーカー検出
		 * @return
		 */
		public function detect():Boolean
		{
			//キャプチャ画像の更新
			_videoCapture.bitmapData.draw(_video);
			
			//マーカーの検出
			try
			{
				if (_isCodeDetected = _flarDetector.detectMarkerLite(_flarRaster, _flarThresholdRaster) && _flarDetector.getConfidence() > _flarThresholdConfidence) flarDetector.getTransformMatrix(_flarResultMatrix);
				onDetectorComplete();
				dispatchEvent( new Event(DETECTOR_COMPLETE) );
			}
			catch (error:Error)
			{
				_isCodeDetected = false;
				onDetectorException(error);
				dispatchEvent( new Event(DETECTOR_EXCEPTION) );
			}
			
			return _isCodeDetected;
		}
		
		/**
		 * 初期化が完了したときに呼ばれる関数(オーバーライド用)
		 */
		protected function _onReady():void
		{
		}
		
		/**
		 * マーカー検出において例外が発生せずに終了した場合の関数(オーバーライド用)
		 */
		protected function _onDetectorComplete():void
		{
		}
		
		/**
		 * マーカー検出において例外が発生したときに呼ばれる関数(オーバーライド用)
		 */
		protected function _onDetectorException(error:Error):void
		{
		}
	}
}
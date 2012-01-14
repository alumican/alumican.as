package net.alumican.as3.media
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/*
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Linear;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.IObjectTween;
	*/
	
	import caurina.transitions.Tweener;
	
	/**
	 * MusicPlayer
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class MusicPlayer extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 現在の再生位置を取得する(ミリ秒)
		 */
		public function get position():Number { return _soundChannel ? _soundChannel.position : 0; }
		
		/**
		 * 総時間を取得する(ミリ秒)
		 */
		public function get length():Number { return _sound ? _sound.length : NaN; }
		
		/**
		 * 左チャネルの現在の振幅を取得する(0～1)
		 */
		public function get leftPeak():Number { return _soundChannel ? _soundChannel.leftPeak : 0; }
		
		/**
		 * 右チャネルの現在の振幅を取得する(0～1)
		 */
		public function get rightPeak():Number { return _soundChannel ? _soundChannel.rightPeak : 0; }
		
		/**
		 * 音量を取得/設定する(0～1)
		 */
		public function set volume(value:Number):void
		{
			//if (!_fadeVolumeTween) _isTurning = (value > 0) ? true : false;
			if (!_isFadeTweening) _isTurning = (value > 0) ? true : false;
			
			_soundTransform.volume = value;
			_applyTransform();
		}
		public function get volume():Number { return _soundTransform.volume; }
		
		/**
		 * パンを取得/設定する(-1～1)
		 */
		public function set pan(value:Number):void { _soundTransform.pan = value; _applyTransform(); }
		public function get pan():Number { return _soundTransform.pan; }
		
		/**
		 * 入出力レベル(左→左)を取得/設定する(0～1)
		 */
		public function set leftToLeft(value:Number):void { _soundTransform.leftToLeft = value; _applyTransform(); }
		public function get leftToLeft():Number { return _soundTransform.leftToLeft; }
		
		/**
		 * 入出力レベル(左→右)を取得/設定する(0～1)
		 */
		public function set leftToRight(value:Number):void { _soundTransform.leftToRight = value; _applyTransform(); }
		public function get leftToRight():Number { return _soundTransform.leftToRight; }
		
		/**
		 * 入出力レベル(右→左)を取得/設定する(0～1)
		 */
		public function set rightToLeft(value:Number):void { _soundTransform.rightToLeft = value; _applyTransform(); }
		public function get rightToLeft():Number { return _soundTransform.rightToLeft; }
		
		/**
		 * 入出力レベル(右→右)を取得/設定する(0～1)
		 */
		public function set rightToRight(value:Number):void { _soundTransform.rightToRight = value; _applyTransform(); }
		public function get rightToRight():Number { return _soundTransform.rightToRight; }
		
		/**
		 * サウンドを自動再生させる場合はtrue
		 */
		public function get useAutoPlay():Boolean { return _useAutoPlay; }
		public function set useAutoPlay(value:Boolean):void { _useAutoPlay = value; }
		private var _useAutoPlay:Boolean;
		
		/**
		 * サウンドをループ再生させる場合はtrue
		 */
		public function get useAutoLoop():Boolean { return _useAutoLoop; }
		public function set useAutoLoop(value:Boolean):void { _useAutoLoop = value; }
		private var _useAutoLoop:Boolean;
		
		/**
		 * 現在音量があればtrue
		 */
		public function get isTurning():Boolean { return _isTurning; }
		private var _isTurning:Boolean;
		
		/**
		 * 現在再生中であればtrue
		 */
		public function get isPlaying():Boolean { return _isPlaying; }
		private var _isPlaying:Boolean;
		
		/**
		 * サウンドの読み込みが完了していればtrue
		 */
		public function get isLoaded():Boolean { return _isLoaded; }
		private var _isLoaded:Boolean;
		
		/**
		 * サウンドの読み込み途中であればtrue
		 */
		public function get isLoading():Boolean { return _isLoading; }
		private var _isLoading:Boolean;
		
		/**
		 * サウンドの読み込みコールバック
		 */
		public var onSoundLoadIOError:Function;
		public var onSoundLoadProgress:Function;
		public var onSoundLoadComplete:Function;
		public var onSoundLoadOpen:Function;
		public var onSoundLoadID3:Function;
		public var onSoundCloseIOError:Function;
		
		/**
		 * サウンドの再生コールバック
		 */
		public var onSoundComplete:Function;
		
		/**
		 * サウンドの変形コールバック
		 */
		public var onVolumeFadeInComplete:Function;
		public var onVolumeFadeOutComplete:Function;
		
		/**
		 * Sound
		 */
		private var _sound:Sound;
		
		/**
		 * SoundChannel
		 */
		private var _soundChannel:SoundChannel;
		
		/**
		 * SoundTransform
		 */
		private var _soundTransform:SoundTransform;
		
		/**
		 * 音量調節用のTweenオブジェクト
		 */
		//private var _fadeVolumeTween:IObjectTween;
		private var _isFadeTweening:Boolean;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function MusicPlayer(volume:Number = 1.0, pan:Number = 0.0):void
		{
			_soundTransform = new SoundTransform(volume, pan);
			
			_isLoaded  = false;
			_isLoading = false;
			
			_isPlaying = false;
			_isTurning = false;
			
			_useAutoPlay = true;
			_useAutoLoop = false;
			
			_isFadeTweening = false;
		}
		
		
		
		
		
		//----------------------------------------
		//PLAY METHODS
		
		/**
		 * 再生を開始する
		 */
		public function play(startTime:Number = 0, loops:int = 0):void
		{
			if (!_isLoaded || _isPlaying) return;
			_isPlaying = true;
			
			_soundChannel = _sound.play(startTime, loops);
			_soundChannel.soundTransform = _soundTransform;
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
		}
		
		/**
		 * 再生を停止する
		 */
		public function stop():void
		{
			if (!_isLoaded || !_isPlaying) return;
			_isPlaying = false;
			
			_soundChannel.stop();
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
		}
		
		/**
		 * 指定時間から再生を開始する
		 * @param	position
		 */
		public function gotoAndPlay(position:Number, loops:int = 0):void
		{
			if (!_isLoaded) return;
			
			if (_isPlaying)
			{
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
			}
			else
			{
				_isPlaying = true;
			}
			
			_soundChannel = _sound.play(position, loops, _soundTransform);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
		}
		
		/**
		 * 指定時間で再生待ちにする
		 * @param	position
		 */
		public function gotoAndStop(position:Number, loops:int = 0):void
		{
			if (!_isLoaded) return;
			
			if (_isPlaying)
			{
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
				_isPlaying = false;
			}
			
			_soundChannel = _sound.play(position, loops, _soundTransform);
			_soundChannel.stop();
		}
		
		/**
		 * 再生完了ハンドラ
		 * @param	e
		 */
		private function _soundChannelSoundCompleteHandler(e:Event):void
		{
			var event:Event = new Event(e.type, e.bubbles, e.cancelable);
			
			if (_useAutoLoop)
			{
				//ループ再生
				_soundChannel = _sound.play(0, 0, _soundTransform);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
			}
			else
			{
				//再生終了
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
			}
			
			if (onSoundComplete != null) onSoundComplete(event);
		}
		
		
		
		
		
		//----------------------------------------
		//TRANSFORM METHODS
		
		/**
		 * 再生中のサウンドにSoundTransformを適用する
		 */
		private function _applyTransform():void
		{
			if (!_soundChannel) return;
			_soundChannel.soundTransform = _soundTransform;
		}
		
		/**
		 * 音量を上げる
		 * @param	volume
		 * @param	time
		 * @param	transition
		 */
		public function turnOn(volume:Number = 1.0, time:Number = 0.5, transition:String = "linear"):void
		{
			if (_isTurning) return;
			_isTurning = true;
			
			_fadeVolume(volume, time, transition, onVolumeFadeInComplete);
		}
		
		/**
		 * 音量を下げる
		 * @param	volume
		 * @param	time
		 * @param	transition
		 */
		public function turnOff(volume:Number = 0.0, time:Number = 0.5, transition:String = "linear"):void
		{
			if (!_isTurning) return;
			_isTurning = false;
			
			_fadeVolume(volume, time, transition, onVolumeFadeOutComplete);
		}
		
		/**
		 * 音量を変化させる
		 * @param	volume
		 * @param	time
		 * @param	transition
		 */
		private function _fadeVolume(volume:Number = 0.0, time:Number = 1.0, transition:String = "linear", onComplete:Function = null):void
		{
			/*
			if (_fadeVolumeTween)
			{
				_fadeVolumeTween.stop();
				_fadeVolumeTween = null;
			}
			*/
			
			if (time > 0)
			{
				//トゥイーン
				/*
				_fadeVolumeTween = BetweenAS3.tween(this, { volume : volume }, transition ? transition : Linear.easeNone, time, transition);
				_fadeVolumeTween.onComplete = function(...args):void
				{
					_fadeVolumeTween.onComplete = null;
					_fadeVolumeTween = null;
					if (onComplete != null) onComplete();
				};
				_fadeVolumeTween.play();
				*/
				
				_isFadeTweening = true;
				Tweener.removeTweens(this, "volume");
				Tweener.addTween(this, {
					volume     : volume,
					transition : transition,
					time       : time,
					onComplete : function():void
					{
						_isFadeTweening = false;
						if (onComplete != null) onComplete();
					}
				});
			}
			else
			{
				//ダイレクト
				_isFadeTweening = false;
				Tweener.removeTweens(this, "volume");
				
				this.volume = volume;
				if (onComplete != null) onComplete();
			}
		}
		
		
		
		
		
		//----------------------------------------
		//LOAD METHODS
		
		/**
		 * サウンドの読み込み開始
		 * @param	url
		 * @param	context
		 */
		public function load(url:String, context:SoundLoaderContext = null):void
		{
			if (_sound) close();
			
			_isLoading = true;
			_sound = new Sound();
			_sound.addEventListener(IOErrorEvent.IO_ERROR, _soundLoadIOErrorHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, _soundLoadProgressHandler);
			_sound.addEventListener(Event.COMPLETE, _soundLoadCompleteHandler);
			_sound.addEventListener(Event.OPEN, _soundLoadOpenHandler);
			_sound.addEventListener(Event.ID3, _soundLoadID3Handler);
			_sound.load(new URLRequest(url), context);
		}
		
		/**
		 * サウンドの読み込み中断
		 */
		public function close():void
		{
			_isLoaded  = false;
			_isLoading = false;
			
			_removeLoadEventListeners();
			
			try
			{
				if (_soundChannel)
				{
					_soundChannel.stop();
					_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannelSoundCompleteHandler);
					_soundChannel = null;
				}
				
				if (_sound)
				{
					_sound.close();
					_sound = null;
				}
			}
			catch (e:IOError)
			{
				if (onSoundCloseIOError != null) onSoundCloseIOError(e);
			}
		}
		
		/**
		 * 読み込み系のイベントハンドラを解除する
		 */
		private function _removeLoadEventListeners():void
		{
			if (!_sound) return;
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, _soundLoadIOErrorHandler);
			_sound.removeEventListener(ProgressEvent.PROGRESS, _soundLoadProgressHandler);
			_sound.removeEventListener(Event.COMPLETE, _soundLoadCompleteHandler);
			_sound.removeEventListener(Event.OPEN, _soundLoadOpenHandler);
			_sound.removeEventListener(Event.ID3, _soundLoadID3Handler);
		}
		
		/**
		 * サウンドの読み込み開始ハンドラ
		 * @param	e
		 */
		private function _soundLoadOpenHandler(e:Event):void 
		{
			var event:Event = new Event(e.type, e.bubbles, e.cancelable);
			if (onSoundLoadOpen != null) onSoundLoadOpen(event);
			dispatchEvent(event);
		}
		
		/**
		 * サウンドの読み込み進捗ハンドラ
		 * @param	e
		 */
		private function _soundLoadProgressHandler(e:ProgressEvent):void 
		{
			var event:ProgressEvent = new ProgressEvent(e.type, e.bubbles, e.cancelable, e.bytesLoaded, e.bytesTotal);
			if (onSoundLoadProgress != null) onSoundLoadProgress(event);
			dispatchEvent(event);
		}
		
		/**
		 * サウンドの読み込み完了ハンドラ
		 * @param	e
		 */
		private function _soundLoadCompleteHandler(e:Event):void 
		{
			_isLoaded  = true;
			_isLoading = false;
			
			_removeLoadEventListeners();
			var event:Event = new Event(e.type, e.bubbles, e.cancelable);
			if (onSoundLoadComplete != null) onSoundLoadComplete(event);
			dispatchEvent(event);
			
			//自動再生
			if (_useAutoPlay)
			{
				play();
			}
		}
		
		/**
		 * サウンドのID3使用可能ハンドラ
		 * @param	e
		 */
		private function _soundLoadID3Handler(e:Event):void 
		{
			var event:Event = new Event(e.type, e.bubbles, e.cancelable);
			if (onSoundLoadID3 != null) onSoundLoadID3(event);
			dispatchEvent(event);
		}
		
		/**
		 * サウンドの読み込みエラーハンドラ
		 * @param	e
		 */
		private function _soundLoadIOErrorHandler(e:IOErrorEvent):void 
		{
			_isLoaded  = false;
			_isLoading = false;
			
			_removeLoadEventListeners();
			var event:IOErrorEvent = new IOErrorEvent(e.type, e.bubbles, e.cancelable, e.text);
			if (onSoundLoadIOError != null) onSoundLoadIOError(event);
			dispatchEvent(event);
		}
	}
}
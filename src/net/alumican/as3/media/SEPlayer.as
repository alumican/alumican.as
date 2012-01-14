package net.alumican.as3.media
{
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * SEPlayer
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class SEPlayer 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * 同一IDのSEが再生中の場合，既に再生されているアセットを停止してから再生を開始する
		 */
		static public const MODE_INTERCEPT:String = "intercept";
		
		/**
		 * 同一IDのSEが再生中の場合，再生を開始しない
		 */
		static public const MODE_SURRENDER:String = "surrender";
		
		/**
		 * 同一IDのSEが再生中の場合，既に再生されているアセットを停止させずに重ねて再生を開始する
		 */
		static public const MODE_OVERLAP:String   = "overlap";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * インスタンスの取得
		 */
		static public function get instance():SEPlayer { return _instance ? _instance : (_instance = new SEPlayer(new SingletonEnforcer())); }
		static private var _instance:SEPlayer;
		
		/**
		 * SEアセットクラスの配列
		 */
		private var _assets:Array;
		
		/**
		 * ライブラリシンボルに関連づけられていないクラス名で，アセットを登録しようとしたときに実行されるコールバック関数
		 */
		public var onAssetNotFoundError:Function;
		
		/**
		 * Soundクラスのサブクラスでないクラスをアセットとして登録しようとしたときに実行されるコールバック関数
		 */
		public var onAssetTypeError:Function;
		
		
		
		
		
		//----------------------------------------
		// METHODS
		
		/**
		 * コンストラクタ
		 */
		public function SEPlayer(pvt:SingletonEnforcer):void 
		{
			_assets = new Array();
		}
		
		/**
		 * ライブラリのサウンドシンボルを新規SEアセットとして登録する
		 * @param	id
		 * @param	className
		 * @param	volume
		 */
		public function add(id:String, className:String, volume:Number = 1, minVolume:Number = 0, maxVolume:Number = 1):void
		{
			//指定IDのアセットが既に存在すれば上書き
			if (isExist(id)) remove(id);
			
			//ライブラリクラスの取得
			var klass:Class;
			try
			{
				klass = getDefinitionByName(className) as Class;
			}
			catch (e:Error)
			{
				trace("SEPlayer#register アセットの登録に失敗しました．指定したクラス名 \"" + className + "\" はライブラリシンボルに関連付けられている必要があります．");
				onAssetNotFoundError(id, className);
				return;
			}
			
			//Soundクラスの実体化
			var sound:Sound = new klass() as Sound;
			if (sound == null)
			{
				trace("SEPlayer#register アセットの登録に失敗しました．指定したクラス名 \"" + className + "\" の表すクラスはSoundクラスのサブクラスである必要があります．");
				onAssetTypeError(id, className);
				return;
			}
			
			_assets[id] = new Asset(id, sound, volume, minVolume, maxVolume);
		}
		
		/**
		 * 指定したIDのアセットを破棄する
		 * @param	id
		 */
		public function remove(id:String):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).dispose();
			delete _assets[id];
		}
		
		/**
		 * 全てのアセットを破棄する
		 */
		public function removeAll():void
		{
			for each(var asset:Asset in _assets)
			{
				asset.dispose();
			}
			_assets = null;
		}
		
		/**
		 * 指定したIDのアセットが存在するかどうか調べる
		 */
		public function isExist(id:String):Boolean
		{
			return (_assets[id]) ? true : false;
		}
		
		/**
		 * アセットの再生を開始する
		 * @param	id
		 * @param	loops
		 * @param	onComplete
		 */
		public function play(id:String, loops:uint = 0, onSoundComplete:Function = null, mode:String = "overlay"):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).play(loops, onSoundComplete, mode);
		}
		
		/**
		 * アセットの再生を停止する
		 * @param	id
		 */
		public function stop(id:String):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).stop();
		}
		
		/**
		 * 全てのアセットの再生を停止する
		 */
		public function stopAll():void
		{
			for each(var asset:Asset in _assets)
			{
				asset.stop();
			}
		}
		
		/**
		 * 指定したIDのアセットの音量を取得する
		 */
		public function getVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).volume;
		}
		
		/**
		 * 指定したIDのアセットの音量を設定する
		 */
		public function setVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).volume = volume;
		}
		
		/**
		 * 指定したIDのアセットの最小音量を取得する
		 */
		public function getMinVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).minVolume;
		}
		
		/**
		 * 指定したIDのアセットの最小音量を設定する
		 */
		public function setMinVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).minVolume = volume;
		}
		
		/**
		 * 指定したIDのアセットの最大音量を取得する
		 */
		public function getMaxVolume(id:String):Number
		{
			if (!isExist(id)) return 0;
			
			return Asset(_assets[id]).maxVolume;
		}
		
		/**
		 * 指定したIDのアセットの最大音量を設定する
		 */
		public function setMaxVolume(id:String, volume:Number):void
		{
			if (!isExist(id)) return;
			
			Asset(_assets[id]).maxVolume = volume;
		}
		
		/**
		 * 全てのアセットの音量を設定する
		 */
		public function setAllVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.volume = volume;
			}
		}
		
		/**
		 * 全てのアセットの最小音量を設定する
		 */
		public function setAllMinVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.minVolume = volume;
			}
		}
		
		/**
		 * 全てのアセットの最大音量を設定する
		 */
		public function setAllMaxVolume(volume:Number):void
		{
			for each(var asset:Asset in _assets)
			{
				asset.maxVolume = volume;
			}
		}
	}
}





import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * サウンドアセットクラス
 */
internal class Asset
{
	//----------------------------------------
	//VARIABLES
	
	/**
	 * 最小音量
	 */
	public function get minVolume():Number { return _minVolume; }
	public function set minVolume(value:Number):void { _minVolume = value; _setConstraintVolume(); }
	private var _minVolume:Number;
	
	/**
	 * 最大音量
	 */
	public function get maxVolume():Number { return _maxVolume; }
	public function set maxVolume(value:Number):void { _maxVolume = value; _setConstraintVolume(); }
	private var _maxVolume:Number;
	
	/**
	 * 音量を設定する(0でminVolume, 1でmaxVolumeの値となる)
	 */
	public function get volume():Number { return _volume; }
	public function set volume(value:Number):void { _volume = value; _setConstraintVolume(); }
	private var _volume:Number;
	
	/**
	 * 再生中ならtrueを返す
	 */
	public function get isPlaying():Boolean { return _channel != null; }
	
	/**
	 * Soundオブジェクトが割り当てられているならtrueを返す
	 */
	public function get isExist():Boolean { return _sound != null; }
	
	/**
	 * 再生完了時のコールバック関数
	 */
	public var onSoundComplete:Function;
	
	/**
	 * アセットID
	 */
	private var _id:String;
	
	/**
	 * Sound
	 */
	private var _sound:Sound;
	
	/**
	 * SoundChannel
	 */
	private var _channel:SoundChannel;
	
	/**
	 * SoundTransform
	 */
	private var _transform:SoundTransform;
	
	
	
	
	
	//----------------------------------------
	// METHODS
	
	/**
	 * コンストラクタ
	 */
	public function Asset(id:String, sound:Sound = null, volume:Number = 1, minVolume:Number = 0, maxVolume:Number = 1):void
	{
		_id        = id;
		_sound     = sound;
		_volume    = volume;
		_minVolume = minVolume;
		_maxVolume = maxVolume;
		_transform = new SoundTransform();
		
		_setConstraintVolume();
	}
	
	/**
	 * サウンドを登録する
	 * @param	sound
	 */
	public function register(sound:Sound):void
	{
		stop();
		_sound = sound;
	}
	
	/**
	 * サウンドを破棄する
	 */
	public function dispose():void
	{
		stop();
		_sound = null;
	}
	
	/**
	 * サウンドの再生を開始する
	 * @param	loops
	 */
	public function play(loops:int = 0, onSoundComplete:Function = null, mode:String = "intercept"):void 
	{
		this.onSoundComplete = onSoundComplete;
		
		if (_channel)
		{
			switch(mode)
			{
				//再生中の音を止めて鳴らす
				//SEPlayer.MODE_INTERCEPT
				case "intercept":
					_channel.stop();
					break;
				
				//再生中ならば鳴らさない
				//SEPlayer.MODE_SURRENDER
				case "surrender":
					return;
				
				//重ねて鳴らす
				//SEPlayer.MODE_OVERLAP
				case "overlap":
					break;
			}
		}
		
		_channel = _sound.play(0, loops, _transform);
		_channel.addEventListener(Event.SOUND_COMPLETE, _soundCompleteHandler);
	}
	
	/**
	 * サウンドの再生を停止する
	 */
	public function stop():void
	{
		if (!_channel) return;
		_channel.stop();
		_channel.removeEventListener(Event.SOUND_COMPLETE, _soundCompleteHandler);
		_channel = null;
	}
	
	/**
	 * サウンドの再生完了ハンドラ
	 * @param	e
	 */
	private function _soundCompleteHandler(e:Event):void 
	{
		var channel:SoundChannel = e.target as SoundChannel;
		channel.removeEventListener(Event.SOUND_COMPLETE, _soundCompleteHandler);
		_channel = null;
		
		//コールバック関数の実行
		if (onSoundComplete != null) onSoundComplete(_id);
	}
	
	/**
	 * 音量を設定する(0でminVolume, 1でmaxVolumeの値となる)
	 */
	private function _setConstraintVolume():void
	{
		_transform.volume = _volume * (_maxVolume - _minVolume) + _minVolume;
		if (_channel) _channel.soundTransform = _transform;
	}
}

internal class SingletonEnforcer { }
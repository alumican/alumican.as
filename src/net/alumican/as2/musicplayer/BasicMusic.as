/** 
 * BasicMusic
 * 
 * @author alumican<Yukiya Okuda>
 */
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import net.alumican.as2.musicplayer.IMusic;

class net.alumican.as2.musicplayer.BasicMusic implements IMusic {
	
	/**
	 * 各種イベントトリガです. 
	 */
	static function get SOUND_COMPLETE():String { return "onSoundComplete"; }
	static function get LOOP_COMPLETE() :String { return "onLoopComplete";  }
	
	/**
	 * サウンドのタイプです. 
	 */
	private var type:String = "basic";
		
	/**
	 * 現在の再生回数です. 
	 */
	private var count:Number;
	
	/**
	 * 再生完了するまでの再生回数です. 
	 */
	private var loops:Number;
	
	/**
	 * 曲が鳴っていればtrueです. 
	 */
	private var is_playing:Boolean;
	
	/**
	 * 再生箇所(ミリ秒)です. 
	 */
	private var position:Number;
	
	/**
	 * Soundオブジェクトです. 
	 */
	private var sound:Sound;
	
	/**
	 * 一回毎の再生完了時に呼び出されるイベントハンドラ
	 */
	//private function _onSoundComplete:Function;
	
	/**
	 * ループ再生完了時に呼び出されるイベントハンドラ
	 */
	//private function _onLoopComplete:Function;
	
	/**
	 * EventDispatcher用関数群です. 
	 */
	private var dispatchEvent:Function;
	private var dispatchQueue:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	public function get _type()      :String  { return type;           }
	public function get _count()     :Number  { return count;          }
	public function get _loops()     :Number  { return loops;          }
	public function get _is_playing():Boolean { return is_playing;     }
	public function get _sound()     :Sound   { return sound;          }
	public function get _position()  :Sound   { return sound.position; }
	public function get _duration()  :Sound   { return sound.duration; }
	
	public function get _volume()            :Number { return sound.getVolume(); }
	public function set _volume(value:Number):Void   { sound.setVolume();        }

	
	//public function get _onSoundComplete():Function { return onSoundComplete; }
	//public function get _onLoopComplete() :Function { return onLoopComplete;  }
	
	//public function set _onSoundComplete(f:Function):Function { onSoundComplete = f; }
	//public function set _onLoopComplete(f:Function) :Function { onLoopComplete = f;  }
	
	/**
	 * コンストラクタです. 
	 * 
	 * @param	sound:Sound		Soundオブジェクトです. 
	 * @param	loops:Number	ループ回数です(デフォルト値=1). 
	 */
	public function BasicMusic(sound:Sound, loops:Number):Void {
		
		//EventDispatcherの初期化
		EventDispatcher.initialize(this);
		
		//Soundオブジェクト
		this.sound = sound;
		
		//再生完了するまでの再生回数
		this.loops = (loops == null || loops < 0) ? 1 : loops;
		
		//現在再生中であればtrue
		is_playing = false;
		
		//現在の再生回数
		count = 0;
		
		//再生箇所(ミリ秒)
		position = 0;
	}
	
	/**
	 * 再生開始します. 
	 * 
	 * @param second_offset:Number	再生を開始する位置(秒)
	 */
	public function start(second_offset:Number):Void {
		
		//再生回数を更新する
		count = 1;
		
		//一回毎の再生完了時に呼び出されるイベントハンドラを設定する
		sound.onSoundComplete = Delegate.create(this, onSoundCompleteHandler);
		
		//指定位置から再生を開始する
		sound.start(second_offset);
		
		is_playing = true;
	}
	
	/**
	 * 一回毎の再生完了時に呼び出されるイベントハンドラ
	 * 
	 */
	private function onSoundCompleteHandler():Void {
		
		//ループ再生完了しているかチェックする
		if (loops == 0 || count <= loops) {
			
			//一回毎の再生完了時に呼び出されるイベントを発行する
			//_onSoundComplete(this);
			dispatchEvent( { type:SOUND_COMPLETE, object:this } );
			
			//再生回数を更新する
			++count;
			
			//ループ再生する
			sound.start(0);
			
		} else {
			
			//一回毎の再生完了時に呼び出されるイベントを発行する
			//_onSoundComplete(this);
			dispatchEvent( { type:SOUND_COMPLETE, object:this } );
			
			//ループ再生完了時に呼び出されるイベントを発行する
			//_onLoopComplete(this);
			dispatchEvent( { type:LOOP_COMPLETE, object:this } );
		}
	}
	
	/**
	 * 再生停止します. 
	 * 
	 */
	public function stop():Void {
		
		sound.stop();
		
		position = 0;
		
		is_playing = false;
	}
	
	/**
	 * 一時停止します. 
	 * 
	 */
	public function pause():Void {
		
		//再生個所の保存
		position = sound.position;
		
		is_playing = false;
	}
	
	/**
	 * 再生再開します. 
	 * 
	 */
	public function resume():Void {
		
		//保存位置から再生を開始する
		start(position / 1000);
		
		is_playing = true;
	}
	
	/**
	 * 頭出しします. 
	 * 
	 */
	public function cue():Void {
		
		position = 0;
		
		//再生中であればそのまま再生
		if (is_playing) { start(position / 1000); }
	}
	
	/**
	 * 再生ヘッダを移動します. 
	 * 
	 */
	public function seek(millisecond:Number):Void {
		
		position = millisecond;
		
		//再生中であればそのまま再生
		if (is_playing) { start(position / 1000); }
	}
	
	/**
	 * 再生ヘッダをパーセンテージで移動します. 
	 * 
	 */
	public function seekPercent(percent:Number):Void {
		
		position = sound.duration * percent / 100;
		
		//再生中であればそのまま再生
		if (is_playing) { start(position / 1000); }
	}
	
	/**
	 * 再生回数をリセットします. 
	 * 
	 */
	public function reset():Void {
		
		count = 0;
	}
}
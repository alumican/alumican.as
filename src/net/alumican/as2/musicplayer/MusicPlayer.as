/** 
 * MusicPlayer
 * 
 * @author alumican<Yukiya Okuda>
 */
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import net.alumican.as2.musicplayer.IMusic;

class net.alumican.as2.musicplayer.MusicPlayer {
	
	/**
	 * 各種イベントトリガです. 
	 */
	static function get SOUND_COMPLETE():String { return "onSoundComplete"; }
	static function get LOOP_COMPLETE() :String { return "onLoopComplete";  }
	static function get PLAYLIST_EMPTY():String { return "onPlaylistEmpty"; }
	
	/**
	 * Soundオブジェクト生成用のMovieClipです. 
	 */
	static var soundclip:MovieClip;
	
	/**
	 * 再生中の曲を含めたプレイリストです. 
	 */
	private var playlist:Array;
	
	/**
	 * 曲が鳴っていればtrueです. 
	 */
	private var is_playing:Boolean;
	
	/**
	 * 音量です. 
	 */
	private var volume:Number;
	
	/**
	 * 停止/再生のボリュームコントロールをフェードで行うならばtrueです. 
	 */
	private var is_volume_fade:Boolean;
	
	/**
	 * ボリュームのフレーム毎変化スピードです. 
	 */
	private var volume_fade_speed:Number;
	
	/**
	 * onEnterFrame用MovieClipです. 
	 */
	private var volume_oef:MovieClip;
	
	/**
	 * EventDispatcher用関数群です. 
	 */
	private var dispatchEvent:Function;
	private var dispatchQueue:Function;
	public  var addEventListener:Function;
	public  var removeEventListener:Function;
	
	/**
	 * プレイリストを取得します. 
	 */
	public function get _playlist():Array { return playlist; }
	
	/**
	 * 予約リストを取得します. 
	 */
	public function get _booklist():Array {
		var n:Number = playlist.length;
		return (n > 1) ? ( playlist.slice(1, n - 1) ) : [];
	}
	
	/**
	 * 予約リストを設定します. 
	 */
	public function set _booklist(list:Array):Void {
		var n:Number = playlist.length;
		if (n > 0) {
			playlist = [playlist[0]].concat(list);
		} else {
			playlist = list;
		}
	}
	
	/**
	 * Soundオブジェクト生成用のMovieClipを取得します. 
	 */
	public function get _soundclip():MovieClip { return soundclip; }
	
	/**
	 * 曲が鳴っていればtrueです. 
	 */
	public function get _is_playing():Boolean { return is_playing; }
	
	/**
	 * 音量を取得/設定します. 
	 */
	public function get _volume():Number { return volume; }
	public function set _volume(value:Number):Void { setVolume(value, is_volume_fade); }
	
	/**
	 * 停止/再生のボリュームコントロールをフェードで行うならばtrueです. 
	 */
	public function get _is_volume_fade():Boolean { return is_volume_fade; }
	public function set _is_volume_fade(value:Boolean):Void { is_volume_fade = value; }
	
	/**
	 * ボリュームのフレーム毎変化スピードです. 
	 */
	public function get _volume_fade_speed():Number { return volume_fade_speed; }
	public function set _volume_fade_speed(value:Number):Void { volume_fade_speed = value; }
	
	/**
	 * コンストラクタです. 
	 * 
	 * @param	soundclip:MovieClip			Soundオブジェクトを生成するMovieClipです. 
	 * @param	is_volume_fade:Boolean		音量変化にフェードを用いるならばtrueを指定します(デフォルト値=true). 
	 * @param	volume_fade_speed:Number	音量変化のフレーム毎の変化量です(デフォルト値=5). 
	 */
	public function MusicPlayer(soundclip:MovieClip, is_volume_fade:Boolean, volume_fade_speed:Number) {
		
		//EventDispatcherの初期化
		EventDispatcher.initialize(this);
		
		//Soundオブジェクト生成用のMovieClip
		this.soundclip = soundclip;
		
		//再生中の曲を含めたプレイリスト
		playlist = new Array();
		
		//現在, 曲が再生途中であればtrue
		is_playing = false;
		
		//停止/再生のボリュームコントロールをフェードで行うならばtrue
		this.is_volume_fade = (is_volume_fade == null) ? true : is_volume_fade;
		
		//ボリュームのフレーム毎変化スピードです. 
		this.volume_fade_speed = (volume_fade_speed == null) ? 5 : volume_fade_speed;
		
		//onEnterFrame用MovieClipです. 
		volume_oef = soundclip.createEmptyMovieClip("volume_oef", soundclip.getNextHighestDepth());
	}
	
	/**
	 * プレイリストに曲を追加します. 
	 * position=0の場合には再生途中の曲を中断して割り込み, 再生中の曲は再生回数がリセットされた上で予約リストの先頭へ移動します. 
	 * 
	 * @param	m:IMusic		曲オブジェクト
	 * @param	position:Number	曲の予約リストへの挿入インデックス(デフォルト値=予約リストの最後尾)
	 * @return
	 */
	public function addMusic(m:IMusic, position:Number):Array {		
		
		var n:Number = playlist.length;
		
		if (n == 0) {
			playlist = [m];
			return;
		}
		
		if (position == null) { position = n; }
		if (position >  n   ) { position = n; }
		if (position <  0   ) { position = 0; }
		
		if (position == 0) {
			interrupt(m);
			return;
		}
		
		if (position == n) {
			playlist.unshift(m);
			return;
		}
		
		playlist = playlist.slice(0, position - 1).concat( m ).concat( playlist.slice(position, n - 1) );
	}
	
	/**
	 * 指定したKeyによって, プレイリストの曲を検索します. 
	 * 
	 * @param	key:String		曲のハッシュキーです. 
	 * @param	index:Array		曲のインデックスです. 先頭からインデックスを配列で返します. 見つからなかった場合は空配列[]を返します. 
	 */
	public function searchByKey(key:String):Array {
		
		var index:Array = new Array();
		
		var n:Number = playlist.length;
		
		for (var i:Number = 0; i < n; ++i) {
			
			if (playlist[i]._key == key) {
				
				index.push(i);
			}
		}
		
		return index;
	}
	
	/**
	 * 予約リストの頭から再生を開始します. 
	 * 既に再生中の場合には無効です. 
	 * 
	 */
	public function start():Void {
		
		if (is_playing) { return; }
		if (playlist.length == 0) { return; }
		
		addLoopCompleteListener();
		
		setVolume(volume, false);
		
		IMusic( playlist[0] ).start();
		
		is_playing = true;
	}
	
	/**
	 * 再生中の曲を停止します. 
	 * 再生回数はリセットされません. 
	 * 
	 */
	public function stop():Void {
		
		if (!is_playing) { return; }
		if (playlist.length == 0) { return; }
		
		IMusic( playlist[0] ).stop();
		
		is_playing = false;
	}
	
	/**
	 * 再生中の曲を頭出しします. 
	 * 再生回数はリセットされません. 
	 * 再生状態は保持されます. 
	 * 
	 */
	public function cue():Void {
		
		if (playlist.length == 0) { return; }
		
		IMusic( playlist[0] ).cue();
	}
	
	/**
	 * 再生中の曲を一時停止します. 
	 * 
	 */
	public function pause():Void {
		
		if (!is_playing) { return; }
		
		IMusic( playlist[0] ).pause();
		
		is_playing = false;
	}
	
	/**
	 * 再生中の曲を再開します. 
	 * 
	 */
	public function resume():Void {
		
		if (is_playing) { return; }
		
		is_playing = true;
	}
	
	/**
	 * 音量を100に設定します. 
	 */
	public function turnOn():Void {
		
		setVolume(100, is_volume_fade);
	}
	
	/**
	 * 音量を0に設定します. 
	 * 音量が0になっても曲は再生を続けます. 
	 * 
	 */
	public function turnOff():Void {
		
		setVolume(0, is_volume_fade);
	}
	
	/**
	 * 再生中の曲を中断して割り込みます. 
	 * 再生中の曲は再生回数がリセットされた上で予約リストの先頭に移動します. 
	 * 
	 * @param	m:IMusic	曲
	 */
	public function interrupt(m:IMusic):Void {
		
		if (playlist.length > 0) {
			
			removeLoopCompleteListener();
			
			var obj:IMusic = playlist[0];
			obj.stop();
			obj.reset();
			
			setVolume(volume, false);
			
			playlist.unshift(m);
			
		} else {
			
			playlist = [m];
		}
	}
	
	/**
	 * プレイリスト先頭の曲をスキップします. 
	 * 
	 * @param	n:Number	スキップ数
	 */
	public function skip(n:Number):Void {
		
		if (n == null) { n = 1; };
		
		removeLoopCompleteListener();
		
		volume_oef.onEnterFrame = null;
		
		IMusic( playlist[0] ).stop();
		
		playlist.splice(0, Math.min(n, playlist.length));
	}
	
	/**
	 * 音量を変化させます. 
	 * 
	 * @param	v:Number		音量です. 
	 * @param	fade:Boolean	フェードするならばtrue. 
	 */
	private function setVolume(v:Number, fade:Boolean):Void {
		
		v = Math.max(0, Math.min(100, v));
		
		if (v == volume) { return; }
		
		var m:IMusic = playlist[0];
		
		if (!fade) {
			
			volume_oef.onEnterFrame = null;
			
			volume = v;
			m._volume = volume;
			
			return;
		}
		
		var tmpvol:Number = volume;
		volume = v;
		
		if (v - tmpvol > 0) {
			
			volume_oef.onEnterFrame = Delegate.create(this, function():Void {
				
				tmpvol += volume_fade_speed;
				
				if (tmpvol >= v) {
					
					m._volume = volume;
					volume_oef.onEnterFrame = null;
					
				} else {
					
					m._volume = tmpvol;
				}
			});
			
		} else {
			
			volume_oef.onEnterFrame = Delegate.create(this, function():Void {
				
				tmpvol -= volume_fade_speed;
				
				if (tmpvol <= v) {
					
					m._volume = volume;
					volume_oef.onEnterFrame = null;
					
				} else {
					
					m._volume = tmpvol;
				}
			});
		}
	}
	
	/**
	 * プレイリスト先頭の曲が一回再生完了する毎に時に発行されるイベントのイベントハンドラです. 
	 * 
	 * @param	イベントオブジェクトです. 
	 */
	private function onSoundCompleteHandler(e:Object):Void {
		
		//イベントの発行
		dispatchEvent( { type:LOOP_COMPLETE, object:e.object} );
	}
	
	/**
	 * プレイリスト先頭の曲がループ回数再生完了した時に発行されるイベントのイベントハンドラです. 
	 * 
	 * @param	イベントオブジェクトです. 
	 */
	private function onLoopCompleteHandler(e:Object):Void {
		
		//再生完了したオブジェクトを削除する
		var prev:IMusic = playlist.shift();
		prev.stop();
		
		//次の曲がなければ終了
		if (playlist.length == 0) {
			dispatchEvent( { type:PLAYLIST_EMPTY } );
			return;
		}
		
		//次の曲を取得する
		var next:IMusic = playlist[0];
		
		//ループ回数再生完了のイベントを発行する
		dispatchEvent( { type:LOOP_COMPLETE, object:prev, next:next } );
		
		//次の曲を再生開始する
		next.start();
	}
	
	/**
	 * プレイリスト先頭の曲が再生完了した時に発行されるイベントのイベントハンドラを登録します. 
	 * 
	 */
	private function addLoopCompleteListener():Void {
		
		var m:IMusic = playlist[0];
		
		m.addEventListener(m.SOUND_COMPLETE, onSoundCompleteHandler);
		m.addEventListener(m.LOOP_COMPLETE , onLoopCompleteHandler );
	}
	
	/**
	 * プレイリスト先頭の曲が再生完了した時に発行されるイベントのイベントハンドラを解除します. 
	 * 
	 */
	private function removeLoopCompleteListener():Void {
		
		var m:IMusic = playlist[0];
		
		m.removeEventListener(m.SOUND_COMPLETE, onSoundCompleteHandler);
		m.removeEventListener(m.LOOP_COMPLETE , onLoopCompleteHandler );
	}
}
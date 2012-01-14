/** 
 * IMusic
 * 
 * @author alumican<Yukiya Okuda>
 */

interface net.alumican.as2.musicplayer.IMusic {
	
	/**
	 * 各種イベントトリガです. 
	 */
	static function get SOUND_COMPLETE():String;
	static function get LOOP_COMPLETE() :String;
	
		
	/**
	 * サウンドのタイプです. 
	 */
	public function get _type():String;
	
	/**
	 * 現在の再生回数です. 
	 * 
	 */
	public function get _count():Number;
	
	/**
	 * 再生完了する再生回数です. 
	 * 
	 */
	public function get _loops():Number;
	
	/**
	 * 曲が鳴っていればtrueです.  
	 * 
	 */
	public function get _is_playing():Boolean;
	
	/**
	 * 音量です. 
	 * 
	 */
	public function get _volume():Number;
	public function set _volume(value:Number):Void;
	
	/**
	 * 再生個所(ミリ秒)です. 
	 * 
	 */
	public function get _position():Sound;
	
	/**
	 * 再生時間(ミリ秒)です. 
	 * 
	 */
	public function get _duration():Sound;
	
	/**
	 * Soundオブジェクトです. 
	 * 
	 */
	public function get _sound():Sound;
	
	/**
	 * 再生開始します. 
	 * 
	 */
	public function start():Void;
	
	/**
	 * 再生停止します. 
	 * 
	 */
	public function stop():Void;
	
	/**
	 * 一時停止します. 
	 * 
	 */
	public function pause():Void;
	
	/**
	 * 再生再開します. 
	 * 
	 */
	public function resume():Void;
	
	/**
	 * 頭出しします. 
	 * 
	 */
	public function cue():Void;
	
	/**
	 * 再生ヘッダを移動します. 
	 * 
	 */
	public function seek(millisecond:Number):Void;
	
	/**
	 * 再生ヘッダをパーセンテージで移動します. 
	 * 
	 */
	public function seekPercent(percent:Number):Void;
	
	/**
	 * 再生回数をリセットします. 
	 * 
	 */
	public function reset():Void;
}
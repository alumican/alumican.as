/** 
 * ExternalMusic
 * 
 * @author alumican<Yukiya Okuda>
 */
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import net.alumican.as2.musicplayer.BasicMusic;
import net.alumican.as2.musicplayer.MusicPlayer;

class net.alumican.as2.musicplayer.ExternalMusic extends BasicMusic {
	
	/**
	 * サウンドのタイプです. 
	 */
	private var type:String = "external";
	
	/**
	 * 外部サウンドファイルのURLです. 
	 */
	private var url:String;
	
	/**
	 * ストリーミング再生であればtrueです. 
	 */
	private var is_streaming:Boolean;
	
	public function get _url()         :Number   { return url;          }
	public function get _is_streaming():Boolean  { return is_streaming; }
	
	/**
	 * コンストラクタです. 
	 * 
	 * @param	url:String				外部サウンドファイルのURLです. 
	 * @param	is_streaming:Boolean	ストリーミング再生であればtrueです. 
	 * @param	loops:Number			ループ回数です(デフォルト値=1). 
	 * @param	target:MovieClip		Soundオブジェクトを生成するMovieClipです(デフォルト値=MusicPlayer.soundclip). 
	 */
	public function ExternalMusic(url:String, is_streaming:Boolean, loops:Number, target:MovieClip):Void {
		
		//Soundオブジェクトを生成するMovieClip
		if (target == null) { target = MusicPlayer.soundclip; }
		
		//外部サウンドファイルのURL
		this.url = url;
		
		//ストリーミング再生であればtrue
		this.is_streaming = is_streaming;
		
		//Soundオブジェクトの生成
		var externalsound:Sound = new Sound(target);
		
		//Soundの読み込み
		externalsound.loadSound(this.url, this.is_streaming);
		
		//スーパークラスのコンストラクタの呼び出し
		super(externalsound, loops);
	}
}
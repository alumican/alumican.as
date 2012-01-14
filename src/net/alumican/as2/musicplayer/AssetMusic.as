/** 
 * AssetMusic
 * 
 * @author alumican<Yukiya Okuda>
 */
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import net.alumican.as2.musicplayer.BasicMusic;
import net.alumican.as2.musicplayer.MusicPlayer;

class net.alumican.as2.musicplayer.AssetMusic extends BasicMusic {
	
	/**
	 * サウンドのタイプです. 
	 */
	private var type:String = "asset";
	
	/**
	 * リンケージ識別子です. 
	 */
	private var linkage_id:String;
	
	/**
	 * リンケージ識別子を取得します. 
	 */
	public function get _linkage_id():Number  { return linkage_id; }
	
	/**
	 * コンストラクタです. 
	 * 
	 * @param	id:String			Soundオブジェクトです. 
	 * @param	loops:Number		ループ回数です(デフォルト値=1). 
	 * @param	target:MovieClip	Soundオブジェクトを生成するMovieClipです(デフォルト値=MusicPlayer.soundclip). 
	 */
	public function AssetMusic(id:String, loops:Number, target:MovieClip):Void {
		
		//Soundオブジェクトを生成するMovieClip
		if (target == null) { target = MusicPlayer.soundclip; }
		
		//リンケージ識別子
		linkage_id = id;
		
		//Soundオブジェクトの生成
		var assetsound:Sound = new Sound(target);
		
		//Soundのattach
		assetsound.attachSound(linkage_id);
		
		//スーパークラスのコンストラクタの呼び出し
		super(assetsound, loops);
	}
}
/**
 * EasyLoading
 * <p>ファイルの読み込みを簡単に行う関数を集めたクラスです. </p>
 * 
 **********************************************
 * 
 * @author alumican<Yukiya Okuda>
 * @link http://alumican.net
 * @version 1.0.0
 */

class net.alumican.as2.utils.EasyLoading {

	/**
	 * 外部swfまたは画像の読み込みを開始します. 
	 * 
	 * @param	url:String			読み込むファイルのURLです. 
	 * @param	target:MovieClip	読み込み先のMovieClipです. 
	 * @param	listener:Object		MovieClipLoaderのイベントを管理するリスナーオブジェクトです. 必ずしも必要ありません. 
	 * @return	読み込みに用いられているMovieClipLoaderです. 
	 * 
	 * @example	EasyLoading.loadClip("sample.jpg");
	 * @example	EasyLoading.loadClip("sample.jpg", mc);
	 * @example	EasyLoading.loadClip("sample.jpg", mc, listener);
	 */
	public static function loadClip(url:String, target:MovieClip, listener:Object):MovieClipLoader {
		var mcl:MovieClipLoader = new MovieClipLoader();
		var l:Object = (listener == null) ? (new Object()) : (listener);
		mcl.addListener(l);
		mcl.loadClip(url, target);
		return mcl;
	}
	
	/**
	 * XMLの読み込みを開始します. 
	 * 
	 * @param	url:String			読み込むファイルのURLです. 
	 * @param	ignoreWhite:Boolean	XMLのignoreWhiteオプションです. (デフォルト値=false)
	 * @param	target:XML			読み込み先のXMLオブジェクトです. (デフォルト値=null)
	 * @param	callback:Function	読み込み完了後に呼び出されるコールバック関数です. (デフォルト値=null)
	 * 
	 * @example	EasyLoading.loadXML("sample.xml");
	 * @example	EasyLoading.loadXML("sample.xml", xml);
	 * @example	EasyLoading.loadXML("sample.xml", xml, target);
	 * @example	EasyLoading.loadXML("sample.xml", xml, target, onLoadFunc);
	 */
	public static function loadXML(url:String, ignoreWhite:Boolean, target:XML, callback:Function):XML {
		var xml:XML = (target == null) ? (new XML()) : (target);
		xml.ignoreWhite = (ignoreWhite == null) ? false : ignoreWhite;
		if(callback != null) {
			xml.onLoad = function(success:Boolean):Void {
				callback(success, xml);
			};
		}
		xml.load(url);
		return xml;
	}
	
	/**
	 * Soundの読み込みを開始します. 
	 * 
	 * @param	url:String			読み込むファイルのURLです. 
	 * @param	isStreaming:Boolean	trueならばストリーミング形式で読み込みます. (デフォルト値=false)
	 * @param	target:Sound		読み込み先のSoundオブジェクトです. (デフォルト値=null)
	 * @param	callback:Function	読み込み完了後に呼び出されるコールバック関数です. (デフォルト値=null)
	 * 
	 * @example	EasyLoading.loadSound("sample.mp3");
	 * @example	EasyLoading.loadSound("sample.mp3", true);
	 * @example	EasyLoading.loadSound("sample.mp3", true, sound);
	 * @example	EasyLoading.loadSound("sample.mp3", true, sound, onLoadFunc);
	 */
	public static function loadSound(url:String, isStreaming:Boolean, target:Sound, callback:Function):Sound {
		var sound:Sound = (target == null) ? (new Sound()) : (target);
		if(callback != null) {
			sound.onLoad = function(success:Boolean):Void {
				callback(success, sound);
			};
		}
		sound.loadSound(url, (isStreaming == null) ? false : isStreaming);
		return sound;
	}
}
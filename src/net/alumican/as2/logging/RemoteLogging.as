/**
 * AS3->AS2移植
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 **
 * 
 * ログを任意のサーバーに転送するロギングクラス. 
 * <p>
 * サーバー側で、POSTパラメータlogでログ文字列を受け取るスクリプトを用意する必要があります
 * </p>
 * 
 * @access    public
 * @package   ken39arg.logging
 * @author    K.Araga
 * @version   $id : RemoteLogging.as, v 1.0 2008/02/15 K.Araga Exp $
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.RemoteLogging implements ILogging {
	
	private var _url:String;
	
	public function RemoteLogging(url:String) {
		_url = url;
	}
	
	public function put(string:String, level:Number):Void {
		
		var lv:LoadVars = new LoadVars();
		lv.log = string;
		lv.sendAndLoad(_url, new LoadVars(), "POST");
	}
}
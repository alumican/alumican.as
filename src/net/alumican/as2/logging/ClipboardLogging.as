/**
 * クリップボードにコピーするロギングクラス. 
 *
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.ClipboardLogging implements ILogging {
	
	public function put(string:String, level:Number):Void {
		System.setClipboard(string);
	}
}
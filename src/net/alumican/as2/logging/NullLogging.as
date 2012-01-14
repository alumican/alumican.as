/**
 * AS3->AS2移植
 * 何も出力しないロギングクラス. 
 *
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.NullLogging implements ILogging {
	
	public function put(string:String, level:Number):Void {}
}
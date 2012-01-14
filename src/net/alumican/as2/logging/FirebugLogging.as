/**
 * AS3->AS2移植
 * Firebugのコンソールに表示するロギングクラス
 * 
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import flash.external.ExternalInterface;
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.FirebugLogging implements ILogging {
	
	public function put(string:String, level:Number):Void {
		ExternalInterface.call('console.log', string);
	}
}
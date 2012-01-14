/**
 * ジョジョっぽくログを表示するロギングクラス. 
 * 
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.JojoLogging implements ILogging {
	
	private var _logger:ILogging;
	
	public function JojoLogging(logger:ILogging) {
		_logger = logger;
	}
	
	public function put(string:String, level:Number):Void {
		
		if(Math.random() < 0.1) {
			string = string + "無駄無駄無駄無駄無駄無駄ァ！！！";
		} else if(Math.random() < 0.2) {
			string = string + "バァ￣￣乙＿＿ンッ！！";
		} else if(Math.random() < 0.3) {
			string = "メメタァ！" + string;
		}
			
			_logger.put(string, level);
	}
}
/**
 * AS3->AS2移植
 * 複数の出力方法でログを表示するロギングクラス. 
 * 
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.PararelLogging implements ILogging {
	
	private var _loggers:Array;
	
	public function PararelLogging(loggers:Array) {
		_loggers = loggers;
	}
	
	public function put(string:String, level:Number):Void {
		
		for (var i:Number = 0; i<_loggers.length; i++) {
			var l:ILogging = ILogging(_loggers[i]);
			if (l) {
				l.put(string, level);
			}
		}
	}
}
/**
 * ログを指定したTextFieldに表示するロギングクラス. 
 * 
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 */
import net.alumican.as2.logging.ILogging;

class net.alumican.as2.logging.TextFieldLogging implements ILogging {
	
	private var _textfield:TextField;
	
	/**
	 * インスタンス生成時にログ表示用TextFieldを渡します. 
	 * @param	textfield	ログ表示用TextField
	 */
	public function TextFieldLogging(textfield:TextField) {
		_textfield = textfield;
	}
	
	public function put(string:String, level:Number):Void {
		if (_textfield) {
			_textfield.text += string + "\n";
		} else {
			throw new Error("Error(Logger): Not exist binded TextField.");
		}
	}
}
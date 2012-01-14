/**
 * AS3->AS2移植
 * @author alumican
 * @link http://alumican.net
 * @link http://www.libspark.org
 **
 * 
 * ログの出力方法を定義するインターフェイス. 
 * 
 * Loggerクラスでの出力方法を定義します
 * 
 * @access    public
 * @package   ken39arg.logging
 * @author    K.Araga
 * @version   $id : ILogging.as, v 1.0 2008/02/15 K.Araga Exp $
 */
interface net.alumican.as2.logging.ILogging {
	
	/**
	 * 出力 
	 * @param string ログ文字列
	 * @param int      ログレベル
	 */
	function put(string:String, level:Number):Void;
}
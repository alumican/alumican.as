import net.alumican.as2.logging.ILogging;
import net.alumican.as2.logging.NullLogging;

class net.alumican.as2.logging.Logger {
	
	/**
	 * AS3用俺様Logger(http://level0.kayac.com/2008/08/as3logger.php)の移植版です. 
	 * といってもあまり移植できていません. 
	 * 
	 * @author alumican
	 * @link http://alumican.net
	 * @link http://www.libspark.org
	 * 
	 * @todo stactraceの実装  てかAS2でできんのこれ?
	 * 
	 ***使い方********************************************
	 * 
	 * //設定
	 * Logger.errorLevel = Logger.INFO; //出力するエラーレベル
	 * Logger.setLogging(new TraceLogging()); //ログの取り方
	 * 
	 * //デバッグ
	 * Logger.debug("a");
	 * Logger.info("a");
	 * Logger.warn("a");
	 * Logger.error("a");
	 * Logger.fatal("a");
	 * 
	 ***original********************************************
	 * 
	 * ログ出力を一元管理するためのクラスです. 
	 * 
	 * ILoggingをセットして使用します. 
	 * 例えばILoggingでtraceで出力したり、ファイル出力したり、サーバーに送信したりするクラスを作成することで
	 * エラーなどのログをプロジェクトのポリシーや開発時などで変更することが出来ます。
	 * 
	 * @access    public
	 * @package   ken39arg.logging
	 * @author    K.Araga
	 * @version   $id : Logger.as, v 1.0 2008/02/15 K.Araga Exp $
	 * 
	 *******************************************************
	 * 
	 */
	
	// 出力レベル
	
	
	/**
	 * エラーレベル：DEBUG. 
	 */
	static function get DEBUG():Number   { return 0; }
	
	/**
	 * エラーレベル：INFO. 
	 */
	static function get INFO():Number    { return 1; }
	
	/**
	 * エラーレベル：WARNING. 
	 */
	static function get WARNING():Number { return 2; }
	
	/**
	 * エラーレベル：ERROR. 
	 */
	static function get ERROR():Number   { return 3; }
	
	/**
	 * エラーレベル：FATAL. 
	 */
	static function get FATAL():Number   { return 4; }
	
	/**
	 *　エラーレベル. 
	 * 
	 * エラーレベルは下記の順に重要度が変わります. 
	 * DEBUG < INFO < WARNING < ERROR < FATAL
	 * 
	 * @default 1 (Logger.INFO)
	 */
	static var errorLevel:Number = INFO;
	
	/**
	 * スタックトレース出力フラグ. 
	 * 
	 * trueにしておくとスタックトレースを出力します. 
	 * スタックトレースの出力はエラーレベルに関係なく出力されます.
	 * @default false
	 */
	static var useStacTrace:Boolean = false;
	
	/**
	 * ダンプ出力フラグ. 
	 * 
	 * trueにしておくとダンプを出力します. 
	 * ダンプの出力はエラーレベルに関係なく出力されます. 
	 * ダンプの出力はデバッグ時に非常に有効ですが、１行ずつLoggingにputするので重いです
	 * @default false
	 */
	static var useVerdump:Boolean = false;
	
	/**
	 * ログ出力を行うオブジェクト. 
	 */
	static var _logging:ILogging = new NullLogging();
	
	/**
	 * ログ出力を行うオブジェクトをセットします. 
	 * 
	 * Loggingオブジェクトを柔軟に変更することでプロジェクトポリシーに従った柔軟なログ出力が可能となります. 
	 * またデフォルトはNullLoggingがセットされておりこのままではエラーレベルに関係なく何もしません 
	 * @param loggingObj
	 * 
	 */
	static function setLogging(loggingObj:ILogging):Void {
		_logging = loggingObj;
	}
	
	/**
	 * DEBUGレベルのログ出力を行う
	 * @param m	ログ
	 * 
	 */
	static function debug(m:Object):Void {
		if (errorLevel <= DEBUG) {
			put("[DEBUG] " + m, DEBUG);
		}
	}
	
	/**
	 * INFOレベルのログ出力を行う
	 * @param m	ログ
	 * 
	 */
	static function info(m:Object):Void {
		if (errorLevel <= INFO) {
			put("[INFO] " + m, INFO);
		}
	}
	
	/**
	 * warnレベルのログ出力を行う
	 * @param m	ログ
	 * 
	 */
	static function warn(m:Object):Void {
		if (errorLevel <= WARNING) {
			put("[WARNING] " + m, WARNING);
		}
	}
	
	/**
	 * ERRORレベルのログ出力を行う
	 * @param m	ログ
	 * 
	 */
	static function error(m:Object):Void {
		if (errorLevel <= ERROR) {
			put("[ERROR] " + m, ERROR);
		}
	}
	
	/**
	 * FATALレベルのログ出力を行う
	 * @param m	ログ
	 * 
	 */
	static function fatal(m:Object):Void {
		if (errorLevel <= FATAL) {
			put("[FATAL] " + m, FATAL);
		}
	}
	
	/**
	 *　スタックトレースを出力する. 
	 * 
	 * エラーがどこで発生しているのか知りたいときにつかえるつもり
	 * @param m
	 * 
	static function stactrace(m:Object):Void {
		
		if (!useStacTrace) { return; }
		
		var e:Error;
		if (m is Error) {
			e = m as Error;
		} else {
			e = new Error(m);
		}
		put("[" + m + "]\n" + e.getStackTrace());
	}
	*/
	
	/**
	 * オブジェクトのダンプを出力します. 
	 * 
	 * @todo Object型以外をダンプしたい
	 * @param value
	 * @param name
	 * @param indent
	 * 
	 */
	static function putVardump(value:Object, name:String, indent:String):Void {
		
		if (!useVerdump) { return; }
		
		if (name   == null) { name   = ""; }
		if (indent == null) { indent = ""; }
		
		//if (value  == null) { value  = "NULL"; }
		
		var type:String = typeof(value);
		
		if (name == "") {
			put(indent + "(" + type + "):" + value.toString());	
		} else {
			put( indent + "[" + name + "] => " + "(" + type + "):" + value.toString());
		}
		
		if (type == "object" || type == "xml") {
			indent += "    ";
			for (var key:String in value) {
				putVardump(value[key], key, indent);
			}
		}
	}
	
	/**
	 * ログの出力を行う. 
	 * @param	string	ログ
	 * @param	level	エラーレベル(デフォルトでDEBUG)
	 */
	static function put(string:String, level:Number):Void {
		if (level == null) { level = 0; }
		_logging.put(string, level);
	}
}
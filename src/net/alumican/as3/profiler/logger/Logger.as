package net.alumican.as3.profiler.logger
{
	/**
	 * aragaさんの俺様Loggerの拡張クラスです．
	 * ログ出力のフィルタリングに対応しているので，複数人でのオーサリングに適しています．
	 * 
	 * @package   knet.alumican.as3.logger
	 * @author    alumican.net<Yukiya Okuda>
	 * 
	 * 
	 * 
	 * -----------------------------------------------------------------------------------------------------
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
	 */
	public class Logger
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * 設定変更をのロック解除をおこなうためのマスターパスワードです．
		 * Loggerの設定を上書きされないようにするためには0以外の数値に書き換えます．
		 * デフォルトは0であり，この場合は無条件に設定変更が可能であり，lockメソッドやunlockメソッドでもロックされません．
		 * @default 0
		 */
		public static const LOCK_PASSWD:int = 0;
		
		
		
		
		
		/**
		 * エラーレベル : DEBUG. 
		 */
		public static const DEBUG:int = 0;
		
		/**
		 * エラーレベル : INFO. 
		 */
		public static const INFO:int  = 10;
		
		/**
		 * エラーレベル : WARN. 
		 */
		public static const WARN:int  = 20;
		
		/**
		 * エラーレベル : ERROR. 
		 */
		public static const ERROR:int = 30;
		
		/**
		 * エラーレベル : FATAL. 
		 */
		public static const FATAL:int = 40;
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * エラーレベル. 
		 * 
		 * エラーレベルは下記の順に重要度が変わります. 
		 * DEBUG < INFO < WARNING < ERROR < FATAL
		 * @default 1 (Logger.INFO)
		 */
		public static function get level():int { return _level; }
		public static function set level(value:int):void { if (_isLocked) return; _level = value; }
		private static var _level:int = INFO;
		
		/**
		 * 出力フィルタ．
		 * 
		 * Loggerのフィルタと，出力メソッドのグループの論理積が0以外の時に限りログが出力されます．
		 * @default 0x0001
		 */
		public static function get filter():uint { return _filter; }
		public static function set filter(value:uint):void { if (_isLocked) return; _filter = value; }
		private static var _filter:uint = 0x0001;
		
		/**
		 * スタックトレース出力フラグ. 
		 * 
		 * trueにしておくとスタックトレースを出力します. 
		 * スタックトレースの出力はエラーレベルに関係なく出力されます.
		 * @default false
		 */
		public static function get useStactrace():Boolean { return _useStactrace; }
		public static function set useStactrace(value:Boolean):void { if (_isLocked) return; _useStactrace = value; }
		private static var _useStactrace:Boolean = false;
		
		/**
		 * ダンプ出力フラグ. 
		 * 
		 * trueにしておくとダンプを出力します. 
		 * ダンプの出力はエラーレベルに関係なく出力されます. 
		 * ダンプの出力はデバッグ時に非常に有効ですが、１行ずつLoggingにputするので重いです. 
		 * @default false
		 */
		public static function get useDump():Boolean { return _useDump; }
		public static function set useDump(value:Boolean):void { if (_isLocked) return; _useDump = value; }
		private static var _useDump:Boolean = false;
		
		/**
		 * ログ出力を行うオブジェクトをセットします. 
		 * 
		 * Loggingオブジェクトを柔軟に変更することでプロジェクトポリシーに従った柔軟なログ出力が可能となります. 
		 * またデフォルトはNullLoggingがセットされておりこのままではエラーレベルに関係なく何もしません . 
		 * @default NullLogging
		 * 
		 */
		public static function get logging():ILogging { return _logging; }
		public static function set logging(value:ILogging):void { if (_isLocked) return; _logging = value || new NullLogging(); }
		private static var _logging:ILogging = new NullLogging();
		
		/**
		 * 設定変更されないようにロックされている場合はtrueとなります．
		 * @default false
		 */
		private static var _isLocked:Boolean = LOCK_PASSWD != 0;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * DEBUGレベルのログ出力を行います．
		 * @param	m
		 * @param	group
		 * 
		 */
		public static function debug(m:*, group:uint = 0x0001):void
		{
			if (level <= DEBUG && (filter & group) != 0) _logging.put("[DEBUG] " + m, DEBUG);
		}
		
		/**
		 * INFOレベルのログ出力を行います．
		 * @param m
		 * 
		 */
		public static function info(m:*, group:uint = 0x0001):void
		{
			if (level <= INFO && (filter & group) != 0) _logging.put(" [INFO] " + m, INFO);
		}
		
		/**
		 * warnレベルのログ出力を行います．
		 * @param	m
		 * @param	group
		 * 
		 */
		public static function warn(m:*, group:uint = 0x0001):void
		{
			if (level <= WARN && (filter & group) != 0) _logging.put(" [WARN] " + m, WARN);
		}
		
		/**
		 * ERRORレベルのログ出力を行います．
		 * @param	m
		 * @param	group
		 * 
		 */
		public static function error(m:*, group:uint = 0x0001):void
		{
			if (level <= ERROR && (filter & group) != 0) _logging.put("[ERROR] " + m, ERROR);
		}
		
		/**
		 * FATALレベルのログ出力を行います．
		 * @param	m
		 * @param	group
		 */
		public static function fatal(m:*, group:uint = 0x0001):void
		{
			if (level <= FATAL && (filter & group) != 0) _logging.put("[FATAL] " + m, FATAL);
		}
		
		/**
		 * 任意のエラーレベルでログを出力します．
		 * @param	m
		 * @param	level
		 * @param	group
		 */
		public static function print(m:*, level:int = 0, group:uint = 0x0001):void
		{
			if (level <= Logger.level && (filter & group) != 0) _logging.put(m, level);
		}
		
		
		
		
		
		/**
		 * 設定変更のロックを解除するためにパスワードを照合する関数です．
		 * すでにロック解除されている場合に間違ったパスワードを入力するとロックされます．
		 * マスターパスワードが0の場合は間違ったパスワードを入力してもロックされません．
		 * @param	key
		 * @return
		 */
		public static function unlock(key:int):Boolean
		{
			return _isLocked = LOCK_PASSWD != 0 && LOCK_PASSWD != key;
		}
		
		/**
		 * 設定変更できないようにロックします．
		 * マスターパスワードが0の場合はロックされません．
		 */
		public static function lock():void
		{
			_isLocked = LOCK_PASSWD != 0 ? true : false;
		}
		
		
		
		
		
		/**
		 * スタックトレースを出力します．
		 * 
		 * エラーがどこで発生しているのか知りたいときにつかえるつもり
		 * @param m
		 * 
		 */
		public static function stactrace(m:*, group:uint = 0x0001):void
		{
			if (!useStactrace || (filter & group) == 0) return;
			var e:Error = (m is Error) ? m as Error : new Error(m);
			print("[" + m + "]\n" + e.getStackTrace());
		}
		
		
		
		
		
		/**
		 * オブジェクトのダンプを出力します. 
		 * 
		 * @todo Object型以外をダンプしたい
		 * @param value
		 * @param name
		 * @param indent
		 * 
		 */
		public static function dump(value:*, group:uint = 0x0001, name:String = "", indent:String = ""):void
		{
			if (useDump && (filter & group) != 0) _dump(value);
		}
		
		private static function _dump(value:*, name:String = "", indent:String = ""):void
		{
			if (value == null) value = String("NULL");
			var type:String = typeof value;
			if (name == "")
			{
				print(indent + "(" + type + "):" + value.toString());
			}
			else
			{
				print( indent + "[" + name + "] => " + "(" + type + "):" + value.toString());
			}
			if (type == "object" || type == "xml")
			{
				indent += "    ";
				for (var key:String in value)
				{
					_dump(value[key], key, indent);
				}
			}
		}
	}
}
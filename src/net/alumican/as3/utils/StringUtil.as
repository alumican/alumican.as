package net.alumican.as3.utils
{
	import flash.system.Capabilities;
	
	/**
	 * StringUtils
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class StringUtil
	{
		/**
		 * 改行コード定数です．
		 */
		static public const CR:String   = String.fromCharCode(10); // \n
		static public const LF:String   = String.fromCharCode(13); // \r
		static public const CRLF:String = CR + LF;                 // \n\r
		
		/**
		 * OSに合わせた改行コードを取得します．
		 */
		static public function get NEWLINE():String
		{
			var os:String = Capabilities.os.split(" ")[0];
			
			return (os == "Windows") ? CR   : // win
			       (os == "Linux"  ) ? CRLF : // unix
			       (os == "MacOS"  ) ? LF   : // mac
			                           CR   ; // others
		}
		
		/**
		 * LFやCRLFな改行コードをCRに書き換えます．
		 * @param	string
		 * @return
		 */
		static public function toCR(src:String):String
		{
			return src.replace(/\n?\r/g, CR);
		}
		
		/**
		 * 符号無し整数をカンマ区切り文字列に変換する
		 * @param	value
		 * @param	interval
		 * @param	separator
		 * @return
		 */
		static public function toPriceString(value:*, interval:uint = 3, separator:String = ","):String
		{
			var src:Array = String(value).split("");
			var i:int = src.length - interval;
			while (i > 0)
			{
				src.splice(i, 0, separator);
				i -= interval;
			}
			return src.join("");
		}
		
		/**
		 * 文字列を指定文字数の文字列に変換する
		 * @param	value
		 * @param	maxCount
		 * @return
		 */
		static public function toAbbrString(value:String, maxCount:uint, ellipsis:String = "…"):String
		{
			return (value.length > maxCount) ? (value.substr(0, maxCount - ellipsis.length) + ellipsis) : value;
		}
		
		/**
		 * 文字列の前後を指定文字で埋めた文字列を返す
		 * @param	value
		 * @param	length
		 * @param	fillString
		 * @param	fillBefore
		 * @return
		 */
		static public function toFilledString(value:String, length:uint, fillString:String = " ", fillBefore:Boolean = true):String
		{
			if (value.length >= length) return value;
			do
			{
				value = fillBefore ? (fillString + value) : (value + fillString);
			}
			while (value.length < length);
			if (value.length > length)
			{
				value = fillBefore ? value.substring( -length, length) : value.substring(0, length);
			}
			return value;
		}
		
		/**
		 * 改行/タブを取る
		 * @param	s
		 * @return
		 */
		static public function removeReturn(s:String):String
		{
			return s.replace(/\r\n|\r|\n|\t|\f/g, "");
		}
		
		/**
		 * 先頭のスペースを取る
		 * @param	s
		 * @return
		 */
		static public function removeHeadSpace(s:String):String
		{
			return s.replace(/^[\s　]+/g, "");
		}
		
		/**
		 * 末尾のスペースを取る
		 * @param	s
		 * @return
		 */
		static public function removeTailSpace(s:String):String
		{
			return s.replace(/[\s　]+$/g, "");
		}
	}
}
import Base64;

class Utils {

	//===========================================
	//BASIC認証を用いたCGI用からXMLデータを取得する
	//===========================================
	static function loadXmlUsingBasic(__xml:XML, __url:String, __userid:String, __password:String):Void {
		var load_vars = new LoadVars();
		addBasicRequestHeader(load_vars, __userid, __password);
		load_vars.sendAndLoad(__url, __xml, "post");
	}

	//===========================================
	//BASIC認証ヘッダをLoadeVarsに付加する
	//===========================================
	static function addBasicRequestHeader(__lv:LoadVars, __userid:String, __password:String):Void {
		var basic = __userid + ":" + __password;
		var auth = Base64.Encode(basic);
		__lv.addRequestHeader("Authorization", "Basic " + auth);
	}

	//===========================================
	//0埋め整形文字を数値に変換する 0010 → 10
	//===========================================
	static function toNumber(__str:String):Number {
		var tmp:Array = __str.split("");
		if (tmp.length == 1) {
			return parseInt(tmp[0]);
		}
		while (tmp[0] == "0") {
			tmp.shift();
		}
		var s:String = tmp.join("");
		return parseInt(s);
	}

	//===========================================
	//数値を指定桁数の文字列に変換する 10 → 0010
	//===========================================
	static function toNDigitString(__n:Number, __digit:Number):String {
		var str:String = __n.toString();
		while (str.length < __digit) {
			str = "0" + str;
		}
		return str;
	}

	//===========================================
	///文字列を指定長になるように前後をスペースで埋める "abc" → "abc  " or "  abc" or " abc "
	//===========================================
	static function toFillSpacingString(__s:String, __digit:Number, __align:String):String {
		var str:String = toFillCharacterString(__s, __digit, __align, " ");
		return str;
	}

	//===========================================
	//文字列を指定長になるように前後を指定文字で埋める
	//===========================================
	static function toFillCharacterString(__s:String, __digit:Number, __align:String, __c):String {
		var str:String = new String(__s);
		switch (__align) {
		case "left" :
			while (str.length < __digit) {
				str = str + __c;
			}
			break;
		case "right" :
			while (str.length < __digit) {
				str = __c + str;
			}
			break;
		case "center" :
			var flag:Boolean = true;
			while (str.length < __digit) {
				(flag) ? (str = str + __c) : (str = __c + str);
				flag = !flag;
			}
			break;
		}
		return str;
	}

	//===========================================
	//[min, max)範囲内の乱数を生成する
	//===========================================
	static function randomIn(__min:Number, __max:Number):Number {
		return Math.random() * (__max - __min) + __min;
	}

	//===========================================
	//符号を返す
	//===========================================
	static function sign(__n:Number):Number {
		return (__n < 0) ? (-1) : (1);
	}

	//===========================================
	//MovieClipLoaderを用いた読み込みを簡易的に行う
	//===========================================
	static function mclLoading(__url:String, __target:MovieClip, __listener:Object):MovieClipLoader {
		var mcl:MovieClipLoader = new MovieClipLoader();
		var listener:Object = (__listener == null) ? (new Object()) : (__listener);
		mcl.addListener(listener);
		mcl.loadClip(__url, __target);
		return mcl;
	}

	//===========================================
	//テキストフィールドの行数を数える
	//===========================================
	static function tfRows(__tf:TextField):Number {
		var format:TextFormat = __tf.getTextFormat();
		var tmp:TextFormat = __tf.getTextFormat();
		tmp.leading = 2;
		__tf.setTextFormat(tmp);
		var rows:Number = __tf.maxscroll;
		__tf.setTextFormat(format);
		return rows;
	}

	//===========================================
	//文字列中のCR, LF, CR/LF改行コードを<br />に統一する
	//===========================================
	static function lineFeedCodeToBR(__str:String):String {
		return __str.split("\r\n").join("<br />").split("\r").join("<br />");
	}

	//===========================================
	//文字列中のCR, LF, CR/LF改行コードをLFに統一する
	//===========================================
	static function lineFeedCodeToLF(__str:String):String {
		return __str.split("\r\n").join("\n").split("\r").join("\n");
	}

	//===========================================
	//デバッグ出力
	//===========================================
	static function log(__message:Object):Void {
		StaticVars.root.trace_tf.text += __message + "\n";
		trace(__message);
	}
}

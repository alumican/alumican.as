import mx.utils.Delegate;

class CountTrigger {
	
	//======================================
	//メンバ
	//======================================
	
	//カウンタの目標値
	private var _target:Number;
	
	//現在のカウンタ
	private var _count:Number;
	
	//現在までに条件を満たした回数
	private var _total:Number;

	//現在までにカウンタが更新された回数
	private var _moved:Number;

	//条件を満たしていれば真
	private var _flag:Boolean;
	
	//採用される比較関数
	private var _operator:Function;
	
	//条件を満たした場合のコールバック関数
	private var _onComplete:Function;
	
	//カウンタが更新された場合のコールバック関数
	private var _onUpdate:Function;
	
	//-------------------------------------------------------------------------------
	//getter/setter
	public function get count():Number { return _count; }
	public function get target():Number { return _target; }
	public function get flag():Boolean { return _flag; }
	public function get total():Number { return _total; }
	public function get moved():Number { return _moved; }

	public function get onComplete():Function { return _onComplete; }
	public function set onComplete(__val:Function):Void { _onComplete = __val; }
	
	public function get onUpdate():Function { return _onUpdate; }
	public function set onUpdate(__val:Function):Void { _onUpdate = __val; }
	
	//-------------------------------------------------------------------------------
	//イベント用オブジェクト生成関数
	private function EVENT_COMPLETE():Object { return {count:_count, target:_target, flag:_flag, total:_total, moved:_moved}; }
	private function EVENT_UPDATE():Object   { return {count:_count, target:_target, flag:_flag, total:_total, moved:_moved}; }

	//-------------------------------------------------------------------------------
	//比較関数
	static function EQ(a:Number, b:Number):Boolean { return (a == b) ? true : false;}
	static function NE(a:Number, b:Number):Boolean { return (a != b) ? true : false;}
	static function GT(a:Number, b:Number):Boolean { return (a >  b) ? true : false;}
	static function GE(a:Number, b:Number):Boolean { return (a >= b) ? true : false;}
	static function LT(a:Number, b:Number):Boolean { return (a <  b) ? true : false;}
	static function LE(a:Number, b:Number):Boolean { return (a <= b) ? true : false;}

	//======================================
	//コンストラクタ(2番目の引数以降は省略化)
	//======================================
	public function CountTrigger(__target:Number, __init_count:Number, __operator:Function, __onComplete:Function) {

		if(isValid(__target)) {
			_target = __target;
		} else {
			throw new Error("最低1つの引数が必要です at CountTrigger");
		}

		_total = 0;
		_moved = 0;
		
		_count    = (isValid(__init_count)) ? __init_count : 0;
		_operator = (isValid(__operator))   ? __operator   : CountTrigger.EQ;

		if(_operator < 0 || _operator > 5) {
			throw new Error("比較演算子が無効です at CountTrigger");
		}

		if(isValid(__onComplete)) {
			_onComplete = __onComplete;
		}

		check();
	}

	//======================================
	//カウンタの更新(カウンタ値を一定数加算する, 引数省略時は+1)
	//======================================
	public function countUp(__c:Number):Void {
		(isValid(__c)) ? (_count += __c) : (++_count);
		++_moved;
		check();
	}

	//======================================
	//カウンタの更新(カウンタ値を定数にする)
	//======================================
	public function countSet(__c:Number):Void {
		if(isValid(__c)) {
			_count = __c;
			++_moved;
			check();
		} else {
			throw new Error("引数が必要です at CountTrigger");
		}
	}

	//======================================
	//条件を満たしているかチェックする
	//======================================
	private function check():Void {
		_flag = _operator(_count, _target);
		if(_flag) {
			++_total;
			if(_moved > 0) { _onUpdate(EVENT_UPDATE()); }
			_onComplete(EVENT_COMPLETE());
		} else {
			if(_moved > 0) { _onUpdate(EVENT_UPDATE()); }
		}
	}

	//======================================
	//有効な変数かどうかチェックする
	//======================================
	private function isValid(__value:Object):Boolean {
		switch(__value) {
			//null || undefinedならば有効でないと判断する
			case undefined:
			case null:
				return false;
			//それ以外なら有効
			default:
				return true;
		}
	}
}
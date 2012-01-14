/**
 * Alignment
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.geom.Point;
import mx.utils.Delegate;
 
class net.alumican.as2.alignment.Alignment {
	
	static var _list:Array;
	
	static var _listener:Object;
	
	static var _stagew:Number;
	static var _stageh:Number;
	
	static function get TL():Number { return 0; }
	static function get LT():Number { return 0; }
	static function get BL():Number { return 1; }
	static function get LB():Number { return 1; }
	static function get TR():Number { return 2; }
	static function get RT():Number { return 2; }
	static function get BR():Number { return 3; }
	static function get RB():Number { return 3; }
	
	public function Alignment() {
		throw new Error("usage: Alignment.resist();");
	}
	
	/**
	 * 初期化関数を最初に必ず実行する必要があります. 
	 * 
	 */
	static function initialize() {
		
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		
		_list = new Array();
		
		_listener = new Object();
		_listener.onResize = Delegate.create(_root, _onResizeEvent);
		Stage.addListener(_listener);
		
		_onResizeEvent();
	}
	
	/**
	 * リサイズ時に位置合わせを行うMovieClipの登録を行います. 
	 * 
	 * @param	target:MovieClip			リサイズ時に位置合わせを行うMovieClip
	 * @param	align:Number				整列方向 Alignment.TL or Alignment.BL or Alignment.TR or Alignment.BR
	 * @param	margin:Array				整列方向端からのマージン[top, right, bottom, left](デフォルトは[0, 0, 0, 0])
	 * @param	global:Boolean				階層を無視して位置合わせを行う場合はtrue(デフォルトはtrue)
	 * @param	reposition:Boolean			リサイズ時にMovieClipを再配置させるならtrue, 座標値だけ取得するならfalse(デフォルトはtrue)
	 * @param	init:Boolean				登録時に位置合わせを行うならばtrue(デフォルトはtrue)
	 * @param	callback(e:Object):Function	リサイズ時のコールバック関数(e.x:Number=x座標値, e.y:Number=y座標値)(デフォルトはnull)
	 * 
	 */
	static function register(target:MovieClip, align:Number, margin:Array, global:Boolean, reposition:Boolean, init:Boolean, callback:Function):Void {
		
		var f:Function;
		
		switch(align) {
			case TL:
				f = _alignTL;
				break;
			case BL:
				f = _alignBL;
				break;
			case TR:
				f = _alignTR;
				break;
			case BR:
				f = _alignBR;
				break;
			default:
				throw new Error("error(Alignment.resist):argument \"align\" allows range in [0, 3]");
				return;
		}
		
		if (margin == null) { margin = [0, 0, 0, 0]; }
		
		if (global == null) { global = true; }
		
		if (reposition == null) { reposition = true; }
		
		if (init == null) { init = true; }
		
		var o:Object = { target:target, f:f, margin:margin, global:global, reposition:reposition, callback:callback };
		
		_list.push(o);
		
		if(init) { _calcPosition(o); }
	}
	
	static function _onResizeEvent():Void {
		_stagew = Stage.width;
		_stageh = Stage.height;
		
		for (var i:Number = _list.length - 1; i >= 0; --i) {
			if (_list[i].target) {
				_calcPosition(_list[i]);
			} else {
				_list.splice(i, 1);
			}
		}
	}
	
	static function _calcPosition(o:Object):Void {
		
		var target:MovieClip = o.target;
		
		var p:Point = o.f(o.margin);
		
		if(o.global) {
			target._parent.globalToLocal(p);
		}
		
		if (o.reposition) {
			target._x = p.x;
			target._y = p.y;
		}
		
		o.callback( { x:p.x, y:p.y } );
	}
	
	static function _alignTL(margin:Array):Point {
		return new Point(margin[3], margin[0]);
	}
	
	static function _alignBL(margin:Array):Point {
		return new Point(margin[3], _stageh - margin[2]);
	}
	
	static function _alignTR(margin:Array):Point {
		return new Point(_stagew - margin[1], margin[0]);
	}
	
	static function _alignBR(margin:Array):Point {
		return new Point(_stagew - margin[1], _stageh - margin[2]);
	}
}
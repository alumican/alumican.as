/**
 * Alignment
 * <p>ステージリサイズ時に自動的にMovieClipの位置合わせをしてくれるクラスです. </p>
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.geom.Point;
import mx.utils.Delegate;
 
class net.alumican.as2.utils.Alignment {
	
	static var _hash:Object;
	
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
		
		_hash = new Object();
		
		_listener = new Object();
		_listener.onResize = Delegate.create(_root, _onResizeEvent);
		Stage.addListener(_listener);
		
		_onResizeEvent();
	}
	
	/**
	 * リサイズ時に位置合わせを行うMovieClipの登録を行います. 
	 * 
	 * @param	target:MovieClip				リサイズ時に位置合わせを行うMovieClip
	 * @param	align:Number					整列方向 Alignment.TL or Alignment.BL or Alignment.TR or Alignment.BR
	 * @param	margin:Array					整列方向端からのマージン[top, right, bottom, left](デフォルトは[0, 0, 0, 0])
	 * @param	global:Boolean					階層を無視して位置合わせを行う場合はtrue(デフォルトはtrue)
	 * @param	reposition:Boolean				リサイズ時にMovieClipを再配置させるならtrue, 座標値だけ取得するならfalse(デフォルトはtrue)
	 * @param	init:Boolean					登録時に位置合わせを行うならばtrue(デフォルトはtrue)
	 * @param	onStart():Function				リサイズ実行前のコールバック関数(e.object=ターゲットオブジェクト)(デフォルトはnull)
	 * @param	onComplete(e:Object):Function	リサイズ実行後のコールバック関数(e.object=ターゲットオブジェクト, e.x:Number=x座標値, e.y:Number=y座標値)(デフォルトはnull)
	 * 
	 */
	static function register(target:MovieClip, align:Number, margin:Array, global:Boolean, reposition:Boolean, init:Boolean, onStart:Function, onComplete:Function):Void {
		
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
		
		var o:Object = { target:target, f:f, margin:margin, global:global, reposition:reposition, onStart:onStart, onComplete:onComplete };
		
		_hash[target] = o;
		
		if(init) { _calcPosition(o); }
	}
	
	/**
	 * リサイズ時に位置合わせを行うMovieClipの登録を取り消します. 
	 * @param	target:MovieClip	位置合わせの登録を取り消すMovieClip
	 */
	static function deregister(target:MovieClip):Void {
		delete _hash[target];
	}
	
	static function _onResizeEvent():Void {
		_stagew = Stage.width;
		_stageh = Stage.height;
		
		var o:Object;
		var mc:MovieClip;
		
		for (var key in _hash) {
			o = _hash[key];
			if (o.target._level != undefined) {
				_calcPosition(o);
			} else {
				delete _hash[key];
			}
		}
	}
	
	static function _calcPosition(o:Object):Void {
		
		o.onStart({object:o});
		
		var target:MovieClip = o.target;
		
		var p:Point = o.f(o.margin);
		
		if(o.global) {
			target._parent.globalToLocal(p);
		}
		
		if (o.reposition) {
			target._x = p.x;
			target._y = p.y;
		}
		
		o.onComplete( { object:o, x:p.x, y:p.y } );
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
	
	static function _alignMC(margin:Array):Point {
		return new Point(margin[3], margin[0]);
	}
}
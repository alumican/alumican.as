/**
 * Alignment
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.geom.Point;
import mx.utils.Delegate;
 
class net.alumican.as2.alignment.ImplAlignment {
	
	private var root:MovieClip;
	
	private var list:Array;
	
	private var listener:Object;
	
	private var stagew:Number;
	private var stageh:Number;
	
	static function get TL():Number { return 0; }
	static function get LT():Number { return 0; }
	static function get BL():Number { return 1; }
	static function get LB():Number { return 1; }
	static function get TR():Number { return 2; }
	static function get RT():Number { return 2; }
	static function get BR():Number { return 3; }
	static function get RB():Number { return 3; }
	
	public function ImplAlignment() {
		//throw new Error("usage: Alignment.resist();");
	}
	
	/**
	 * 初期化
	 * 
	 * @param	stage	基準となるStageを参照できるMovieClip
	 */
	public function initialize(root:MovieClip) {
		
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		
		this.root = root;
		
		
		listener = new Object();
		
		listener.onResize = Delegate.create(root, onResizeEvent);
		Stage.addListener(listener);
		
		onResizeEvent();
	}
	
	/**
	 * リサイズ時に位置合わせを行うMovieClipの登録
	 * 
	 * @param	target				リサイズ時に位置合わせを行うMovieClip
	 * @param	align				整列方向 Alignment.TL or Alignment.BL or Alignment.TR or Alignment.BR
	 * @param	margin				整列方向端からのマージン[px]
	 * @param	reposition			リサイズ時にMovieClipを再配置させるならtrue, 座標値だけ取得するならfalse
	 * @param	init				登録時に位置合わせを行うならばtrue
	 * @param	callback(e:Object)	リサイズ時のコールバック関数(e.x:Number=x座標値, e.y:Number=y座標値)
	 */
	public function register(target:MovieClip, align:Number, margin:Array, reposition:Boolean, init:Boolean, callback:Function):Void {
		
		var f:Function;
		
		switch(align) {
			case TL:
				f = alignTL;
				break;
			case BL:
				f = alignBL;
				break;
			case TR:
				f = alignTR;
				break;
			case BR:
				f = alignBR;
				break;
			default:
				throw new Error("error(Alignment.resist):argument \"align\" allows range in [0, 3]");
				return;
		}
		
		if (margin == null) { margin = [0, 0, 0, 0]; }
		
		if (reposition == null) { reposition = true; }
		
		if (init == null) { init = true; }
		
		var o:Object = { target:target, f:f, margin:margin, reposition:reposition, callback:callback };
		
		list.push(o);
		
		if(init) { calcPosition(o); }
	}
	
	private function onResizeEvent():Void {
		stagew = Stage.width;
		stageh = Stage.height;
		
		trace(list);
		
		/*
		for (var i:Number = list.length; i >= 0; --i) {
			if (list[i].target) {
				calcPosition(list[i]);
			} else {
				list.splice(i, 1);
			}
		}
		*/
	}
	
	private function calcPosition(o:Object):Void {
		
		var target:MovieClip = o.target;
		
		var p:Point = o.f(o.margin, stagew, stageh);
		
		//target._parent.globalToLocal(p);
		
		if (o.reposition) {
			target._x = p.x;
			target._y = p.y;
		}
		
		o.callback( { x:p.x, y:p.y } );
	}
	
	private function alignTL(margin:Array, w:Number, h:Number):Point {
		return new Point(margin[3], margin[0]);
	}
	
	private function alignBL(margin:Array, w:Number, h:Number):Point {
		return new Point(margin[3], h - margin[2]);
	}
	
	private function alignTR(margin:Array, w:Number, h:Number):Point {
		return new Point(w - margin[1], margin[0]);
	}
	
	private function alignBR(margin:Array, w:Number, h:Number):Point {
		return new Point(w - margin[1], h - margin[2]);
	}
}
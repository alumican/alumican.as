/**
 * Thumbnail
 * <p>リサイズ関係など, サムネイル生成にかかわる関数を集めます. </p>
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.display.BitmapData;
import flash.geom.Point;

class net.alumican.as2.utils.Thumbnail {
	
	/**
	 * コンストラクタ
	 * 
	 */
	public function Thumbnail() {
	}
	
	/**
	 * 指定されたサイズにフィットするように, オブジェクトのリサイズを行います. 
	 * <p>画像などはfitting=false, inner=trueを指定するといいかも知れません. </p>
	 * <p>背景などはfitting=true, inner=falseを指定するといいかも知れません. </p>
	 * <p>リサイズ対象のオブジェクトにマスクを使用していて, 見掛け上のサイズと_width,_heightの値が異なる場合にはrefにマスクを指定するといいかも知れません. </p>
	 * 
	 * @param	target:Object	リサイズ対象のオブジェクトです. 
	 * @param	bound_w:Number	境界の幅です. 
	 * @param	bound_h:Number	境界の高さです. 
	 * @param	fitting:Boolean	幅と高さ両方ともが境界よりも小さい場合に, 境界にフィッティングするようにリサイズを行うならばtrue(デフォルト値:false)
	 * @param	inner:Boolean	幅と高さ両方ともが境界よりも小さくなるようにリサイズを行うならばtrue(デフォルト値:true)
	 * @param	ref:Object		リサイズ対象のオブジェクトの幅と高さを取得するためのオブジェクト(デフォルト値:targetオブジェクト)
	 * @param	run:Boolean		実際にリサイズを実行するならばtrue(デフォルト値:true)
	 * @return	Point			リサイズ後の幅と高さ
	 */
	static function resize(target:Object, bound_w:Number, bound_h:Number, force_fit:Boolean, inner:Boolean, ref:Object, run:Boolean):Point {
		
		if (force_fit == null) { force_fit = false;  }
		if (inner     == null) { inner     = true;   }
		if (ref       == null) { ref       = target; }
		if (run       == null) { run       = true;   }
		
		var w:Number = ref._width;
		var h:Number = ref._height;
		
		var ratio:Number;
		var ret_w:Number;
		var ret_h:Number;
		
		var ratio_w:Number = bound_w / w;
		var ratio_h:Number = bound_h / h;
		
		if (inner) {
			
			//内側にフィットさせる
			
			//縦横共に境界内に収まっていて, なおかつ拡大フィットさせない場合にはそのまま返す
			if ((ratio_w > 1 && ratio_h > 1) && !force_fit) {
				var size:Point = returnSize(w, h);
				return size;
			}
			
			//リサイズ
			if (ratio_w < ratio_h) {
				ret_w = bound_w;
				ret_h = Math.round(h * ratio_w);
			} else {
				ret_w = Math.round(w * ratio_h);
				ret_h = bound_h;
			}
			
		} else {
			
			//外側にフィットさせる
			
			//縦横共に境界内に収まっていて, なおかつ拡大フィットさせない場合にはそのまま返す
			if ((ratio_w > 1 || ratio_h > 1) && !force_fit) {
				var size:Point = returnSize(w, h);
				return size;
			}
			
			//リサイズ
			if (ratio_w < ratio_h) {
				ret_w = Math.round(w * ratio_h);
				ret_h = bound_h;
			} else {
				ret_w = bound_w;
				ret_h = Math.round(h * ratio_w);
			}
		}
		
		var size:Point = returnSize(ret_w, ret_h);
		return size;
		
		//リサイズ後のサイズを返す
		function returnSize(width:Number, height:Number):Point {
			
			width  *= target._width  / ref._width;
			height *= target._height / ref._height;
			
			if (run) {
				target._width  = width;
				target._height = height;
			}
			return new Point(width, height);
		}
	}
	
	/**
	 * MovieClipをビットマップデータに転写します
	 * 
	 * @param	mc			転写元のMovieClip
	 * @param	use_alpha	アルファチャンネルを用いるかどうか(デフォルト値:true)
	 * @param	bgcolor		背景色の指定(use_alpha=trueの時には無効)(デフォルト値:0xffffff)
	 * @return	BitmapData	転写されたビットマップデータ
	 */
	static function getBitmapData(mc:MovieClip, use_alpha:Boolean, bgcolor:Number):BitmapData {
		
		if (use_alpha == null) { use_alpha = true;     }
		if (bgcolor   == null) { bgcolor   = 0xffffff; }
		
		var bmp:BitmapData = new BitmapData(mc._width, mc._height, use_alpha, bgcolor);
		
		bmp.draw(mc);
		
		return bmp;
	}
}
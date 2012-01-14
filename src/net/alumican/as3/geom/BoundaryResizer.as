package net.alumican.as3.geom
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	/**
	 * BoundaryResizer
	 * 様々なリサイズをRectangleベースで実行するクラスです．
	 * @see http://blog.alumican.net/2009/10/07_225251
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class BoundaryResizer
	{
		//-------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * scaleMode
		 * リサイズ方法を操作するscaleModeには以下の定数を指定できます．
		 */
		static public const EXACT_FIT:String = StageScaleMode.EXACT_FIT; // targetとboundaryが完全に一致するようにリサイズされます．多くの場合，targetの縦横比は保たれません．
		static public const SHOW_ALL:String  = StageScaleMode.SHOW_ALL;  // targetが縦横比を保ち，かつtargetがboundaryの内側にフィットするようにリサイズされます．targetがトリミングされることはありませんが，上下または左右に隙間ができることがあります．
		static public const NO_BORDER:String = StageScaleMode.NO_BORDER; // targetが縦横比を保ち，かつboundaryがtargetの内側にフィットするようにリサイズされます．targetとboundaryの間に隙間ができることはありませんが，targetがトリミングされることがあります．
		static public const NO_SCALE:String  = StageScaleMode.NO_SCALE;  // リサイズがおこなわれず，alignによる基準点合わせのみがおこなわれます．
		
		/**
		 * align
		 * リサイズ後のオブジェクトの基準点を操作するalignには以下の定数を指定できます．
		 */
		static public const TOP_LEFT:String     = StageAlign.TOP_LEFT;     // x軸方向:左  , y軸方向:上
		static public const TOP:String          = StageAlign.TOP;          // x軸方向:中央, y軸方向:上
		static public const TOP_RIGHT:String    = StageAlign.TOP_RIGHT;    // x軸方向:右  , y軸方向:上
		static public const LEFT:String         = StageAlign.LEFT;         // x軸方向:左  , y軸方向:中央
		static public const CENTER:String       = "";                      // x軸方向:中央, y軸方向:中央
		static public const RIGHT:String        = StageAlign.RIGHT;        // x軸方向:右  , y軸方向:中央
		static public const BOTTOM_LEFT:String  = StageAlign.BOTTOM_LEFT;  // x軸方向:左  , y軸方向:下
		static public const BOTTOM:String       = StageAlign.BOTTOM;       // x軸方向:中央, y軸方向:下
		static public const BOTTOM_RIGHT:String = StageAlign.BOTTOM_RIGHT; // x軸方向:右  , y軸方向:下
		
		
		
		
		
		//-------------------------------------
		//METHODS
		
		/**
		 * targetをboundaryに合わせてリサイズした矩形を返します．
		 * リサイズ方法と基準点をscaleMode，alignで指定できます．
		 * @param   target    リサイズ対象オブジェクトの矩形を指定します．(例)リサイズしたい画像の矩形
		 * @param   boundary  リサイズの基準となる矩形を指定します．(例)リサイズ後の画像を収める枠
		 * @param   scaleMode リサイズ時のスケールモードを指定します．このパラメータはStageScaleModeと互換性があります．このパラメータを省略した場合はBoundaryResizer.NO_SCALEとなり，リサイズはおこなわれません．
		 * @param   align     boundaryに対するtargetの基準位置を指定します．このパラメータはStageAlignと互換性があります．このパラメータを省略した場合はBoundaryResizer.CENTERとなり，縦横ともに中央揃えとなります．
		 * @return            リサイズ後の矩形が返されます．target及びboundaryは変更しません．
		 */
		static public function resize(target:Rectangle, boundary:Rectangle, scaleMode:String = "noScale", align:String = ""):Rectangle
		{
			var tx:Number = target.x,
			    ty:Number = target.y,
			    tw:Number = target.width,
			    th:Number = target.height,
			    bx:Number = boundary.x,
			    by:Number = boundary.y,
			    bw:Number = boundary.width,
			    bh:Number = boundary.height;
			
			switch (scaleMode)
			{
				case SHOW_ALL:
				case NO_BORDER:
					var ratioW:Number = bw / tw,
					    ratioH:Number = bh / th,
					    ratio:Number  = (scaleMode == SHOW_ALL) ? ( (ratioW < ratioH) ? ratioW : ratioH ) :
					                                              ( (ratioW > ratioH) ? ratioW : ratioH ) ;
					tw *= ratio;
					th *= ratio;
					break;
				
				case EXACT_FIT:
					return new Rectangle(bx, by, bw, bh);
			}
			
			tx = bx + ( (align == TOP_LEFT    || align == LEFT   || align == BOTTOM_LEFT ) ? 0               :
			            (align == TOP_RIGHT   || align == RIGHT  || align == BOTTOM_RIGHT) ? (bw - tw)       :
			                                                                                 (bw - tw) / 2 ) ;
			ty = by + ( (align == TOP_LEFT    || align == TOP    || align == TOP_RIGHT   ) ? 0               :
			            (align == BOTTOM_LEFT || align == BOTTOM || align == BOTTOM_RIGHT) ? (bh - th)       :
			                                                                                 (bh - th) / 2 ) ;
			
			return new Rectangle(tx, ty, tw, th);
		}
	}
}
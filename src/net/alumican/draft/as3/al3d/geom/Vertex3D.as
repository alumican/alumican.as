package net.alumican.draft.as3.al3d.geom
{
	import flash.display.Shape;
	
	/**
	 * Vertex3D
	 * 
	 * @author alumican
	 */
	public class Vertex3D
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 3D座標
		 */
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		/**
		 * UV座標
		 */
		public var u:Number;
		public var v:Number;
		
		/**
		 * 頂点インデックス
		 */
		public var index:int;
		
		/**
		 * デバッグ用Shape
		 */
		public var shape:Shape;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Vertex3D():void 
		{
			index = -1;
		}
		
		/**
		 * デバッグ用Shapeの更新
		 */
		public function updateShape():void
		{
			if (!shape)
			{
				shape = new Shape();
				shape.graphics.beginFill(0x0, 3);
				shape.graphics.drawCircle(0, 0, 3);
				shape.graphics.endFill();
			}
			
			shape.x = x;
			shape.y = y;
			shape.scaleX = shape.scaleY = (100 - z) / 200;
		}
	}
}
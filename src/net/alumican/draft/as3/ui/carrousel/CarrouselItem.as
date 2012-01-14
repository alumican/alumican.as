package net.alumican.draft.as3.ui.carrousel
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * CarrouselItem
	 * 
	 * @author alucamin.net
	 */
	public class CarrouselItem extends Sprite implements ICarrouselItem
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * カルーセルのアイテムとしてのx座標
		 */
		public function get carrouselItemPosition():Number { return x; }
		public function set carrouselItemPosition(value:Number):void { x = value; }
		
		/**
		 * カルーセルのアイテムとしての幅
		 */
		public function get carrouselItemSize():Number { return width; }
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function CarrouselItem(itemID:*):void
		{
			var color:uint = Math.random() * 0xffffff;
			
			switch(itemID)
			{
				//●
				case "circle":
					graphics.beginFill(color);
					graphics.drawCircle(0, 0, 50);
					graphics.endFill();
					break;
				
				//▲
				case "triangle":
					graphics.beginFill(color);
					graphics.moveTo(0, -86.6 * 0.5); 
					graphics.lineTo(-50, 86.6 * 0.5); 
					graphics.lineTo(50, 86.6 * 0.5); 
					graphics.lineTo(0, -86.6 * 0.5); 
					graphics.endFill();
					break;
				
				//■
				case "rectangle":
					graphics.beginFill(color);
					graphics.drawRect(-50, -50, 100, 100);
					graphics.endFill();
					break;
			}
			
			//scaleX = scaleY = 0.5 + Math.random() * 2;
			
			var rad:Number = Math.random() * Math.PI * 2;
			var vel:Number = Math.random() * 0.1 + 0.05;
			scaleX = scaleY = 2 + Math.sin(rad) * 0.5;
			addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				scaleX = scaleY = 2 + Math.sin(rad += vel) * 0.5;
			});
		}
	}
}
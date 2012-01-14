package net.alumican.as3.utils
{
	import flash.events.FocusEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * TextFieldUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class TextFieldUtil 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function TextFieldUtil():void 
		{
			throw new ArgumentError("Utility class is static.");
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * TextFieldにダミーの効果を掛けます
		 * @param	field
		 * @return
		 */
		static public function setDummyEffect(field:TextField):void
		{
			field.filters = [new BlurFilter(0, 0, 1)];
		}
		
		/**
		 * 字間調整をします
		 * @param	startIndex
		 * @param	endIndex
		 * @param	space
		 */
		static public function setLetterSpacing(field:TextField, startIndex:uint, endIndex:uint, space:int):void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.letterSpacing = space;
			field.setTextFormat(fmt, startIndex, endIndex);
		}
		
		/**
		 * TextFieldにタブコードを入力できるようにします
		 * @param	field
		 * @param	tab
		 * @return
		 */
		static public function enableInputTab(field:TextField, tab:String = "\t"):Function
		{
			var f:Function = function(e:FocusEvent):void
			{
				e.preventDefault();
				var field:TextField = TextField(e.target);
				var str1:String = field.text.substr(0, field.selectionBeginIndex);
				var str2:String = field.text.substr(field.selectionBeginIndex);
				field.text = str1 + "\t" + str2;
				field.setSelection(field.selectionBeginIndex + 1, field.selectionEndIndex + 1);
			}
			field.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, f);
			return f;
		}
		
		/**
		 * TextFieldにタブコードを入力できないようにします
		 * @param	field
		 * @param	handler
		 */
		static public function disableInputTab(field:TextField, handler:Function):void
		{
			field.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, handler);
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}
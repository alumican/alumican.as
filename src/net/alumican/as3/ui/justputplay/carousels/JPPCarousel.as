/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 alumican.net (www.alumican.net) and Spark project (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * In Japanese, http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license
 */
package net.alumican.as3.ui.justputplay.carousels
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * JPPCarousel.as
	 * 
	 * <p>ActionScript3.0で簡単に設置できるカルーセルのコアクラスです. </p>
	 * 
	 * 09.10.05 0.01 パブリックアルファ版公開
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	public class JPPCarousel
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * バージョン
		 */
		static public const VERSION:String = "0.01";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * アイテムID配列(カルーセルの状態によらず一定)
		 */
		public function get itemIDs():Array { return _itemIDs; }
		public function set itemIDs(value:Array):void { _itemIDs = value; }
		protected var _itemIDs:Array;
		
		/**
		 * 左端のアイテムIDを指すItemIDs配列のインデックス
		 */
		public function get firstItemIndex():int { return _firstItemIndex; }
		protected var _firstItemIndex:int;
		
		/**
		 * 右端のアイテムIDを指すItemIDs配列のインデックス
		 */
		public function get lastItemIndex():int { return _lastItemIndex; }
		protected var _lastItemIndex:int;
		
		/**
		 * 現在カルーセル内に存在するアイテム配列(カルーセル左端のアイテムが常にインデックス0)
		 */
		public function get items():Array { return _items; }
		protected var _items:Array;
		
		/**
		 * 現在カルーセル内に存在するアイテム数
		 */
		public function get itemCount():int { return _items.length; }
		
		/**
		 * スクロール用コンテナ
		 */
		public function get container():DisplayObjectContainer { return _container; }
		protected var _container:DisplayObjectContainer;
		
		/**
		 * 表示領域のオフセット座標
		 */
		public function get fieldOffset():int { return _fieldOffset; }
		public function set fieldOffset(value:int):void { _fieldOffset = value; adjustItems(); }
		protected var _fieldOffset:int;
		
		/**
		 * 表示領域のサイズ
		 */
		public function get fieldSize():int { return _fieldSize; }
		public function set fieldSize(value:int):void { _fieldSize = value; adjustItems(); }
		protected var _fieldSize:int;
		
		/**
		 * アイテム間のマージン
		 */
		public function get itemMargin():Number { return _itemMargin; }
		public function set itemMargin(value:Number):void { _itemMargin = value; adjustItems(); }
		protected var _itemMargin:Number;
		
		/**
		 * 現在のスクロール座標
		 */
		public function get scrollPosition():Number { return -_container[_scrollProperty]; }
		public function set scrollPosition(value:Number):void { _container[_scrollProperty] = -value; adjustItems(); }
		
		/**
		 * スクロールさせるプロパティ
		 */
		public function get scrollProperty():String { return _scrollProperty; }
		public function set scrollProperty(value:String):void { _scrollProperty = value; }
		protected var _scrollProperty:String;
		
		/**
		 * ある程度までコンテナがスクロールした時点で自動的に座標を0に戻す場合はtrue
		 */
		public function get useAutoRollbackContainer():Boolean { return _useAutoRollbackContainer; }
		public function set useAutoRollbackContainer(value:Boolean):void { _useAutoRollbackContainer = value; }
		protected var _useAutoRollbackContainer:Boolean;
		
		/**
		 * コンテナの座標をを自動的に0に戻す場合の閾値となるコンテナのスクロール量[pixel]
		 */
		public function get autoRollbackContainerThreshold():Number { return _autoRollbackContainerThreshold; }
		public function set autoRollbackContainerThreshold(value:Number):void { _autoRollbackContainerThreshold = value; }
		protected var _autoRollbackContainerThreshold:Number;
		
		/**
		 * リサイズ時に右側に並べていく場合はtrue
		 */
		public function get feedForward():Boolean { return _feedForward; }
		public function set feedForward(value:Boolean):void { _feedForward = value; }
		protected var _feedForward:Boolean;
		
		/**
		 * falseの場合, プロパティ変更時にadjustItemsが自動的に呼ばれない
		 */
		public function get isLocked():Boolean { return _isLocked; }
		public function set isLocked(value:Boolean):void { _isLocked = value; }
		protected var _isLocked:Boolean;
		
		/**
		 * 新規アイテムが必要となった際に呼び出される関数
		 * @param	itemID:*
		 * @return	IJPPCarouselItem
		 */
		public function get requireItem():Function { return __requireItem || _requireItem; }
		public function set requireItem(value:Function):void { __requireItem = value; }
		protected var __requireItem:Function;
		
		/**
		 * 不要アイテムを削除する際に呼び出される関数
		 * @param	item:IJPPCarouselItem
		 */
		public function get destroyItem():Function { return __destroyItem || _destroyItem; }
		public function set destroyItem(value:Function):void { __destroyItem = value; }
		protected var __destroyItem:Function;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS
		
		/**
		 * コンストラクタ
		 */
		public function JPPCarousel():void
		{
		}
		
		
		
		
		
		/**
		 * カルーセルを初期化する
		 */
		public function setup(
			itemIDs:Array,
			container:DisplayObjectContainer,
			fieldOffset:Number    = 0,
			fieldSize:Number      = 1000,
			itemIndex:int         = 0,
			itemMargin:Number     = 0,
			scrollProperty:String = "x",
			feedForward:Boolean   = true
		):void
		{
			destroy();
			
			_itemIDs           = itemIDs;
			_container         = container;
			_scrollProperty    = scrollProperty;
			_itemMargin        = itemMargin;
			_fieldOffset       = fieldOffset;
			_fieldSize         = fieldSize;
			_feedForward       = feedForward;
			
			_isLocked = false;
			
			//アイテム配列
			_items = new Array();
			
			//開始アイテム
			_firstItemIndex = _lastItemIndex = _feedForward ? (itemIndex % _itemIDs.length) :
			                                                  (_itemIDs.length - itemIndex % _itemIDs.length - 1);
			
			//コンテナの座標をを自動的に0に戻すためのパラメータ
			_useAutoRollbackContainer       = false;
			_autoRollbackContainerThreshold = 1000;
		}
		
		/**
		 * カルーセルを破棄する
		 */
		public function destroy():void
		{
			if (_items != null)
			{
				var n:int = _items.length,
					item:IJPPCarouselItem;
				for (var i:int = 0; i < n; ++i)
				{
					item = _items[i];
					destroyItem(item);
					if (_container.contains(DisplayObject(item))) _container.removeChild(DisplayObject(item));
				}
			}
			
			_container = null;
			_items = null;
			_itemIDs = null;
		}
		
		
		
		
		
		/**
		 * アイテムの追加と削除をおこなう関数
		 * この関数はCarouselクラスのプロパティの変更が生じた際に自動的に呼ばれます
		 * ただし、管理下に無いプロパティ(container.xなど)を直接書きかえた場合には手動で呼び出す必要があります
		 */
		public function adjustItems():void
		{
			if (_isLocked) return;
			
			var item:IJPPCarouselItem,
			    newItem:IJPPCarouselItem,
			    oldItem:IJPPCarouselItem,
			    position:Number,
			    half:Number,
				containerPosition:Number = -scrollPosition;
			
			if (_feedForward)
			{
				//----------------------------------------
				//順方向
				
				//最初のアイテムを配置
				if (_items.length == 0)
				{
					_lastItemIndex = _firstItemIndex;
					item = requireItem(_itemIDs[_firstItemIndex]);
					item.carouselItemPosition = item.carouselItemSizePrev;
					_container.addChild(DisplayObject(item));
					_items.push(item);
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizePrev;
					
					if (position - half - _itemMargin > _fieldOffset)
					{
						//左側に新規アイテムを追加する必要あり
						_addItemToBackward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizeNext;
					
					if (position + half + _itemMargin < _fieldOffset + _fieldSize)
					{
						//右側に新規アイテムを追加する必要あり
						_addItemToForward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizeNext;
					
					if (position + half + _itemMargin < _fieldOffset)
					{
						//左側に不要なアイテムあり
						_removeItemFromBackward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizePrev;
					
					if (position - half - _itemMargin > _fieldOffset + _fieldSize)
					{
						//右側に不要なアイテムあり
						_removeItemFromForward();
						continue;
					}
					
					break;
				}
			}
			else
			{
				//----------------------------------------
				//逆方向
				
				//最初のアイテムを配置
				if (_items.length == 0)
				{
					_lastItemIndex = _firstItemIndex;
					item = requireItem(_itemIDs[_firstItemIndex]);
					item.carouselItemPosition = -item.carouselItemSizeNext;
					_container.addChild(DisplayObject(item));
					_items.push(item);
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizePrev;
					
					if (position - half - _itemMargin > _fieldOffset - _fieldSize)
					{
						//左側に新規アイテムを追加する必要あり
						_addItemToBackward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizeNext;
					
					if (position + half + _itemMargin < _fieldOffset)
					{
						//右側に新規アイテムを追加する必要あり
						_addItemToForward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizeNext;
					
					if (position + half + _itemMargin < _fieldOffset - _fieldSize)
					{
						//左側に不要なアイテムあり
						_removeItemFromBackward();
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carouselItemPosition + containerPosition;
					half     = item.carouselItemSizePrev;
					
					if (position - half - _itemMargin > _fieldOffset)
					{
						//右側に不要なアイテムあり
						_removeItemFromForward();
						continue;
					}
					
					break;
				}
			}
			
			//自動的にコンテナ座標を戻す
			if (_useAutoRollbackContainer)
			{
				if (containerPosition > _autoRollbackContainerThreshold || containerPosition < -_autoRollbackContainerThreshold)
				{
					rollbackContainer(0);
				}
			}
		}
		
		/**
		 * 全アイテムのスケールを考慮して並べなおす
		 */
		public function adjustScale(pivotIndex:int):void
		{
			var item:IJPPCarouselItem,
			    position:Number,
			    half:Number,
				count:int = itemCount,
				i:int,
				n:int;
			
			pivotIndex = (pivotIndex <  0    ) ? 0           :
			             (pivotIndex >= count) ? (count - 1) : pivotIndex;
			
			//----------------------------------------
			//基準となるアイテムの左側を走査する
			if (pivotIndex > 0)
			{
				item     = _items[pivotIndex];
				position = item.carouselItemPosition - item.carouselItemSizePrev - _itemMargin;
				
				for (i = pivotIndex - 1; i >= 0; --i)
				{
					item = _items[i];
					item.carouselItemPosition = position - item.carouselItemSizeNext;
					position = item.carouselItemPosition - item.carouselItemSizePrev - _itemMargin;
				}
			}
			
			//----------------------------------------
			//基準となるアイテムの右側を走査する
			if (pivotIndex < count - 1)
			{
				item     = _items[pivotIndex];
				position = item.carouselItemPosition + item.carouselItemSizeNext + _itemMargin;
				
				for (i = pivotIndex + 1; i < count; ++i)
				{
					item = _items[i];
					item.carouselItemPosition = position + item.carouselItemSizePrev;
					position = item.carouselItemPosition + item.carouselItemSizeNext + _itemMargin;
				}
			}
			
			//アイテムの追加と削除
			adjustItems();
		}
		
		
		
		
		
		/**
		 * コンテナの座標を指定座標に戻す
		 * 内包するアイテムには逆向きの移動をさせることで見かけは変わらない
		 */
		public function rollbackContainer(position:Number = 0):void
		{
			var d:int = -scrollPosition - position,
			    n:int = _items.length;
			
			for (var i:int = 0; i < n; ++i)
			{
				IJPPCarouselItem(_items[i]).carouselItemPosition += d;
			}
			
			scrollPosition = position;
		}
		
		
		
		
		
		/**
		 * 指定されたアイテムID配列インデックスの次の配列インデックスを返す
		 * インデックスが境界外に出た場合は反対側にループする
		 */
		public function getNextItemIDIndex(index:int):int
		{
			if (++index >= _itemIDs.length) index = 0;
			return index;
		}
		
		/**
		 * 指定されたアイテムID配列インデックスの前の配列インデックスを返す
		 * インデックスが境界外に出た場合は反対側にループする
		 */
		public function getPrevItemIDIndex(index:int):int
		{
			if (--index < 0) index = _itemIDs.length - 1;
			return index;
		}
		
		
		
		
		
		/**
		 * 指定した座標と衝突するアイテムのカルーセル内インデックスを取得する
		 * 座標系はコンテナ座標系を用いる
		 * アイテムが見つからなかった場合は-1を返す
		 */
		public function getItemIndexByPosition(position:Number):int
		{
			var item:IJPPCarouselItem,
			    itemPosition:Number,
			    n:int = itemCount,
			    margin:Number = _itemMargin * 0.5;
			for (var i:int = 0; i < n; ++i)
			{
				item = _items[i];
				if (position >= item.carouselItemPosition - item.carouselItemSizePrev - margin &&
				    position <= item.carouselItemPosition + item.carouselItemSizeNext + margin)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 指定したIDをもつアイテムのカルーセル内インデックスを配列で取得する
		 * アイテムが見つからなかった場合は空の配列を返す
		 */
		public function getItemIndicesByItemID(itemID:*):Array
		{
			var n:int = itemCount,
				index:int = _firstItemIndex,
			    indices:Array = new Array();
			for (var i:int = 0; i < n; ++i)
			{
				if (_itemIDs[index] === itemID) indices.push(i);
				index = getNextItemIDIndex(index);
			}
			return indices;
		}
		
		/**
		 * カルーセル内に存在するアイテムを見つけ, カルーセル内インデックス返す
		 * アイテムが見つからなかった場合は-1を返す
		 */
		public function getItemIndexByItem(item:IJPPCarouselItem):int
		{
			var n:int = itemCount;
			for (var i:int = 0; i < n; ++i)
			{
				if (_items[i] === item) return i;
			}
			return -1;
		}
		
		
		
		
		
		//----------------------------------------
		//PROTECTED METHODS
		
		/**
		 * 新規アイテムが必要となった際に呼び出される関数(オーバーライド用)
		 * @param	itemID
		 * @return	IJPPCarouselItem
		 */
		protected function _requireItem(itemID:*):IJPPCarouselItem
		{
			return new JPPCarouselItem();
		}
		
		/**
		 * 不要アイテムを削除する際に呼び出される関数(オーバーライド用)
		 * @param	itemID
		 */
		protected function _destroyItem(item:IJPPCarouselItem):void
		{
		}
		
		
		
		
		
		//----------------------------------------
		//PRIVATE METHODS
		
		/**
		 * 右端にアイテムを追加する
		 */
		private function _addItemToForward():IJPPCarouselItem
		{
			var containerPosition:Number = -scrollPosition;
			
			var item:IJPPCarouselItem = _items[_items.length - 1];
			var position:Number       = item.carouselItemPosition + containerPosition;
			var half:Number           = item.carouselItemSizeNext;
			
			_lastItemIndex = getNextItemIDIndex(_lastItemIndex);
			var newItem:IJPPCarouselItem = requireItem(_itemIDs[_lastItemIndex]);
			newItem.carouselItemPosition = (item.carouselItemPosition + half) + (newItem.carouselItemSizePrev + _itemMargin);
			_items.push(newItem);
			_container.addChild(DisplayObject(newItem));
			
			return newItem;
		}
		
		/**
		 * 左端にアイテムを追加する
		 */
		private function _addItemToBackward():IJPPCarouselItem
		{
			var containerPosition:Number = -scrollPosition;
			
			var item:IJPPCarouselItem = _items[0];
			var position:Number       = item.carouselItemPosition + containerPosition;
			var half:Number           = item.carouselItemSizePrev;
			
			_firstItemIndex = getPrevItemIDIndex(_firstItemIndex);
			var newItem:IJPPCarouselItem = requireItem(_itemIDs[_firstItemIndex]);
			newItem.carouselItemPosition = (item.carouselItemPosition - half) - (newItem.carouselItemSizeNext + _itemMargin);
			_items.unshift(newItem);
			_container.addChild(DisplayObject(newItem));
			
			return newItem;
		}
		
		/**
		 * 右端からアイテムを削除する
		 */
		private function _removeItemFromForward():IJPPCarouselItem
		{
			var containerPosition:Number = -scrollPosition;
			
			var item:IJPPCarouselItem = _items[_items.length - 1];
			var position:Number       = item.carouselItemPosition + containerPosition;
			var half:Number           = item.carouselItemSizePrev;
			
			var oldItem:IJPPCarouselItem = _items.pop();
			destroyItem(oldItem);
			if (_container.contains(DisplayObject(oldItem))) _container.removeChild(DisplayObject(oldItem));
			_lastItemIndex = getPrevItemIDIndex(_lastItemIndex);
			
			return oldItem;
		}
		
		/**
		 * 左端からアイテムを削除する
		 */
		private function _removeItemFromBackward():IJPPCarouselItem
		{
			var containerPosition:Number = -scrollPosition;
			
			var item:IJPPCarouselItem = _items[0];
			var position:Number       = item.carouselItemPosition + containerPosition;
			var half:Number           = item.carouselItemSizeNext;
			
			var oldItem:IJPPCarouselItem = _items.shift();
			destroyItem(oldItem);
			if (_container.contains(DisplayObject(oldItem))) _container.removeChild(DisplayObject(oldItem));
			_firstItemIndex = getNextItemIDIndex(_firstItemIndex);
			
			return oldItem;
		}
	}
}
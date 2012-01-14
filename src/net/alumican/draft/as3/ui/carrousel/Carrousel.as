package net.alumican.draft.as3.ui.carrousel
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Carrousel
	 * 
	 * @author alucamin.net
	 */
	public class Carrousel extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * アイテムID配列
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
		 * 左端のアイテムIDを指すItemIDs配列のインデックス
		 */
		public function get lastItemIndex():int { return _lastItemIndex; }
		protected var _lastItemIndex:int;
		
		/**
		 * アイテム配列
		 */
		public function get items():Array { return _items; }
		protected var _items:Array;
		
		/**
		 * 現在のアイテム数
		 */
		public function get itemCount():int { return _items.length; }
		
		/**
		 * アイテム配置用コンテナ
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
		public function get itemMargin():Number { return _itemMargin; adjustItems(); }
		public function set itemMargin(value:Number):void { _itemMargin = value; }
		protected var _itemMargin:Number;
		
		/**
		 * 縦スクロールする場合はtrue
		 */
		public function get useVerticalScroll():Boolean { return _useVerticalScroll; }
		public function set useVerticalScroll(value:Boolean):void { _useVerticalScroll = value; }
		protected var _useVerticalScroll:Boolean;
		
		/**
		 * 現在のスクロール座標
		 */
		public function get scrollPosition():Number { return _scrollPosition; }
		public function set scrollPosition(value:Number):void { _scrollPosition = value; _useVerticalScroll ? (_container.y = -_scrollPosition) : (_container.x = -_scrollPosition); adjustItems(); }
		protected var _scrollPosition:Number;
		
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
		 * 新規アイテムが必要となった際に呼び出される関数
		 * @param	itemID:*
		 * @return	ICarrouselItem
		 */
		public function get requireItem():Function { return __requireItem || _requireItem; }
		public function set requireItem(value:Function):void { __requireItem = value; }
		protected var __requireItem:Function;
		
		/**
		 * 不要アイテムを削除する際に呼び出される関数
		 * @param	item:ICarrouselItem
		 */
		public function get destroyItem():Function { return __destroyItem || _destroyItem; }
		public function set destroyItem(value:Function):void { __destroyItem = value; }
		protected var __destroyItem:Function;
		
		/**
		 * 自動スクロールの現在速度
		 */
		public function get autoScrollVelocityCurrent():Number { return _autoScrollVelocityCurrent; }
		public function set autoScrollVelocityCurrent(value:Number):void { _autoScrollVelocityCurrent = value; }
		protected var _autoScrollVelocityCurrent:Number;
		
		/**
		 * 自動スクロールの目標速度
		 */
		public function get autoScrollVelocityTarget():Number { return _autoScrollVelocityTarget; }
		public function set autoScrollVelocityTarget(value:Number):void { _autoScrollVelocityTarget = value; }
		protected var _autoScrollVelocityTarget:Number;
		
		/**
		 * 自動スクロールのイージング係数(0, 1]
		 */
		public function get autoScrollVelocityEasing():Number { return _autoScrollVelocityEasing; }
		public function set autoScrollVelocityEasing(value:Number):void { _autoScrollVelocityEasing = value; }
		protected var _autoScrollVelocityEasing:Number;
		
		/**
		 * リサイズ時に右側に並べていく場合はtrue
		 */
		public function get useForward():Boolean { return _useForward; }
		public function set useForward(value:Boolean):void { _useForward = value; }
		protected var _useForward:Boolean;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Carrousel(itemIDs:Array, container:DisplayObjectContainer = null, useVerticalScroll:Boolean = false, initAdjust:Boolean = true, fieldSize:Number = 1024, itemMargin:Number = 0, offsetIndex:int = 0, initScrollPosition:Number = 0, useForward:Boolean = true):void
		{
			_itemIDs           = itemIDs;
			_container         = container;
			_firstItemIndex    = _lastItemIndex = offsetIndex % _itemIDs.length;
			_useVerticalScroll = useVerticalScroll;
			_itemMargin        = itemMargin;
			_fieldOffset       = 0;
			_fieldSize         = fieldSize;
			_scrollPosition    = initScrollPosition;
			_useForward        = useForward;
			_items             = new Array();
			
			if (!_useForward)
			{
				_firstItemIndex = _lastItemIndex = _itemIDs.length - _firstItemIndex - 1;
			}
			
			//自動スクロールのパラメータ
			_autoScrollVelocityCurrent = 0;
			_autoScrollVelocityTarget  = 0;
			_autoScrollVelocityEasing  = 0.3;
			
			//コンテナの座標をを自動的に0に戻すためのパラメータ
			_useAutoRollbackContainer       = true;
			_autoRollbackContainerThreshold = 1000;
			
			//アイテム配置用コンテナを生成する
			if (!_container) _container = addChild( new Sprite() ) as DisplayObjectContainer;
			
			//最初の並びを構築する
			if (initAdjust) adjustItems();
		}
		
		/**
		 * アイテムの追加と削除をおこなう関数
		 * この関数はCarrouselクラスのプロパティの変更が生じた際に自動的に呼ばれます
		 * ただし、管理下に無いプロパティ(container.xなど)を直接書きかえた場合には手動で呼び出す必要があります
		 */
		public function adjustItems():void
		{
			var item:ICarrouselItem,
			    newItem:ICarrouselItem,
			    oldItem:ICarrouselItem,
			    position:Number,
			    half:Number,
				containerPosition:Number = -_scrollPosition;
			
			if (_useForward)
			{
				//----------------------------------------
				//順方向
				
				//最初のアイテムを配置
				if (_items.length == 0)
				{
					_lastItemIndex = _firstItemIndex;
					item = requireItem(_itemIDs[_firstItemIndex]);
					item.carrouselItemPosition = item.carrouselItemSize * 0.5;
					_container.addChild(item as DisplayObject);
					_items.push(item);
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position - half - _itemMargin > _fieldOffset)
					{
						//左側に新規アイテムを追加する必要あり
						_firstItemIndex = getPrevItemIDIndex(_firstItemIndex);
						newItem = requireItem(_itemIDs[_firstItemIndex]);
						newItem.carrouselItemPosition = (item.carrouselItemPosition - half) - (newItem.carrouselItemSize * 0.5 + _itemMargin);
						_container.addChild(newItem as DisplayObject);
						_items.unshift(newItem);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position + half + _itemMargin < _fieldOffset + _fieldSize)
					{
						//右側に新規アイテムを追加する必要あり
						_lastItemIndex = getNextItemIDIndex(_lastItemIndex);
						newItem = requireItem(_itemIDs[_lastItemIndex]);
						newItem.carrouselItemPosition = (item.carrouselItemPosition + half) + (newItem.carrouselItemSize * 0.5 + _itemMargin);
						_container.addChild(newItem as DisplayObject);
						_items.push(newItem);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position + half + _itemMargin < _fieldOffset)
					{
						//左側に不要なアイテムあり
						oldItem = _items.shift();
						destroyItem(oldItem);
						if (_container.contains(oldItem as DisplayObject)) _container.removeChild(oldItem as DisplayObject);
						_firstItemIndex = getNextItemIDIndex(_firstItemIndex);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position - half - _itemMargin > _fieldOffset + _fieldSize)
					{
						//右側に不要なアイテムあり
						oldItem = _items.pop();
						destroyItem(oldItem);
						if (_container.contains(oldItem as DisplayObject)) _container.removeChild(oldItem as DisplayObject);
						_lastItemIndex = getPrevItemIDIndex(_lastItemIndex);
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
					item.carrouselItemPosition = -item.carrouselItemSize * 0.5;
					_container.addChild(item as DisplayObject);
					_items.push(item);
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position - half - _itemMargin > _fieldOffset - _fieldSize)
					{
						//左側に新規アイテムを追加する必要あり
						_firstItemIndex = getPrevItemIDIndex(_firstItemIndex);
						newItem = requireItem(_itemIDs[_firstItemIndex]);
						newItem.carrouselItemPosition = (item.carrouselItemPosition - half) - (newItem.carrouselItemSize * 0.5 + _itemMargin);
						_container.addChild(newItem as DisplayObject);
						_items.unshift(newItem);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position + half + _itemMargin < _fieldOffset)
					{
						//右側に新規アイテムを追加する必要あり
						_lastItemIndex = getNextItemIDIndex(_lastItemIndex);
						newItem = requireItem(_itemIDs[_lastItemIndex]);
						newItem.carrouselItemPosition = (item.carrouselItemPosition + half) + (newItem.carrouselItemSize * 0.5 + _itemMargin);
						_container.addChild(newItem as DisplayObject);
						_items.push(newItem);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[0];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position + half + _itemMargin < _fieldOffset - _fieldSize)
					{
						//左側に不要なアイテムあり
						oldItem = _items.shift();
						destroyItem(oldItem);
						if (_container.contains(oldItem as DisplayObject)) _container.removeChild(oldItem as DisplayObject);
						_firstItemIndex = getNextItemIDIndex(_firstItemIndex);
						continue;
					}
					
					break;
				}
				
				//----------------------------------------
				while (true)
				{
					item     = _items[_items.length - 1];
					position = item.carrouselItemPosition + containerPosition;
					half     = item.carrouselItemSize * 0.5;
					
					if (position - half - _itemMargin > _fieldOffset)
					{
						//右側に不要なアイテムあり
						oldItem = _items.pop();
						destroyItem(oldItem);
						if (_container.contains(oldItem as DisplayObject)) _container.removeChild(oldItem as DisplayObject);
						_lastItemIndex = getPrevItemIDIndex(_lastItemIndex);
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
		public function adjustScale(pivot:int):void
		{
			var item:ICarrouselItem,
			    position:Number,
			    half:Number,
				count:int = itemCount,
				i:int,
				n:int;
			
			pivot = (pivot <  0    ) ? 0           :
			        (pivot >= count) ? (count - 1) : pivot;
			
			//----------------------------------------
			//基準となるアイテムの左側を走査する
			if (pivot > 0)
			{
				item     = _items[pivot];
				position = item.carrouselItemPosition - item.carrouselItemSize * 0.5 - _itemMargin;
				
				for (i = pivot - 1; i >= 0; --i)
				{
					item = _items[i];
					item.carrouselItemPosition = position - item.carrouselItemSize * 0.5;
					position = item.carrouselItemPosition - item.carrouselItemSize * 0.5 - _itemMargin;
				}
			}
			
			//----------------------------------------
			//基準となるアイテムの右側を走査する
			if (pivot < count - 1)
			{
				item     = _items[pivot];
				position = item.carrouselItemPosition + item.carrouselItemSize * 0.5 + _itemMargin;
				
				for (i = pivot + 1; i < count; ++i)
				{
					item = _items[i];
					item.carrouselItemPosition = position + item.carrouselItemSize * 0.5;
					position = item.carrouselItemPosition + item.carrouselItemSize * 0.5 + _itemMargin;
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
			var d:int = -_scrollPosition - position,
			    n:int = _items.length;
			
			for (var i:int = 0; i < n; ++i)
			{
				ICarrouselItem(_items[i]).carrouselItemPosition += d;
			}
			
			scrollPosition = position;
		}
		
		/**
		 * 自動スクロールを開始する
		 * velocityに0を指定した場合は停止命令となる
		 * @param	velocity
		 */
		public function autoScroll(velocity:Number):void
		{
			_autoScrollVelocityTarget = velocity;
			addEventListener(Event.ENTER_FRAME, _updateAutoScroll);
		}
		
		/**
		 * 指定されたアイテムID配列インデックスの次の配列インデックスを返す
		 * インデックスが境界外に出た場合は反対側にループする
		 * @param	index
		 * @return
		 */
		public function getNextItemIDIndex(index:int):int
		{
			if (++index >= _itemIDs.length) index = 0;
			return index;
		}
		
		/**
		 * 指定されたアイテムID配列インデックスの前の配列インデックスを返す
		 * インデックスが境界外に出た場合は反対側にループする
		 * @param	index
		 * @return
		 */
		public function getPrevItemIDIndex(index:int):int
		{
			if (--index < 0) index = _itemIDs.length - 1;
			return index;
		}
		
		/**
		 * カルーセルを破棄する
		 */
		public function destroy(complete:Boolean = false):void
		{
			var n:int = _items.length;
			var item:ICarrouselItem;
			for (var i:int = 0; i < n; ++i)
			{
				item = _items[i];
				destroyItem(item);
				if (_container.contains(item as DisplayObject)) _container.removeChild(item as DisplayObject);
			}
			_firstItemIndex = 0;
			_lastItemIndex = 0;
			_useVerticalScroll ? (_container.y = 0) : (_container.x = 0);
			_scrollPosition = 0;
			_items = new Array();
			
			if (complete)
			{
				if (contains(_container)) removeChild(_container);
				_container = null;
				_items = null;
			}
		}
		
		
		
		
		
		//----------------------------------------
		//PROTECTED METHODS
		
		/**
		 * 新規アイテムが必要となった際に呼び出される関数(オーバーライド用)
		 * @param	itemID
		 * @return	ICarrouselItem
		 */
		protected function _requireItem(itemID:*):ICarrouselItem
		{
			return new CarrouselItem(itemID);
		}
		
		/**
		 * 不要アイテムを削除する際に呼び出される関数(オーバーライド用)
		 * @param	itemID
		 */
		protected function _destroyItem(item:ICarrouselItem):void
		{
		}
		
		/**
		 * 自動スクロールの更新
		 * @param	e
		 */
		protected function _updateAutoScroll(e:Event):void
		{
			var d:Number = _autoScrollVelocityTarget - _autoScrollVelocityCurrent,
			    s:Number = d < 0 ? -d : d;
			
			if (s < 0.1)
			{
				//等速運動処理
				_autoScrollVelocityCurrent = _autoScrollVelocityTarget;
				
				//停止処理
				if (_autoScrollVelocityTarget == 0)
				{
					removeEventListener(Event.ENTER_FRAME, _updateAutoScroll);
				}
			}
			else
			{
				//加速処理
				_autoScrollVelocityCurrent += d * _autoScrollVelocityEasing;
			}
			
			//コンテナ座標に適用する
			scrollPosition += _autoScrollVelocityCurrent;
		}
	}
}
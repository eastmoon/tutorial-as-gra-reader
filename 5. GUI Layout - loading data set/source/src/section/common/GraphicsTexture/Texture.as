﻿/*
////////////////////////
////	Texture		////
////////////////////////
	Info:
		- 
		
	Useage:(有開放public 讓外部使用)
		- Draw			: 繪製BitmapData到傳入的BitmapData
		
		變數存取介面
		- pattern		: [read-write]BitmapData存取介面
		- patternInfo	: [read-write]BitmapData的長寬資訊
		- isClip		: [read-write]BitmapData是否進行裁切後才貼上
		- scaleX		: [read-write]BitmapData的X軸縮放參數
		- scaleY		: [read-write]BitmapData的Y軸縮放參數
		- blend			: [read-write]BitmapData的Blend參數
		- color			: [read-write]BitmapData的色偏參數
		- location		: [read-write]BitmapData的繪製位置
		- x				: [read-write]BitmapData的X軸繪製位置
		- y				: [read-write]BitmapData的Y軸繪製位置
		- scale			: [write-only]BitmapData的等比縮放參數
		- smooth		: [write-only]BitmapData的繪製時是否採用平滑效果
		- drawMode		: [read-write]繪製模式
		- delay			: [read-write]延遲繪製最大次數
		- parent		: [read-write]上一階層物件
		
		
		靜態參數 
		播放方式
		- DRAW_ALWAY	: 每次Draw都將圖樣內容重新繪於圖版
		- DRAW_DELAY	: 延遲繪製次數，當第N次繪製後才重新繪於圖版
		- DRAW_ONE		: 現在重新繪於圖版，但之後不再處理。
		
	Date:
		- 2010.01.04
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/

package src.section.common.GraphicsTexture
{
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import caurina.transitions.Equations;
		
	public class Texture
	{
		/*static const variable : 靜態常數變數*/
		public static const DRAW_ALWAY : Number = 1;
		public static const DRAW_DELAY : Number = 2;
		public static const DRAW_ONE : Number = 3;
		
		protected static var s_initTransitionList : Boolean = false;
		protected static var s_transitionList : Object;
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		// 繪製圖片資料
		protected var m_bitmapData : BitmapData;
		protected var m_bitmapInfo : Rectangle;
		
		// 繪製參數
		protected var m_isClip : Boolean; 
		protected var m_isSmoothing : Boolean;
		protected var m_clipRect : Rectangle;
		protected var m_scaleX : Number;
		protected var m_scaleY : Number;
		protected var m_blend : String;
		protected var m_matrix : Matrix;
		protected var m_color : ColorTransform;
		protected var m_palette : ColorTransform;
		protected var m_location : Point;
		protected var m_parent : Texture;
		
		// 繪製時間控制
		protected var m_drawMode : Number;
		protected var m_maxDelay : Number;
		protected var m_curDelay : Number;
		
		// Tween參數
		private var m_tweenList : Array;
		private var m_tweenCompleteList : Array;
		
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		/*constructor：建構值*/
		public function Texture( a_pattern : Object = null ) : void
		{
			if( a_pattern != null && a_pattern is BitmapData )
			{
				// 由傳入的圖片決定繪板大小
				this.m_bitmapData = (a_pattern as BitmapData);
				this.m_bitmapInfo = new Rectangle(0, 0, this.m_bitmapData.width, this.m_bitmapData.height);
			}
			else if( a_pattern != null && a_pattern is Rectangle )
			{
				// 由傳入的資訊決定繪板大小
				this.m_bitmapData = null;
				this.m_bitmapInfo = new Rectangle(0, 0, (a_pattern as Rectangle).width, (a_pattern as Rectangle).height);
			}
			else
			{
				// 傳入資料有誤，使用預設情況
				this.m_bitmapData = null;
				this.m_bitmapInfo = null;
			}
			// 繪製參數
			this.m_isClip = true;
			this.m_isSmoothing = false;
			this.m_clipRect = null;
			this.m_scaleX = 1;
			this.m_scaleY = 1;
			this.m_blend = null;
			this.m_matrix = new Matrix();
			this.m_color = new ColorTransform();
			this.m_palette = new ColorTransform();
			this.m_location = new Point();
			this.m_parent = null;
			
			// 繪製時間控制
			this.m_drawMode = Texture.DRAW_ONE;
			this.m_maxDelay = m_curDelay = 0;
			
			// 初始化Tween
			this.m_tweenList = new Array();
			this.m_tweenCompleteList = new Array();
			InitTransitionList();
		}
		
		public static function InitTransitionList() : Boolean 
		{
			// 若已經宣告過，不需重覆運作
			if( s_initTransitionList )
				return false;
			else
				s_initTransitionList = true;
				
			// 建立公式列表
			s_transitionList = new Object();
			
			// 登記列表內容
			s_transitionList["easenone"] = Equations.easeNone;
			s_transitionList["linear"] = Equations.easeNone;		// mx.transitions.easing.None.easeNone
			
			s_transitionList["easeinquad"] = Equations.easeInQuad;	// mx.transitions.easing.Regular.easeIn
			s_transitionList["easeoutquad"] = Equations.easeOutQuad;	// mx.transitions.easing.Regular.easeOut
			s_transitionList["easeinoutquad"] = Equations.easeInOutQuad;	// mx.transitions.easing.Regular.easeInOut
			s_transitionList["easeoutinquad"] = Equations.easeOutInQuad;
			
			s_transitionList["easeincubic"] = Equations.easeInCubic;
			s_transitionList["easeoutcubic"] = Equations.easeOutCubic;
			s_transitionList["easeinoutcubic"] = Equations.easeInOutCubic;
			s_transitionList["easeoutincubic"] = Equations.easeOutInCubic;
			
			s_transitionList["easeinquart"] = Equations.easeInQuart;
			s_transitionList["easeoutquart"] = Equations.easeOutQuart;
			s_transitionList["easeinoutquart"] = Equations.easeInOutQuart;
			s_transitionList["easeoutinquart"] = Equations.easeOutInQuart;
			
			s_transitionList["easeinquint"] = Equations.easeInQuint;
			s_transitionList["easeoutquint"] = Equations.easeOutQuint;
			s_transitionList["easeinoutquint"] = Equations.easeInOutQuint;
			s_transitionList["easeoutinquint"] = Equations.easeOutInQuint;
			
			s_transitionList["easeinsine"] = Equations.easeInSine;
			s_transitionList["easeoutsine"] = Equations.easeOutSine;
			s_transitionList["easeinoutsine"] = Equations.easeInOutSine;
			s_transitionList["easeoutinsine"] = Equations.easeOutInSine;
			
			s_transitionList["easeincirc"] = Equations.easeInCirc;
			s_transitionList["easeoutcirc"] = Equations.easeOutCirc;
			s_transitionList["easeinoutcirc"] = Equations.easeInOutCirc;
			s_transitionList["easeoutincirc"] = Equations.easeOutInCirc;
			
			s_transitionList["easeinexpo"] = Equations.easeInExpo;		// mx.transitions.easing.Strong.easeIn
			s_transitionList["easeoutexpo"] = Equations.easeOutExpo;		// mx.transitions.easing.Strong.easeOut
			s_transitionList["easeinoutexpo"] = Equations.easeInOutExpo;		// mx.transitions.easing.Strong.easeInOut
			s_transitionList["easeoutinexpo"] = Equations.easeOutInExpo;
			
			s_transitionList["easeinelastic"] = Equations.easeInElastic;		// mx.transitions.easing.Elastic.easeIn
			s_transitionList["easeoutelastic"] = Equations.easeOutElastic;	// mx.transitions.easing.Elastic.easeOut
			s_transitionList["easeinoutelastic"] = Equations.easeInOutElastic;	// mx.transitions.easing.Elastic.easeInOut
			s_transitionList["easeoutinelastic"] = Equations.easeOutInElastic;
			
			s_transitionList["easeinback"] = Equations.easeInBack;		// mx.transitions.easing.Back.easeIn
			s_transitionList["easeoutback"] = Equations.easeOutBack;		// mx.transitions.easing.Back.easeOut
			s_transitionList["easeinoutback"] = Equations.easeInOutBack;		// mx.transitions.easing.Back.easeInOut
			s_transitionList["easeoutinback"] = Equations.easeOutInBack;
			
			s_transitionList["easeinbounce"] = Equations.easeInBounce;		// mx.transitions.easing.Bounce.easeIn
			s_transitionList["easeoutbounce"] = Equations.easeOutBounce;		// mx.transitions.easing.Bounce.easeOut
			s_transitionList["easeinoutbounce"] = Equations.easeInOutBounce;	// mx.transitions.easing.Bounce.easeInOut
			s_transitionList["easeoutinbounce"] = Equations.easeOutInBounce;
			
			return true;
		}
		/*public function：對外公開函數*/
		public function Draw( a_panel : BitmapData ) : void
		{
			if( a_panel != null && this.m_bitmapInfo != null )
			{
				var i = 0, j = 0, k = 0;
				var str : String = "";
				var tweenParam : Object = null;
				var t = 0, b = 0, c = 0, d = 0, correctValue = 0;
				
				// 計算Tween
				for( i = 0 ; i < this.m_tweenList.length ; i++ )
				{
					// 增加一次運算時間
					this.m_tweenList[i].currTime++;
					
					// 計算Tween Object繪製次數，判斷是否已達終止狀態
					// 若運算時間大於等於最大繪製次數則停止
					if( this.m_tweenList[i].currTime >= this.m_tweenList[i].maxTime )
					{
						this.m_tweenCompleteList.push(i);
						continue;
					}
					
					// 若運算時間仍小於延遲(Delay)則忽略這次動作
					if( this.m_tweenList[i].currTime <= this.m_tweenList[i].delayTime )
						continue;
						
					// 執行Transition
					t = this.m_tweenList[i].currTime - this.m_tweenList[i].delayTime;
					d = this.m_tweenList[i].runTime;
					for( str in this.m_tweenList[i].target )
					{
						if( this.m_tweenList[i].target[str] == undefined )
							continue;
							
						b = this.m_tweenList[i].original[str];
						c = this.m_tweenList[i].target[str];
						correctValue = s_transitionList[this.m_tweenList[i].transition]( t, b, c, d );
						
						switch( str )
						{
							case "x" :
								this.m_location.x = correctValue;
							break;
							case "y" :
								this.m_location.y = correctValue;
							break;
							case "scaleX" :
								this.m_scaleX = correctValue;
							break;
							case "scaleY" :
								this.m_scaleY = correctValue;
							break;
							case "r" :
								this.m_color.redMultiplier = correctValue;
							break;
							case "g" :
								this.m_color.greenMultiplier = correctValue;
							break;
							case "b" :
								this.m_color.blueMultiplier = correctValue;
							break;
							case "a" :
								this.m_color.alphaMultiplier = correctValue;
							break;
							case "ro" :
								this.m_color.redOffset = correctValue;
							break;
							case "go" :
								this.m_color.greenOffset = correctValue;
							break;
							case "bo" :
								this.m_color.blueOffset = correctValue;
							break;
							case "ao" :
								this.m_color.alphaOffset = correctValue;
							break;
						}
					}
				}
				
				// 移除完成的Tween
				for( i = 0 ; i < this.m_tweenCompleteList.length ; i++ )
				{
					tweenParam = this.m_tweenList.splice( this.m_tweenCompleteList[i], 1 )[0];
					if( tweenParam.onComplete != null )
						tweenParam.onComplete(this);
					
					tweenParam = null;
				}
				this.m_tweenCompleteList.splice(0, this.m_tweenCompleteList.length);
				
				// 確認位置
				this.m_matrix.tx = this.m_location.x;
				this.m_matrix.ty = this.m_location.y;
			
				// 確認縮放比例
				this.m_matrix.a = this.m_scaleX;
				this.m_matrix.d = this.m_scaleY;
				
				// 縮放若為負，將位置偏移回0,0
				if( this.m_matrix.a < 0 )
				{
					this.m_matrix.tx += this.m_bitmapInfo.width * Math.abs(this.m_matrix.a);
				}
				if( this.m_matrix.d < 0 )
				{
					this.m_matrix.ty += this.m_bitmapInfo.height * Math.abs(this.m_matrix.d);
				}
				
				// 調色盤上色
				this.m_color.redMultiplier = this.m_palette.redMultiplier;
				this.m_color.redOffset = this.m_palette.redOffset;
				this.m_color.greenMultiplier = this.m_palette.greenMultiplier;
				this.m_color.greenOffset = this.m_palette.greenOffset;
				this.m_color.blueMultiplier = this.m_palette.blueMultiplier;
				this.m_color.blueOffset = this.m_palette.blueOffset;
				this.m_color.alphaMultiplier = this.m_palette.alphaMultiplier;
				this.m_color.alphaOffset = this.m_palette.alphaOffset;
				
				// 計算上層物件的參數影響
				if( this.m_parent != null )
				{					
					// 縮放比調整
					this.m_matrix.scale(this.m_parent.scaleX, this.m_parent.scaleY);
					
					// 中心座標偏移
					this.m_matrix.tx += this.m_parent.location.x;
					this.m_matrix.ty += this.m_parent.location.y;
					
					// 顏色
					this.m_color.redMultiplier *= this.m_parent.color.redMultiplier;
					this.m_color.greenMultiplier *= this.m_parent.color.greenMultiplier;
					this.m_color.blueMultiplier *= this.m_parent.color.blueMultiplier;
					this.m_color.alphaMultiplier *= this.m_parent.color.alphaMultiplier;
					
					this.m_color.redOffset += this.m_parent.color.redOffset;
					if( this.m_color.redOffset > 255 )
						this.m_color.redOffset = 255;
						
					this.m_color.greenOffset += this.m_parent.color.greenOffset;					
					if( this.m_color.greenOffset > 255 )
						this.m_color.greenOffset = 255;
						
					this.m_color.blueOffset += this.m_parent.color.blueOffset;
					if( this.m_color.blueOffset > 255 )
						this.m_color.blueOffset = 255;
						
					this.m_color.alphaOffset += this.m_parent.color.alphaOffset;
					if( this.m_color.alphaOffset > 255 )
						this.m_color.alphaOffset = 255;
					
					
				}
			
				// 確認裁切值
				/*
				if( this.m_clipRect == null )
					this.m_clipRect = new Rectangle();
				this.m_clipRect.x = 0;
				this.m_clipRect.y = 0;
				this.m_clipRect.width = 50;
				this.m_clipRect.height = 50;
				*/
				if( this.m_isClip )
				{
					var nowScaleX = Math.abs(this.m_matrix.a);
					var nowScaleY = Math.abs(this.m_matrix.d);
					
					if( this.m_clipRect == null )
						this.m_clipRect = new Rectangle(); 
					
					// 取得左上位置，若為反射(scael為負)則減回一個長寬值。
					if( this.m_matrix.a >= 0 )
						this.m_clipRect.x = this.m_matrix.tx;
					else
						this.m_clipRect.x = this.m_matrix.tx - this.m_bitmapInfo.width * nowScaleX;
					
					if( this.m_matrix.d >= 0 )
						this.m_clipRect.y = this.m_matrix.ty;
					else
						this.m_clipRect.y = this.m_matrix.ty - this.m_bitmapInfo.height * nowScaleY;
					
					// 取得可視範圍長寬
					this.m_clipRect.width = this.m_clipRect.x + this.m_bitmapInfo.width * nowScaleX;
					this.m_clipRect.height = this.m_clipRect.y + this.m_bitmapInfo.height * nowScaleY;
					
					// 右邊過界
					if( this.m_clipRect.width > a_panel.width )
						this.m_clipRect.width = a_panel.width - this.m_clipRect.x;
					else
						this.m_clipRect.width = this.m_bitmapInfo.width * nowScaleX;
					// 下邊過界
					if( this.m_clipRect.height > a_panel.height )
						this.m_clipRect.height = a_panel.height - this.m_clipRect.y;
					else
						this.m_clipRect.height = this.m_bitmapInfo.height * nowScaleY;
						
					// 左邊過界
					if( this.m_clipRect.x < 0 )
					{
						this.m_clipRect.width = this.m_bitmapInfo.width * nowScaleX + this.m_clipRect.x ;
						this.m_clipRect.x = 0;
					}
					// 上邊過界
					if( this.m_clipRect.y < 0 )
					{
						this.m_clipRect.height = this.m_bitmapInfo.height * nowScaleY + this.m_clipRect.y ;
						this.m_clipRect.y = 0;
					}
				}
				else
					this.m_clipRect = null;
				
							
				// 執行繪圖，如果ClipRect表示為邊框之外，不繪製圖形
				if( this.m_clipRect == null || 
				( this.m_clipRect != null && ( this.m_clipRect.width > 0 || this.m_clipRect.height > 0 )) )
				{
					this.EventDrawBitmap( a_panel );
				}
			}
		}
		public function StopTween() : void
		{
			for( var i = 0 ; i < this.m_tweenList.length ; i++ )
				this.m_tweenList[i] = null;
			this.m_tweenList.splice(0, this.m_tweenList.length);
		}
		public function AddTween( a_parameters : Object = null ) : Boolean
		{
			// 若傳入為空，停止設定Tween
			if( a_parameters == null )
				return false;
			
			// 設定Tween
			// 儲存目標(Target)與值(Value)、需要經過幾次(Time)繪製、要延後(Delay)幾個繪製才運算，
			// 用什麼運算式(Transition)，運算完後是否要執行動作(onComplete)
			var newTween : Object = new Object();
			
			// 儲存目標(Target)與值(Value)
			newTween.target = new Object();
			newTween.original = new Object();
			// Loaction X,Y
			newTween.target.x = a_parameters.x;
			newTween.target.y = a_parameters.y;
			newTween.original.x = this.m_location.x;
			newTween.original.y = this.m_location.y;
			
			// Scale X,Y
			newTween.target.scaleX = a_parameters.scaleX;
			newTween.target.scaleY = a_parameters.scaleY;
			
			newTween.original.scaleX = this.m_scaleX;
			newTween.original.scaleY = this.m_scaleY;
			
			// Color R、G、B、A Multiplier
			newTween.target.r = a_parameters.r;
			newTween.target.g = a_parameters.g;
			newTween.target.b = a_parameters.b;
			newTween.target.a = a_parameters.a;
			
			newTween.original.r = this.m_color.redMultiplier;
			newTween.original.g = this.m_color.greenMultiplier;
			newTween.original.b = this.m_color.blueMultiplier;
			newTween.original.a = this.m_color.alphaMultiplier;
			
			// Color R、G、B、A Offset
			newTween.target.ro = a_parameters.ro;
			newTween.target.go = a_parameters.go;
			newTween.target.bo = a_parameters.bo;
			newTween.target.ao = a_parameters.ao;
			newTween.original.ro = this.m_color.redOffset;
			newTween.original.go = this.m_color.greenOffset;
			newTween.original.bo = this.m_color.blueOffset;
			newTween.original.ao = this.m_color.alphaOffset;
			
			
			// 繪製次數
			if( a_parameters.time != undefined )
				newTween.runTime = a_parameters.time;
			else
				newTween.runTime = 0;
			if( a_parameters.delay != undefined )
				newTween.delayTime = a_parameters.delay;
			else
				newTween.delayTime = 0;
				
			newTween.maxTime = newTween.runTime + newTween.delayTime;
			newTween.currTime = 0;
			
			// 運算式(Transition)
			if( a_parameters.transition != undefined )
				newTween.transition = a_parameters.transition;
			else
				newTween.transition = "linear";
				
			// 完後是否要執行動作(onComplete)
			if( a_parameters.onComplete != undefined && a_parameters.onComplete != null )
				newTween.onComplete = a_parameters.onComplete;
			else
				newTween.onComplete = null;
			
			this.m_tweenList.push(newTween);
			
			return true;
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		public function set scale( a_value : Number ) : void
		{
			this.m_scaleX = this.m_scaleY = a_value;
		}
		public function set smooth( a_value : Boolean ) : void
		{
			this.m_isSmoothing = a_value;
		}
		/*read only：唯讀*/
		/*read/write：讀寫*/
		public function set pattern( a_pattern : BitmapData ) : void
		{
			this.m_bitmapData = null;
			this.m_bitmapData = a_pattern;
			
			this.m_bitmapInfo.width = this.m_bitmapData.width;
			this.m_bitmapInfo.height = this.m_bitmapData.height;
		}
		public function get pattern() : BitmapData
		{
			return this.m_bitmapData;
		}
		
		public function set patternInfo( a_patternInfo : Rectangle ) : void
		{
			this.m_bitmapInfo.width = a_patternInfo.width;
			this.m_bitmapInfo.height = a_patternInfo.height;
		}
		public function get patternInfo() : Rectangle
		{
			return this.m_bitmapInfo;
		}
		
		public function set isClip( a_isClip : Boolean ) : void
		{
			this.m_isClip = a_isClip;
		}
		public function get isClip() : Boolean
		{
			return this.m_isClip;
		}
		
		public function set scaleX( a_value : Number ) : void
		{
			this.m_scaleX = a_value;
		}
		public function get scaleX() : Number
		{
			return this.m_scaleX;
		}
		
		public function set scaleY( a_value : Number ) : void
		{
			this.m_scaleY = a_value;
		}
		public function get scaleY() : Number
		{
			return this.m_scaleY;
		}
		
		public function set blend( a_value : String ) : void
		{				
			this.m_blend = a_value;
		}
		public function get blend() : String
		{
			return this.m_blend;
		}
		
		public function set color( a_color : ColorTransform ) : void
		{
			this.m_palette.redMultiplier = a_color.redMultiplier;
			this.m_palette.redOffset = a_color.redOffset;
			this.m_palette.greenMultiplier = a_color.greenMultiplier;
			this.m_palette.greenOffset = a_color.greenOffset;
			this.m_palette.blueMultiplier = a_color.blueMultiplier;
			this.m_palette.blueOffset = a_color.blueOffset;
			this.m_palette.alphaMultiplier = a_color.alphaMultiplier;
			this.m_palette.alphaOffset = a_color.alphaOffset;
		}
		public function get color() : ColorTransform
		{
			return this.m_palette;
		}
		
		public function set location( a_location : Point ) : void
		{
			this.m_location = null;
			this.m_location = a_location;
		}
		public function get location() : Point
		{
			return this.m_location;
		}
		public function set x( a_location : Number ) : void
		{
			this.m_location.x = a_location;
		}
		public function get x() : Number
		{
			return this.m_location.x;
		}
		public function set y( a_location : Number ) : void
		{
			this.m_location.y = a_location;
		}
		public function get y() : Number
		{
			return this.m_location.y;
		}
		
		public function set drawMode( a_value : Number ) : void
		{
			if( a_value >= Texture.DRAW_ALWAY && a_value <= Texture.DRAW_ONE )
				this.m_drawMode = a_value;
			else
				this.m_drawMode = Texture.DRAW_ONE;
		}
		public function get drawMode() : Number
		{
			return this.m_drawMode;
		}
		
		public function set delay( a_value : Number ) : void
		{
			if( a_value < 0 )
				this.m_maxDelay = 0;
			else
				this.m_maxDelay = a_value;
			
			this.m_curDelay = m_maxDelay;
		}
		public function get delay() : Number
		{
			return this.m_maxDelay;
		}
		
		public function set parent( a_value : Texture ) : void
		{
			if( this.m_parent != a_value )
				this.m_parent = a_value;
		}
		public function get parent() : Texture
		{
			return this.m_parent;
		}
		/*private function：私用函數*/
		/*private event function：私用事件函數*/
		protected function EventDrawBitmap( a_panel : BitmapData ) : void
		{
			if( this.m_bitmapData != null )
			{
				a_panel.draw( this.m_bitmapData, this.m_matrix, this.m_color, this.m_blend, this.m_clipRect, this.m_isSmoothing);
			}
		}
	}
}
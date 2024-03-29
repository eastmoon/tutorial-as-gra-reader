﻿/*
////////////////////////////
////  TextureContainer  ////
////////////////////////////
	Info:
		- 
		
	Useage:(有開放public 讓外部使用)
		- AddTexture		: 增加Image中的圖樣物件 
		- RemoveTexture		: 刪除Image中的圖樣物件
		
		變數存取介面
		- textureList		: [read-only]Image中的圖樣物件列表
		
	Date:
		- 2010.01.05
		
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
		
	public class TextureContainer extends Texture
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		protected var m_textureArray : Array;
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function TextureContainer() : void
		{
			super(new Rectangle(0,0,950,550));
			
			this.m_textureArray = new Array();
		}
		/*public function：對外公開函數*/
		public function AddTexture( a_texture : Texture ) : void
		{
			a_texture.parent = this;
			this.m_textureArray.push( a_texture );
		}
		public function RemoveTexture( a_texture : Texture ) : void
		{
			for( var i = 0 ; i < this.m_textureArray.length ; i++ )
			{
				if( this.m_textureArray[i] == a_texture )
				{
					this.m_textureArray[i].parent = null;
					this.m_textureArray.splice(i, 1);
					break;
				}
			}
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get textureList() : Array
		{
			return this.m_textureArray;
		}
		/*read/write：讀寫*/
		/*private function：私用函數*/
		/*private event function：私用事件函數*/
		protected override function EventDrawBitmap( a_panel : BitmapData ) : void
		{
			if( a_panel != null )
			{
				for( var i = 0 ; i < this.m_textureArray.length ; i++ )
				{
					this.m_textureArray[i].blend = this.m_blend;
					this.m_textureArray[i].isClip = this.m_isClip;
					this.m_textureArray[i].Draw(a_panel);
				}
			}
		}
	}
}
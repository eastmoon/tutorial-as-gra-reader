/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package section.DEMO
{	
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import section.DEMO.enum.*;
	import section.DEMO.progress.SlideWindow.*;
	import org.gra.ApplicationFacade;
	import org.gra.controller.Progress.IProgressController;
	import org.gra.controller.WSProgressFlow.*;
	import org.gra.view.WindowSection.Core.SectionSprite;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;

	public class SectionFunctionBar extends SectionSprite
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_bcakground : Sprite;
		private var btn_1 : Sprite;
		private var btn_2 : Sprite;
		private var btn_3 : Sprite;
		private var btn_4 : Sprite;
		
		/*constructor：建構值*/
		public function SectionFunctionBar() : void
		{
			super(ENUM_SECTION.BAR_FUNCTION);
			
			this.mc_bcakground = new Sprite();
			this.mc_bcakground.graphics.beginFill( 0x888888, 1 );
			this.mc_bcakground.graphics.drawRect( 0, 0, 1, 1 );
			this.mc_bcakground.graphics.endFill();
			this.addChild( this.mc_bcakground );
			
			this.btn_1 = new Sprite();
			this.btn_1.graphics.beginFill( 0xff0000, 1 );
			this.btn_1.graphics.drawRect( 0, 0, 60, 60 );
			this.btn_1.graphics.endFill();
			this.btn_1.buttonMode = true;
			this.btn_1.addEventListener(MouseEvent.CLICK, this.EventToBookcase);
			this.addChild( this.btn_1 );
			
			this.btn_2 = new Sprite();
			this.btn_2.graphics.beginFill( 0x00ff00, 1 );
			this.btn_2.graphics.drawRect( 0, 0, 60, 60 );
			this.btn_2.graphics.endFill();
			this.btn_2.buttonMode = true;
			this.btn_2.addEventListener(MouseEvent.CLICK, this.EventToReader);
			this.addChild( this.btn_2 );
			
			this.btn_3 = new Sprite();
			this.btn_3.graphics.beginFill( 0x0000ff, 1 );
			this.btn_3.graphics.drawRect( 0, 0, 60, 60 );
			this.btn_3.graphics.endFill();
			this.btn_3.buttonMode = true;
			this.btn_3.addEventListener(MouseEvent.CLICK, this.EventToDownload);
			this.addChild( this.btn_3 );
			
			this.btn_4 = new Sprite();
			this.btn_4.graphics.beginFill( 0x880088, 1 );
			this.btn_4.graphics.drawRect( 0, 0, 60, 60 );
			this.btn_4.graphics.endFill();
			this.btn_4.buttonMode = true;
			this.btn_4.addEventListener(MouseEvent.CLICK, this.EventToConfig);
			this.addChild( this.btn_4 );
			
		}
		/*public function：對外公開函數*/
		public override function Active() : void
		{
		}
		public override function Unactive() : void
		{
			
		}
		public override function Update() : void
		{
			
		}
		public override function Draw() : void
		{
			var rect : Rectangle = this.getWindow().getCurrentViewport();
			if( this.mc_bcakground.width != rect.width )
			{
				this.mc_bcakground.width = rect.width;
				this.mc_bcakground.height = Math.floor( rect.height * 0.1 );
				if( this.mc_bcakground.height < 60 )
					this.mc_bcakground.height = 60;
				
				this.btn_1.x = ((this.mc_bcakground.width / 4) - this.btn_1.width ) / 2;
				this.btn_1.y = (this.mc_bcakground.height - this.btn_1.height) / 2;
				
				this.btn_2.x = ((this.mc_bcakground.width / 4) - this.btn_1.width ) / 2 + (this.mc_bcakground.width / 4);
				this.btn_2.y = (this.mc_bcakground.height - this.btn_2.height) / 2;
				
				this.btn_3.x = ((this.mc_bcakground.width / 4) - this.btn_1.width ) / 2 + (this.mc_bcakground.width / 4) * 2;
				this.btn_3.y = (this.mc_bcakground.height - this.btn_3.height) / 2;
				
				this.btn_4.x = ((this.mc_bcakground.width / 4) - this.btn_1.width ) / 2 + (this.mc_bcakground.width / 4) * 3;
				this.btn_4.y = (this.mc_bcakground.height - this.btn_4.height) / 2;
				
				this.y = rect.height - this.mc_bcakground.height;
			}
		}
		
		// 顯示內容進場，Progress Flow 控制函數
		
		public override function Display( a_flow : IProgressController = null ) : void
		{
			this.visible = true;
			if( a_flow != null )
				a_flow.Next();
		}
		// 顯示內容退場，Progress Flow 控制函數
		public override function Disappear( a_flow : IProgressController = null ) : void
		{
			this.visible = false;
			if( a_flow != null )
				a_flow.Next();
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		private function EventToBookcase( a_event : MouseEvent ) : void
		{
			trace("Click Bookcase");			
			ApplicationFacade.getInstance().sendNotification( SWProgressFlow.EVENT_PROGRESS_FLOW, 
								 new SWPFController( ENUM_WINDOW.CONTENT, ENUM_SECTION.PAGE_BOOKCASE, ENUM_WINDOW.CONTENT_SLIDE ));
		}
		private function EventToReader( a_event : MouseEvent ) : void
		{
			trace("Click Reader");
			ApplicationFacade.getInstance().sendNotification( SWProgressFlow.EVENT_PROGRESS_FLOW, 
								 new SWPFController( ENUM_WINDOW.CONTENT, ENUM_SECTION.PAGE_READER, ENUM_WINDOW.CONTENT_SLIDE ));
		}
		private function EventToDownload( a_event : MouseEvent ) : void
		{
			trace("Click Download");
			ApplicationFacade.getInstance().sendNotification( SWProgressFlow.EVENT_PROGRESS_FLOW, 
								 new SWPFController( ENUM_WINDOW.CONTENT, ENUM_SECTION.PAGE_DOWNLOAD, ENUM_WINDOW.CONTENT_SLIDE ));
		}
		private function EventToConfig( a_event : MouseEvent ) : void
		{
			trace("Click Config");
			ApplicationFacade.getInstance().sendNotification( SWProgressFlow.EVENT_PROGRESS_FLOW, 
								 new SWPFController( ENUM_WINDOW.CONTENT, ENUM_SECTION.PAGE_CONFIG, ENUM_WINDOW.CONTENT_SLIDE ));
		}
		/*private function：私用函數*/
	}
}
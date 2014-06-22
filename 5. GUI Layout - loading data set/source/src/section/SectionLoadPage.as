/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package src.section
{	
	/*import：Flash內建元件庫*/
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	// Game rule architecture Import
    import org.gra.ApplicationFacade;
	import org.gra.view.WindowSection.Core.SectionSprite;
	import org.gra.controller.Progress.IProgressController;
	import org.gra.controller.WSProgressFlow.*;
	//
	import src.enum.*;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;
	// 載入控制函式庫
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;

	public class SectionLoadPage extends SectionSprite
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_resourceQueue:LoaderMax;
		private var m_loaderQueue:LoaderMax;
		/*display object variable：顯示物件變數，如MovieClip等*/
		public var mc_background : Sprite;
		private var tf_textField : TextField;
		
		/*constructor：建構值*/
		public function SectionLoadPage() : void
		{
			super(ENUM_SECTION.PAGE_LOAD);
			
			this.mc_background = new Sprite();
			this.addChild( this.mc_background );
			
			this.tf_textField = new TextField();
			this.tf_textField.textColor = 0xffffff;
			this.tf_textField.autoSize = TextFieldAutoSize.CENTER;
			this.tf_textField.text = "Loading ...";
			this.tf_textField.cacheAsBitmap = true;
			this.addChild( this.tf_textField );
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
			
			if( this.mc_background.width != rect.width && this.mc_background.height != rect.height )
			{
				this.mc_background.graphics.clear();
				this.mc_background.graphics.beginFill( 0x000000, 0.95 );
				this.mc_background.graphics.drawRect( 0, 0, rect.width, rect.height );
				this.mc_background.graphics.endFill();
				
				this.tf_textField.x = ( rect.width - this.tf_textField.width ) / 2;
				this.tf_textField.y = ( rect.height - this.tf_textField.height ) / 2;
			}
		}
		
		// 顯示內容進場，Progress Flow 控制函數
		public override function Display( a_flow : IProgressController = null ) : void
		{
			//this.visible = true;
			trace( "Load Display" );
			// Start Load
			this.Load();
			
			if( a_flow != null )
				a_flow.Next();
		}
		// 顯示內容退場，Progress Flow 控制函數
		public override function Disappear( a_flow : IProgressController = null ) : void
		{
			//this.visible = false;
			trace( "Load Disappear" );
			if( a_flow != null )
				a_flow.Next();
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		private function EventLoaderProgress( a_event : LoaderEvent ):void
		{
			trace("Loading progress: " + Math.floor(a_event.target.progress * 100)  );
		}
		private function EventResourceComplete( a_event : LoaderEvent ):void
		{
			trace("EventResourceComplete!");
		}
		private function EventConfigComplete( a_event : LoaderEvent ):void
		{
			trace("EventConfigComplete!", (a_event.target as XMLLoader).content);
		}
		private function EventBookcaseComplete( a_event : LoaderEvent ):void
		{
			trace("EventBookcaseComplete!", (a_event.target as XMLLoader).content);
		}
		private function EventBookCoverComplete( a_event : LoaderEvent ):void
		{
			trace("EventBookCoverComplete!");
		}
		private function EventLoaderComplete( a_event : LoaderEvent ):void
		{
			trace("Game loading is complete!");	
			ApplicationFacade.getInstance().sendNotification( WSProgressFlow.EVENT_PROGRESS_FLOW,  
															 new WSPFController( ENUM_WINDOW.MESSAGE ));
		}
		private function EventLoaderError( a_event : LoaderEvent ):void
		{
			trace("error occured with " + a_event.target + ": " + a_event.text);
		}
		/*private function：私用函數*/
		private function Load():void
		{
			// 建立讀取佇列
			this.m_resourceQueue = new LoaderMax({name:"ResourceQueue",onProgress:EventLoaderProgress,onComplete:LoadCover,onError:EventLoaderError,maxConnections:1});
					
			// 控制檔案載入
			this.m_resourceQueue.append( new XMLLoader("config.xml", {name:"confing", onComplete:EventConfigComplete, onError:EventLoaderError} ));  
			this.m_resourceQueue.append( new XMLLoader("bookcase.xml", {name:"bookcase", onComplete:EventBookcaseComplete, onError:EventLoaderError} )); 
			
			// 載入
			this.m_resourceQueue.load();
		}
		private function LoadCover( a_event : LoaderEvent ):void
		{
			var bookcase : XML = null;
			var datalist : XMLList = null;
			if( (LoaderMax.getLoader("bookcase") as XMLLoader) != null )
				bookcase = ((LoaderMax.getLoader("bookcase") as XMLLoader).content as XML);
			else
				bookcase = null;
			
			datalist = bookcase.elements( "book" );
			
			trace( "bookcase size : ", datalist.length() );
			// 建立讀取佇列
			this.m_resourceQueue = new LoaderMax({name:"BookCoverQueue",onProgress:EventLoaderProgress,onComplete:EventLoaderComplete,onError:EventLoaderError,maxConnections:1});
			
			// 依據書櫃內容建立封面載入
			for( var i = 0 ; i < datalist.length() ; i++ )
			{
				var book : XML = datalist[i] as XML;
				trace( book["id"], book["cover"], book["name"] );
				this.m_resourceQueue.append( new ImageLoader( "bookcase/" + book["id"] + "/" + book["cover"], {name:"bookCover_" + book["name"], onComplete:EventBookCoverComplete, onError:EventLoaderError} ));
				
			}
			
			// 載入
			this.m_resourceQueue.load();
		}
	}
}
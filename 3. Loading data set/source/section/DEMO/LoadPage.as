/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package section.DEMO
{
	// 載入控制函式庫
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.events.LoaderEvent;

	//
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	// 
	import com.greensock.loading.XMLLoader;
	import flash.events.Event;
	import com.greensock.loading.ImageLoader;
	import flash.net.URLRequest;
	
	public class LoadPage extends Sprite
	{
		public static const LOAD_GAME : String= "load_game";

		private var m_resourceQueue:LoaderMax;
		private var m_loaderQueue:LoaderMax;
		private var m_gamePage : Sprite;

		public function LoadPage()
		{
		}
		public function Load():void
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
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		private function EventLoaderError( a_event : LoaderEvent ):void
		{
			trace("error occured with " + a_event.target + ": " + a_event.text);
		}
	}
}
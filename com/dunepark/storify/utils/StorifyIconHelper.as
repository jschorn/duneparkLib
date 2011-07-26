package com.dunepark.storify.utils
{
	import com.dunepark.storify.Storify;
	import com.dunepark.storify.objects.StorifyElementVO;

	public class StorifyIconHelper
	{
		public static function getIcon( vo:StorifyElementVO ):String
		{
			var iconPath:String;
	
			switch (vo.source)
			{
				case Storify.SOURCE_CNET:
					iconPath = "assets/icons/rss.png";
					break;
				
				case Storify.SOURCE_ENGADGET:
					iconPath = "assets/icons/rss.png";
					break;
	
				case Storify.SOURCE_FACEBOOK:
					iconPath = "assets/icons/facebook.png";
					break;
	
				case Storify.SOURCE_FLICKR:
					iconPath = "assets/icons/flickr.png";
					break;
		
				case Storify.SOURCE_GOOGLE:
					iconPath = "assets/icons/rss.png";
					break;
	
				case Storify.SOURCE_STORIFY:
					iconPath = "assets/icons/rss.png";
					break;
	
				case Storify.SOURCE_TWITTER:
					iconPath = "assets/icons/twitter.png";
					break;
	
				case Storify.SOURCE_YOUTUBE:
					iconPath = "assets/icons/youtube.png";
					break;
	
				case "Toughbloggers":
					iconPath = "assets/icons/rss.png";
					break;
				
				case null:
					return null;
					break;
				
				default:
					iconPath = "assets/icons/rss.png";
					break;
			}
					
			return iconPath;
		}
		
	}
}
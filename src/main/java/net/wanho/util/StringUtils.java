package net.wanho.util;

import java.util.Date;


/**
 * 
 * @包名:			[ net.wanho.util ]  
 * @类名:			[ StringUtils ]  
 * @描述:			[ 字符串工具类 ] 
 */

public class StringUtils{

	/**
	 * 
	 * @方法名:			[ isNotEmpty ]		
	 * @返回类型:			[ boolean ]
	 * @功能描述:      	[ 判断一个Integer类型不能为空 ]
	 */
	public static boolean isNotEmpty(Integer value) {
		return value!=null && value!=0;
	}
	

	public static boolean isNotEmpty(Long value) {
		return value!=null && value!=0L;
	}

	/**
	 * 
	 * @方法名:			[ isNotEmpty ]		
	 * @返回类型:			[ boolean ]
	 * @功能描述:     		[ 判断一个String类型不能为空 ]
	 */
	public static boolean isNotEmpty(String value) {
		return value!=null && !value.isEmpty();
		
	}
	
	public static boolean isNotEmpty(Date tbirthday) {
		return tbirthday!=null;
	}
   

	 /**
     * 去除最后的逗号
     */
	public static void trimEndComma(StringBuilder sb) {
		if(sb.toString().endsWith(","))
			sb.deleteCharAt(sb.length()-1);
	}
	
}
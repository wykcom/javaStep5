package net.wanho.util;

/**
 * 类型转换器
 * 
 * 
 */
public class Convert {

	/**
	 * 转换为Integer数组<br>
	 * 
	 * @param split
	 *            分隔符
	 * @param split
	 *            被转换的值
	 * @return 结果
	 */
	public static Integer[] toIntArray(String split, String str) {
		if (!StringUtils.isNotEmpty(str)) {
			return new Integer[] {};
		}
		String[] arr = str.split(split);
		final Integer[] ints = new Integer[arr.length];
		for (int i = 0; i < arr.length; i++) {
			ints[i] = Integer.parseInt(arr[i]);
		}
		return ints;
	}

	public static Long[] toLongArray(String split, String str) {
		if (!StringUtils.isNotEmpty(str)) {
			return new Long[] {};
		}
		String[] arr = str.split(split);
		final Long[] longs = new Long[arr.length];
		for (int i = 0; i < arr.length; i++) {
			longs[i] = Long.parseLong(arr[i]);
		}
		return longs;
	}

}

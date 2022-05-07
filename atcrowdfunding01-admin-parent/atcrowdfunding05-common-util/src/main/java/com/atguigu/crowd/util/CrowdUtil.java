package com.atguigu.crowd.util;


import javax.servlet.http.HttpServletRequest;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author Wxt
 * @create 2022-04-02 18:27
 */
public class CrowdUtil {
    /**
     * 判断当前请求是否为ajax请求
     *
     * @param request
     * @return true:当前请求是ajax请求
     * false:当前请求不是ajax请求
     */
    public static boolean judgeRequestType(HttpServletRequest request) {
        // 1.获取请求消息头(Accept)
        String accept = request.getHeader("Accept");
        String xRequestedWith = request.getHeader("X-Requested-With");
        // 2.判断
        return ((accept != null && accept.contains("application/json")) || (xRequestedWith != null && xRequestedWith.equals("XMLHttpRequest")));
    }

    /**
     * 对明文字符串进行MD5加密
     * @param source
     * @return
     */
    public static String md5(String source) {
        // 1.判断source是否有效
        if (source == null || source.length() == 0) {
            // 2.如果不是有效的字符串抛出异常
            throw new RuntimeException(CrowdConstant.MESSAGE_STRING_INVALIDATE);
        }
        // 3.获取MessageDigest对象
        try {
            String algorithm = "md5";
            MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
            //4.获取明文字符串对应的字节数组
            byte[] sourceBytes = source.getBytes();
            // 5.执行加密
            byte[] output = messageDigest.digest(sourceBytes);
            // 6.创建BigInteger对象
            int signum = 1;
            BigInteger bigInteger = new BigInteger(signum, output);
            // 7.按照16进制将BigInteger的值转换为字符串
            int radix = 16;
            String encoded = bigInteger.toString(radix).toUpperCase();
            return encoded;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
}

package com.atguigu.crowd.exception;

/**
 *
 * 用户没有登录就访问受保护资源的异常
 * @author Wxt
 * @create 2022-04-03 15:25
 */
public class AccessForbiddenException extends RuntimeException{
    static final long serialVersionUID = 2L;

    public AccessForbiddenException() {
        super();
    }

    public AccessForbiddenException(String message) {
        super(message);
    }

    public AccessForbiddenException(String message, Throwable cause) {
        super(message, cause);
    }

    public AccessForbiddenException(Throwable cause) {
        super(cause);
    }

    protected AccessForbiddenException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}

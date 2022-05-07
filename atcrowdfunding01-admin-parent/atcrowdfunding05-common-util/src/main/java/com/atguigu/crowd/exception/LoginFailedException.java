package com.atguigu.crowd.exception;

/**
 *
 * 登录失败抛出的异常
 * @author Wxt
 * @create 2022-04-03 9:55
 */
public class LoginFailedException extends RuntimeException{
    static final long serialVersionUID = 1L;

    public LoginFailedException() {
        super();
    }

    public LoginFailedException(String message) {
        super(message);
    }

    public LoginFailedException(String message, Throwable cause) {
        super(message, cause);
    }

    public LoginFailedException(Throwable cause) {
        super(cause);
    }

    protected LoginFailedException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}

package com.atguigu.crowd.exception;

/**
 *
 * 保存或更新Admin时如果检测到登录账号重复抛出这个异常
 * @author Wxt
 * @create 2022-04-04 15:11
 */
public class LoginAcctAlreadyInUseException extends RuntimeException{
    static final long serialVersionUID = 4L;

    public LoginAcctAlreadyInUseException() {
        super();
    }

    public LoginAcctAlreadyInUseException(String message) {
        super(message);
    }

    public LoginAcctAlreadyInUseException(String message, Throwable cause) {
        super(message, cause);
    }

    public LoginAcctAlreadyInUseException(Throwable cause) {
        super(cause);
    }

    protected LoginAcctAlreadyInUseException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}

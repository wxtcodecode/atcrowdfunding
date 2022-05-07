package com.atguigu.crowd.exception;

/**
 * @author Wxt
 * @create 2022-04-04 10:12
 */
public class RemoveMySelfException extends RuntimeException{
    static final long serialVersionUID = 3L;

    public RemoveMySelfException() {
        super();
    }

    public RemoveMySelfException(String message) {
        super(message);
    }

    public RemoveMySelfException(String message, Throwable cause) {
        super(message, cause);
    }

    public RemoveMySelfException(Throwable cause) {
        super(cause);
    }

    protected RemoveMySelfException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}

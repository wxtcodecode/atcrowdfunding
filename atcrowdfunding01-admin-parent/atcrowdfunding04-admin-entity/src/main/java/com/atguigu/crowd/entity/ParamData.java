package com.atguigu.crowd.entity;

import java.util.List;

/**
 * @author Wxt
 * @create 2022-04-02 16:17
 */
public class ParamData {
    private List<Integer> array;

    public ParamData(List<Integer> array) {
        this.array = array;
    }

    public List<Integer> getArray() {
        return array;
    }

    public void setArray(List<Integer> array) {
        this.array = array;
    }

    @Override
    public String toString() {
        return "ParamData{" +
                "array=" + array +
                '}';
    }
}

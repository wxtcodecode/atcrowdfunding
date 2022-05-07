package com.atguigu.crowd.entity;

/**
 * @author Wxt
 * @create 2022-04-02 16:44
 */
public class Subject {
    private String subjectName;
    private Integer subjectScore;

    public Subject() {
    }

    public Subject(String subjectName, Integer subjectScore) {
        this.subjectName = subjectName;
        this.subjectScore = subjectScore;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public Integer getSubjectScore() {
        return subjectScore;
    }

    public void setSubjectScore(Integer subjectScore) {
        this.subjectScore = subjectScore;
    }

    @Override
    public String toString() {
        return "Subject{" +
                "subjectName='" + subjectName + '\'' +
                ", subjectScore=" + subjectScore +
                '}';
    }
}

package com.atguigu.crowd.test;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * @author Wxt
 * @create 2022-04-01 16:32
 */
//Spring整合Junit
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class CrowdTest {
    @Autowired
    private DataSource dataSource;
    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private AdminService adminService;
    @Test
    public void testConnection() throws SQLException {
        Connection conn = dataSource.getConnection();
        System.out.println(conn);
    }
    @Test
    public void InsertAdmin() {
        int i = adminMapper.insert(new Admin(null, "tom", "123123", "汤姆", "tom@qq.com", null));
        //如果在实际开发中，所要查看数值的地方都使用System.out.println()方式打印，会给项目上线运行带来问题
        //System.out.println()本质是一个IO操作，通常IO操作是比较消耗资源的，如果项目中System.out.println()很多，对性能的影响就比较大了
        //即使上线成专门花时间去删除代码中的System.out.println()，也有可能有遗漏，而且非常麻烦
        //而如果使用日志系统，那么通过日志级别就可以批量的控制信息的打印
        System.out.println("受影响的行数:" + i);
    }
    @Test
    public void testLog() {
        //1.获取Logger对象,这里注入的Class对象就是当前打印日志的类
        Logger logger = LoggerFactory.getLogger(CrowdTest.class);
        //2.根据不同日志级别打印日志
        logger.debug("Hello I am Debug level!!");
        logger.debug("Hello I am Debug level!!");
        logger.debug("Hello I am Debug level!!");

        logger.info("Hello I am Info level!!");
        logger.info("Hello I am Info level!!");
        logger.info("Hello I am Info level!!");

        logger.warn("Hello I am Warn level!!");
        logger.warn("Hello I am Warn level!!");
        logger.warn("Hello I am Warn level!!");

        logger.error("Hello I am Error level!!");
        logger.error("Hello I am Error level!!");
        logger.error("Hello I am Error level!!");
    }
    @Test
    public void testService() {
        adminService.saveAdmin(new Admin(null, "Jack", "jack123", "杰克", "jack@qq.com", null));
        System.out.println("保存成功");
    }
}

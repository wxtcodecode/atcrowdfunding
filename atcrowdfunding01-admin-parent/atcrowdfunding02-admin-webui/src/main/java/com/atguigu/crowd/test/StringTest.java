package com.atguigu.crowd.test;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.util.CrowdUtil;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * @author Wxt
 * @create 2022-04-05 9:03
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class StringTest {
    @Autowired
    private SqlSession session;
    @Autowired
    private RoleMapper roleMapper;
    @Test
    public void testMD5() {
        String source = "123123";
        String encoded = CrowdUtil.md5(source);
        System.out.println(encoded);
    }
    @Test
    public void addUserByUUID() {
        AdminMapper mapper = session.getMapper(AdminMapper.class);
        for (int i = 0; i < 400; i++) {
            String loginAcct = UUID.randomUUID().toString().substring(0, 5) + "" + i;
            String password = loginAcct.substring(1, 5) + "" +i;
            String userPawd = CrowdUtil.md5(password);
            String email = loginAcct + "@qq.com";
            Date date = new Date();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String createTime = simpleDateFormat.format(date);
            mapper.insert(new Admin(null, loginAcct, userPawd, loginAcct, email, createTime));
        }
    }
    @Test
    public void testSaveRole() {
        for (int i = 0; i < 235; i++) {
            roleMapper.insert(new Role(null, "role" + i));
        }
    }
}

package com.atguigu.crowd.service.impl;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.AdminExample;
import com.atguigu.crowd.exception.LoginFailedException;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.CrowdConstant;
import com.atguigu.crowd.util.CrowdUtil;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * @author Wxt
 * @create 2022-04-01 20:28
 */
@Service
public class AdminServiceImpl implements AdminService{
    @Autowired
    private AdminMapper adminMapper;
    @Override
    public void saveAdmin(Admin admin) {
        adminMapper.insert(admin);
    }

    @Override
    public List<Admin> getAll() {
        return adminMapper.selectByExample(null);
    }

    @Override
    public Admin getAdminByLoginAcct(String loginAcct, String userPswd) {
        //1. 根据登录账号查询Admin对象
        AdminExample example = new AdminExample();
        example.createCriteria().andLoginAcctEqualTo(loginAcct);
        List<Admin> admins = adminMapper.selectByExample(example);
        // 2.判断Admin对象是否为空
        if(admins == null || admins.size() == 0) {
            // 3.如果为null，则抛出异常
            throw new LoginFailedException(CrowdConstant.MESSAGE_LOGINFAILED);
        }
        if(admins.size() > 1) {
            throw new RuntimeException(CrowdConstant.MESSAGE_SYSTEM_ERROR_LOGIN_NOT_UNIQUE);
        }
        Admin admin = admins.get(0);
        if(admin == null) {
            throw new LoginFailedException(CrowdConstant.MESSAGE_LOGINFAILED);
        }
        // 4.如果Admin对象不为null，则将数据库密码从Admin对象中取出
        String encoded = CrowdUtil.md5(userPswd);
        // 5.将表单提交的明文密码进行加密
        String code = admin.getUserPswd();
        // 6.对密码进行比较
        // 7.如果比较结果一致返回Admin对象
        if(Objects.equals(code, encoded)) {
                return admin;

            }
        // 8.如果不一致，抛出异常
        else {
                throw new LoginFailedException(CrowdConstant.MESSAGE_LOGINFAILED);
            }
    }

    @Override
    public PageInfo<Admin> getPageInfo(String keyword, Integer pageNum, Integer pageSize) {
        // 1.调用PageHelper的静态方法开启分页功能
        //"非侵入式"设计，原本要做的查询不必有任何修改
        PageHelper.startPage(pageNum, pageSize);
        // 2.执行查询
        List<Admin> list = adminMapper.selectByKeyword(keyword);
        // 3.封装到pageInfo对象中
        return new PageInfo<>(list);
    }

    @Override
    public void remove(Integer adminId) {
        adminMapper.deleteByPrimaryKey(adminId);
    }

    @Override
    public Admin getAdminById(Integer adminId) {
        return adminMapper.selectByPrimaryKey(adminId);
    }

    @Override
    public void update(Admin admin) {
        // 表示有选择的更新，对于null值的字段不更新
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public void saveAdminRoleRelationship(Integer adminId, List<Integer> roleIdList) {
        // 为了简化操作，先根据adminId先删除旧的数据，在保存全部新的数据
        // 1.根据adminId删除旧的关联关系数据
        adminMapper.deleteRelationship(adminId);
        // 2.根据roleIdList和adminId保存新的关联数据
        if(roleIdList != null && roleIdList.size() > 0) {
            adminMapper.insertNewRelationship(adminId,roleIdList);
        }

    }

    @Override
    public Admin getAdminByLoginAcct(String username) {
        AdminExample example = new AdminExample();
        example.createCriteria().andLoginAcctEqualTo(username);
        List<Admin> adminList = adminMapper.selectByExample(example);
        Admin admin = adminList.get(0);
        return admin;
    }
}

package com.atguigu.crowd.service.api;

import com.atguigu.crowd.entity.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * @author Wxt
 * @create 2022-04-04 23:28
 */
public interface RoleService {
    void saveRole(Role role);

    PageInfo<Role> getPageInfo(Integer pageNum, Integer pageSize, String keyword);

    void updateRole(Role role);

    void removeRole(List<Integer> roleIdList);

    List<Role> getAssignedRole(Integer adminId);

    List<Role> getUnAssignedRole(Integer adminId);
}

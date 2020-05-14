package com.instagram.clone.model.dao.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.instagram.clone.model.vo.MemberJoinProfileSimpleVo;
import com.instagram.clone.model.vo.MemberJoinProfileVo;
import com.instagram.clone.model.vo.MemberProfileVo;
import com.instagram.clone.model.vo.MemberVo;

@Repository
public class MemberDaoImpl implements MemberDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public int insertProfile(MemberProfileVo memberProfileVo) {
		return sqlSession.insert(NAMESPACE + "insertProfile", memberProfileVo);
	}

	@Override
	public MemberProfileVo selectMemberProfile(int member_code) {
		return sqlSession.selectOne(NAMESPACE + "selectMemberProfile", member_code);
	}

	@Override
	public int updateMemberProfileImage(MemberProfileVo member_profile) {
		System.out.println(member_profile);
		return sqlSession.update(NAMESPACE + "updateMemberProfileImage", member_profile);
	}

	@Override
	public int updateMemberProfile(MemberProfileVo memberProfileVo) {
		System.out.println(memberProfileVo);
		return sqlSession.update(NAMESPACE + "updateMemberProfile", memberProfileVo);
	}

	@Override
	public int updateMember(MemberVo memberVo) {
		System.out.println(memberVo);
		return sqlSession.update(NAMESPACE + "updateMember", memberVo);
	}

	@Override
	public List<MemberJoinProfileVo> nameSearchAutoComplete(int my_member_code, String id_name) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("my_member_code", my_member_code);
		map.put("id_name", id_name);

		return sqlSession.selectList(NAMESPACE + "nameSearchAutoComplete", map);
	}

	@Override
	public List<MemberJoinProfileSimpleVo> selectMemberList(List<Integer> codeList) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("codeList", codeList);

		return sqlSession.selectList(NAMESPACE + "selectMemberList", map);
	}

}

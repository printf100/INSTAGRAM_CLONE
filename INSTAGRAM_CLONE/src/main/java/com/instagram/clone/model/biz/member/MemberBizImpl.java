package com.instagram.clone.model.biz.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.instagram.clone.model.dao.member.MemberDao;
import com.instagram.clone.model.vo.MemberJoinProfileSimpleVo;
import com.instagram.clone.model.vo.MemberJoinProfileVo;
import com.instagram.clone.model.vo.MemberProfileVo;
import com.instagram.clone.model.vo.MemberVo;

@Service
public class MemberBizImpl implements MemberBiz {

	@Autowired
	private MemberDao dao;

	@Override
	public MemberProfileVo selectMemberProfile(int member_code) {
		return dao.selectMemberProfile(member_code);
	}

	@Override
	public int updateMemberProfileImage(MemberProfileVo member_profile) {
		return dao.updateMemberProfileImage(member_profile);
	}

	@Override
	public int updateMemberProfile(MemberProfileVo memberProfileVo) {
		return dao.updateMemberProfile(memberProfileVo);
	}

	@Override
	public int updateMember(MemberVo memberVo) {
		return dao.updateMember(memberVo);
	}

	@Override
	public List<MemberJoinProfileVo> nameSearchAutoComplete(int my_member_code, String id_name) {
		return dao.nameSearchAutoComplete(my_member_code, id_name);
	}

	@Override
	public List<MemberJoinProfileSimpleVo> selectMemberList(List<Integer> codeList) {
		return dao.selectMemberList(codeList);
	}

}

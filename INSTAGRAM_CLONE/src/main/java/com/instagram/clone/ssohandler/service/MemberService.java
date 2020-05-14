package com.instagram.clone.ssohandler.service;

import com.instagram.clone.ssohandler.domain.entity.Member;

public interface MemberService {
	//
	Member getUser(String userName);

	boolean updateTokenId(String userName, String token);

}
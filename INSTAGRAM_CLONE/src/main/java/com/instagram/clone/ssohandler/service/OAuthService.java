package com.instagram.clone.ssohandler.service;

import javax.servlet.http.HttpServletRequest;

import com.instagram.clone.ssohandler.domain.vo.Response;
import com.instagram.clone.ssohandler.domain.vo.TokenRequestResult;

public interface OAuthService {
	//
	TokenRequestResult requestAccessTokenToAuthServer(String code, HttpServletRequest request);

	Response logout(String tokenId, String userName);

}
package com.instagram.clone.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.instagram.clone.common.properties.ApplicationProperties;
import com.instagram.clone.model.biz.member.MemberBiz;
import com.instagram.clone.model.vo.MemberVo;
import com.instagram.clone.ssohandler.domain.entity.Member;
import com.instagram.clone.ssohandler.service.MemberService;

@RestController
@RequestMapping("/feed/*")
public class FeedController implements ApplicationProperties {

	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);

	@Autowired
	private MemberService memberService;

	@Autowired
	private MemberBiz memberBiz;

	// feed.jsp 로 이동
	@GetMapping(value = "")
	public ModelAndView mainPage(HttpServletRequest request, ModelMap map) {
		logger.info("FEED/FEED.GET");

		MemberVo memberVo = (MemberVo) request.getSession().getAttribute("user");
		System.out.println("\n## user in session : " + memberVo);

		if (memberVo == null) {
			//
			return new ModelAndView("redirect:feed/");
		}

		Member member = memberService.getUser(memberVo.getMember_id());
		System.out.println("\n## user : " + member);

		if (member.getTokenId() == null) {
			request.getSession().removeAttribute("user");
			return new ModelAndView("redirect:feed/");
		} else {
			map.put("user", member);
			// 프로필 session 주입
			request.getSession().setAttribute("profile", memberBiz.selectMemberProfile(member.getMembercode()));
			// 서버 포트를 session에 셋팅하여 jsp 페이지에서 사용한다.
			request.getSession().setAttribute("SERVER_PORT", SERVER_PORT);
		}

		return new ModelAndView("feed/feed");
	}

	@PostMapping(value = "feedlist")
	public Map<String, String> feedList(int startNo) {
		logger.info("FEED/FEEDLIST");

		Map<String, String> map = new HashMap<String, String>();

		return map;
	}
}

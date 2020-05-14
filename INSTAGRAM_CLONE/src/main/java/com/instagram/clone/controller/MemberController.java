package com.instagram.clone.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.instagram.clone.model.biz.member.MemberBiz;
import com.instagram.clone.model.vo.MemberProfileVo;
import com.instagram.clone.model.vo.MemberVo;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@RestController
@RequestMapping("/member")
public class MemberController {

	@Autowired
	private MemberBiz biz;

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	/*
	 * profile 遺�遺�
	 */

	// profileUpdate
	@PostMapping(value = "/profileUpdate")
	public ModelAndView profileUpdate(HttpSession session, MemberVo vo, MemberProfileVo pvo) {

		int ress = biz.updateMember(vo);
		int res = biz.updateMemberProfile(pvo);

		if (res > 0 && ress > 0) {
			return new ModelAndView("member/profile");
		} else {
			return new ModelAndView("member/profileEdit");
		}
	}

	// profile.jsp 濡� �씠�룞
	@GetMapping(value = "/profile")
	public ModelAndView profilePage(Model model) {
		logger.info("MEMBER/PROFILE.GET");
		return new ModelAndView("member/profile");
	}

	@RequestMapping(value = "/profileEdit")
	public ModelAndView insert() {

		return new ModelAndView("member/profileEdit");
	}

	// 怨꾩젙愿�由�(�젙蹂�: �씠誘몄�) �닔�젙泥섎━
	@PostMapping(value = "/updateprofileimage")
	private Map<String, Object> updateProfileImage(HttpServletRequest request, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();

		// �뾽濡쒕뱶�맆 寃쎈줈
		String filePath = "/resources/images/profileupload/";

		// �뾽濡쒕뱶�맆 �떎�젣 寃쎈줈 (�씠�겢由쎌뒪 �긽�쓽 �젅��寃쎈줈)
		String FILE_PATH = request.getSession().getServletContext().getRealPath(filePath);
		System.out.println("�젅��寃쎈줈 : " + FILE_PATH);

		// �뵒�젆�넗由� �뾾�쓣 �떆 �옄�룞 �깮�꽦!
		File file;
		if (!(file = new File(FILE_PATH)).isDirectory()) {
			file.mkdirs();
		}

		MultipartRequest mr = null;

		try {

			mr = new MultipartRequest(request, // request 媛앹껜
					FILE_PATH, // �뙆�씪�씠 ���옣�맆 �뤃�뜑
					1024 * 1024 * 3, // 理쒕� �뾽濡쒕뱶�겕湲� (3MB)
					"UTF-8", // �씤肄붾뵫 諛⑹떇
					new DefaultFileRenamePolicy() // �룞�씪�븳 �뙆�씪紐낆씠 議댁옱�븯硫� �뙆�씪紐� �뮘�뿉 �씪�젴踰덊샇瑜� 遺��뿬
			);

		} catch (IOException e) {
			System.out.println("[ ERROR ] : BoardController - MultipartRequest 媛앹껜 �깮�꽦 �삤瑜�");
			e.printStackTrace();
		}

		MemberProfileVo member_profile = new MemberProfileVo();

		// �뙆�씪誘명꽣 諛쏄린
		int member_code = Integer.parseInt(mr.getParameter("member_code"));
		// �뙆�씪 泥⑤�
		String MEMBER_IMG_SERVER_NAME = null;
		String MEMBER_IMG_ORIGINAL_NAME = null;
		String imgExtend = null;

		// �떎�젣 ���옣�맂 �뙆�씪紐�
		MEMBER_IMG_SERVER_NAME = mr.getFilesystemName("member_img_original_name");

		if (MEMBER_IMG_SERVER_NAME != null) {
			// �썝�옒 �씠誘몄� �씠由�
			MEMBER_IMG_ORIGINAL_NAME = mr.getOriginalFileName("member_img_original_name");

			// �씠誘몄� �솗�옣�옄
			imgExtend = MEMBER_IMG_SERVER_NAME.substring(MEMBER_IMG_SERVER_NAME.lastIndexOf(".") + 1);
			System.out.println("�씠誘몄��솗�옣�옄:" + imgExtend);
		}

		member_profile.setMember_code(member_code);
		member_profile.setMember_img_original_name(MEMBER_IMG_ORIGINAL_NAME);
		member_profile.setMember_img_server_name(MEMBER_IMG_SERVER_NAME);
		member_profile.setMember_img_path(FILE_PATH);

		int res = biz.updateMemberProfileImage(member_profile);

		if (res > 0) {
			// �봽濡쒗븘 �젙蹂대�� session�뿉 由ъ뀑
			session = request.getSession();
			MemberProfileVo new_member_profile = biz.selectMemberProfile(member_code);
			session.removeAttribute("profile");
			session.setAttribute("profile", new_member_profile);
			System.out.println(new_member_profile);
		}

		map.put("res", res);
		map.put("img", biz.selectMemberProfile(member_code).getMember_img_server_name());
		return map;
	}

}
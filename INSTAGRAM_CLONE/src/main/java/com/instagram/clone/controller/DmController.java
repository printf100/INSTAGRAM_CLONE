package com.instagram.clone.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.instagram.clone.model.biz.dm.MongoDmBiz;
import com.instagram.clone.model.biz.member.MemberBiz;
import com.instagram.clone.model.vo.DmVo;
import com.instagram.clone.model.vo.MemberJoinProfileVo;

@RestController
@RequestMapping("/dm/*")
public class DmController {

	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);

	@Autowired
	private MemberBiz memberBiz;

	@Autowired
	private MongoDmBiz mongoDmBiz;

	// dm.jsp 로 이동
	@GetMapping(value = "")
	public ModelAndView dmPage() {
		logger.info("DM/DM.GET");

		return new ModelAndView("dm/dm");
	}

	// nameSearchAutoComplete
	@PostMapping(value = "nameSearchAutoComplete")
	public List<MemberJoinProfileVo> nameSearchAutoComplete(int my_member_code, String id_name) {
		logger.info("DM/nameSearchAutoComplete.POST");
		return memberBiz.nameSearchAutoComplete(my_member_code, id_name);
	}

	// 채팅방 리스트 방기
	@PostMapping(value = "findMyChatRoomList")
	public List<DmVo> findMyChatRoomList(@RequestBody Map<String, Integer> my_member_code) {
		logger.info("DM/findMyChatRoomList.POST");

		List<DmVo> list = mongoDmBiz.findMyChatRoomList(my_member_code.get("my_member_code"));
		for (DmVo d : list) {
			System.out.println(d);
		}
		return list;
	}

	// 채팅방 만들기
	@PostMapping(value = "makeChatRoom")
	public Map<String, Object> makeChatRoom(@RequestBody List<Map<String, Object>> memberList) {
		logger.info("DM/mackChatRoom.POST");

		DmVo newRoom = new DmVo();

		List<Integer> codeList = new ArrayList<>();
		for (Map<String, Object> m : memberList) {
			codeList.add((Integer) m.get("member_code"));
		}
		newRoom.setMember_list(memberBiz.selectMemberList(codeList));

		DmVo insertedChatRoom = mongoDmBiz.insertChatRoom(newRoom);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("insertedChatRoom", insertedChatRoom);
		
		return resultMap;
	}

	// 채팅리스트 가져오기
	@PostMapping(value = "selectChatList")
	public List<DmVo> selectChatList(@RequestBody Map<String, Object> room_code) {
		logger.info("DM/selectChatList.POST");


		return mongoDmBiz.selectChatList((int) room_code.get("room_code"));
	}
}

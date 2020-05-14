package com.instagram.clone.model.biz.dm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.instagram.clone.model.dao.dm.MongoDmDao;
import com.instagram.clone.model.vo.DmVo;

@Service
public class MongoDmBizImpl implements MongoDmBiz {

	@Autowired
	private MongoDmDao dao;

	@Override
	public DmVo insertChatRoom(DmVo newRoom) {
		return dao.insertChatRoom(newRoom);
	}

	@Override
	public List<DmVo> findMyChatRoomList(int my_member_code) {
		return dao.findMyChatRoomList(my_member_code);
	}

	@Override
	public DmVo findRecentChat(int room_code) {
		return dao.findRecentChat(room_code);
	}

	@Override
	public DmVo insertChat(DmVo newChat) {
		return dao.insertChat(newChat);
	}

	@Override
	public List<DmVo> selectChatList(int room_code) {
		return dao.selectChatList(room_code);
	}

	@Override
	public void removeUnreadMemberCodeList(int room_code, int member_code) {
		dao.removeUnreadMemberCodeList(room_code, member_code);
	}

}

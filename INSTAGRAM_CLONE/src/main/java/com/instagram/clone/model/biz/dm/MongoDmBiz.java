package com.instagram.clone.model.biz.dm;

import java.util.List;

import com.instagram.clone.model.vo.DmVo;

public interface MongoDmBiz {

	public DmVo insertChatRoom(DmVo newRoom);

	public List<DmVo> findMyChatRoomList(int my_member_code);

	public DmVo findRecentChat(int room_code);

	public DmVo insertChat(DmVo newChat);

	public List<DmVo> selectChatList(int room_code);

	public void removeUnreadMemberCodeList(int room_code, int member_code);
}

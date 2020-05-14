package com.instagram.clone.model.dao.dm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.mapreduce.MapReduceResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Repository;

import com.instagram.clone.model.vo.DmVo;
import com.mongodb.client.result.UpdateResult;

@Repository
public class MongoDmDaoImpl implements MongoDmDao {

	@Autowired
	private MongoTemplate mongo;

	@Autowired
	private SequenceGenerator seqGenerator;

	@Override
	public DmVo insertChatRoom(DmVo newRoom) {
		newRoom.setRoom_code((int) seqGenerator.getNextSequenceId(newRoom.ROOM_CODE_SEQ_NAME));
		return mongo.insert(newRoom, "INSTAGRAM");
	}

	@Override
	public List<DmVo> findMyChatRoomList(int my_member_code) {

		String MAP_FUNCTION = "function myMap(){" + //
				"	emit(this.room_code, this.chat_code)" + //
				"}";
		String REDUCE_FUNCTION = "function myReduce(key, values) {" + //
				"	var a = values[0];" + //
				"	for(var i=1; i< values.length; i++){" + //
				"		var b = values[i];" + //
				"		if(b > a){" + //
				"			a = b;" + //
				"		}" + //
				"	}" + //
				"	return a" + //
				"}";

		Query query = new Query();

		Criteria criteria = new Criteria();
		criteria.andOperator(Criteria.where("member_list.member_code").in(my_member_code),
				Criteria.where("chat_code").ne(0));

		query.addCriteria(criteria);	// 내가 참여중이고, chat_code 가 0이 아닌 (메시지가 없는방) 을 제외한 document들을 추출

		Map<String, Object> map = new HashMap<>();
		MapReduceResults<? extends Map> result = mongo.mapReduce(query, "INSTAGRAM", MAP_FUNCTION, REDUCE_FUNCTION,
				map.getClass());	// 맵리듀스, 각 채팅방에서 최대 채팅메시지코드를  추출

		Iterator<? extends Map> iter = result.iterator();
		List<Integer> chat_code_list = new ArrayList<Integer>();
		while (iter.hasNext()) {
			Map<String, Object> resultMap = iter.next();
			chat_code_list.add(((Double) resultMap.get("value")).intValue());
		}

		System.out.println(chat_code_list);

		Query finalQuery = new Query(Criteria.where("chat_code").in(chat_code_list))
				.with(Sort.by(Sort.Direction.DESC, "chat_code"));

		return mongo.find(finalQuery, DmVo.class, "INSTAGRAM");
	}

	@Override
	public DmVo findRecentChat(int room_code) {
		Query query = new Query(Criteria.where("room_code").is(room_code))
				.with(Sort.by(Sort.Direction.DESC, "chat_code")).limit(1);

		return mongo.findOne(query, DmVo.class, "INSTAGRAM");
	}

	@Override
	public DmVo insertChat(DmVo newChat) {
		newChat.setChat_code((int) seqGenerator.getNextSequenceId(newChat.CHAT_CODE_SEQ_NAME));
		return mongo.insert(newChat, "INSTAGRAM");
	}

	@Override
	public List<DmVo> selectChatList(int room_code) {

		Query query = new Query();

		Criteria criteria = new Criteria();
		criteria.andOperator(Criteria.where("room_code").is(room_code), Criteria.where("chat_code").ne(0));

		query.addCriteria(criteria).with(Sort.by(Sort.Direction.ASC, "chat_code"));

		return mongo.find(query, DmVo.class, "INSTAGRAM");
	}

	@Override
	public void removeUnreadMemberCodeList(int room_code, int member_code) {
		Query query = new Query(Criteria.where("room_code").is(room_code));
		Update update = new Update().pull("unread_member_code_list", member_code);

		UpdateResult result = mongo.updateMulti(query, update, DmVo.class, "INSTAGRAM");
	}

}

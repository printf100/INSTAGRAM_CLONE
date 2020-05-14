package com.instagram.clone.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.instagram.clone.model.biz.dm.MongoDmBiz;
import com.instagram.clone.model.vo.DmVo;
import com.instagram.clone.model.vo.MemberJoinProfileSimpleVo;
import com.instagram.clone.model.vo.MemberProfileVo;
import com.instagram.clone.model.vo.MemberVo;

public class EchoHandler extends TextWebSocketHandler {

	@Autowired
	private MongoDmBiz mongoDmBiz;

	private Map<WebSocketSession, Integer> sessionMap = new HashMap<>(); // <세션, 채팅방번호>

	public EchoHandler() {

	}

	// 클라이언트와 연결 이후에 실행되는 메서드
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		sessionMap.put(session, -1);
		System.out.println("WebSocketSession.getId() : " + session.getId());
	}

	// 클라이언트가 서버로 메시지를 전송했을 때 실행되는 메서드
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String verify = message.getPayload().split(",")[0];

		if (verify.equals("enter")) { // session이 채팅방에 입장했을 때
			sendEnterMessage(session, message);
		} else if (verify.equals("chat")) { // session이 채팅을 쳤을때
			sendChatMessage(session, message);
		} else if (verify.equals("out")) { // 채팅방에서 나갓을 때
			sessionMap.put(session, -1);
		}
	}

	private void sendEnterMessage(WebSocketSession session, TextMessage message) throws IOException {
		/*
		 * servlet-context 에서 설정한
		 * org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor
		 * 때문에 WebSocketSession 객체에서 HttpSession 정보를 받아볼 수 있나보다....
		 */
		int member_code = ((MemberVo) session.getAttributes().get("user")).getMember_code();
		int room_code = Integer.parseInt(message.getPayload().split(",")[1]);

		// session 정보에 접속한 방번호를 저장! 원래 존재하던 session은 중복되어 덮어써진다.
		sessionMap.put(session, room_code);
		System.out.println("member_code : " + member_code + "이 채팅방을 열었다아아아아아아!!!!! + " + room_code + "번 방");

		// 해당 방에 unread_member_code_list, 방 입장시 이 리스트에서 자신의 멤버코드를 지운다.
		mongoDmBiz.removeUnreadMemberCodeList(room_code, member_code);

		// 채팅에 접속중인 사람들에게 읽었음을 표시한다.
		DmVo recentChat = mongoDmBiz.findRecentChat(room_code);

		for (WebSocketSession sess : sessionMap.keySet()) {
			if (sessionMap.get(sess) == room_code) {

				JsonObject json = new JsonObject();
				json.addProperty("enter", member_code);

				sess.sendMessage(new TextMessage(json.toString()));
			}
		}
	}

	// 채팅 메시지 보내기
	private void sendChatMessage(WebSocketSession session, TextMessage message) throws IOException {

		int member_code = ((MemberVo) session.getAttributes().get("user")).getMember_code();
		int room_code = Integer.parseInt(message.getPayload().split(",")[1]);
		String chat_message = message.getPayload().split(",")[2];

		System.out.println((room_code + "방, " + session.getId() + ", " + member_code + "로 부터 " + chat_message + " 받음"));

		// 가장 최근 채팅 document를 통해 현재 채팅방에 참여중인 사람들의 정보를 추출
		DmVo recentChat = mongoDmBiz.findRecentChat(room_code);

		// 채팅방에 포함된 사람들의 멤버코드리스트
		List<Integer> unread_member_code_list = new ArrayList<>();
		for (MemberJoinProfileSimpleVo chat_member : recentChat.getMember_list()) {
			unread_member_code_list.add(chat_member.getMember_code());
		}

		// 현재 채팅방에 접속중인 사람은 unread에서 지운다.
		for (WebSocketSession sess : sessionMap.keySet()) {
			if (sessionMap.get(sess) == room_code) {
				unread_member_code_list
						.remove((Integer) ((MemberVo) sess.getAttributes().get("user")).getMember_code());
			}
		}

		// MongoDB에 insert
		DmVo newChat = new DmVo();

		newChat.setRoom_code(room_code);
		newChat.setMember_list(recentChat.getMember_list());
		newChat.setUnread_member_code_list(unread_member_code_list); // 현재는 모두가 읽지않은 상태!
		newChat.setMember_code(member_code);
		newChat.setMessage(chat_message);
		newChat.setMessage_date(new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm").format(new Date()));

		// 소켓통신 이용하여 채팅방에 전송
		for (WebSocketSession sess : sessionMap.keySet()) {
			for (MemberJoinProfileSimpleVo room_member : newChat.getMember_list()) {

				// 채팅방에 참여중인 멤버코드리스트 와 접속중인 멤버코드들 중 일치하는 코드가 있다면 메시지 보냄
				if (room_member.getMember_code() == ((MemberVo) sess.getAttributes().get("user")).getMember_code()) {
					JsonObject json = new JsonObject();
					json.addProperty("chat", "chat");
					json.addProperty("room_code", room_code);
					json.addProperty("member_code", member_code);
					json.addProperty("member_id", ((MemberVo) session.getAttributes().get("user")).getMember_id());
					json.addProperty("member_profile_image_s_name",
							((MemberProfileVo) session.getAttributes().get("profile"))
									.getMember_img_server_name());
					json.addProperty("chat_message", chat_message);
					json.addProperty("chat_message_date", newChat.getMessage_date());

					JsonArray unreadArray = new JsonArray();
					for (Integer unread_member : unread_member_code_list) {
						unreadArray.add(unread_member);
					}
					json.add("unread_member_code_list", unreadArray);

					sess.sendMessage(new TextMessage(json.toString()));
				}
			}
		}

		DmVo insertedChat = mongoDmBiz.insertChat(newChat);
	}

	// 클라이언트와 연결을 끊었을 때 실행되는 메소드
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		sessionMap.remove(session);
		System.out.println(("연결 끊김 : " + session.getId()));
	}

}

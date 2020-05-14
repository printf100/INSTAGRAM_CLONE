package com.instagram.clone.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
public class MemberJoinProfileSimpleVo {

	@NonNull
	private int member_code;

	private String member_email;
	private String member_phone;
	private String member_name;
	private String member_id;

	private String member_img_server_name;

}

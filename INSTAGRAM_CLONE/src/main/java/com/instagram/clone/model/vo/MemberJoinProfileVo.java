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
public class MemberJoinProfileVo {
	
	@NonNull
	private int member_code;

	private String member_email;
	private String member_phone;
	private String member_name;
	private String member_id;
	private String member_password;

	private String sns_type;
	private String sns_id;

	private String member_img_original_name;
	private String member_img_server_name;
	private String member_img_path;

	private String member_website;
	private String member_introduce;
	private String member_gender;

}

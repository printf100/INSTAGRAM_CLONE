package com.instagram.clone.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
public class BoardVo {
	
	@NonNull
	private int board_code;
	
	private int member_code;
	private int channel_code;
	private String board_content;
	private String board_file_original_name;
	private String board_file_sever_name;
	private String board_file_path;
	private Date board_regdate;
	private int board_like_count;
	
	
}

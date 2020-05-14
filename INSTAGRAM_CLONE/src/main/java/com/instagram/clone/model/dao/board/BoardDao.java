package com.instagram.clone.model.dao.board;

import com.instagram.clone.model.vo.BoardVo;

public interface BoardDao {

	String NAMESPACE = "board.";
	
	public int insert(BoardVo vo);
}

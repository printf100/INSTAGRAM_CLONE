package com.instagram.clone.model.dao.board;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.instagram.clone.model.vo.BoardVo;

@Repository
public class BoardDaoImpl implements BoardDao {

	@Autowired
	private SqlSessionTemplate SqlSession;
	
	@Override
	public int insert(BoardVo vo) {
		int res = 0;
		res = SqlSession.insert(NAMESPACE+"insert",vo);
		
		return res;
	}
}

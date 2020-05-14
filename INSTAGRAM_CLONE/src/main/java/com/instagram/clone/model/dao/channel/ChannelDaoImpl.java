package com.instagram.clone.model.dao.channel;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.instagram.clone.model.vo.ChannelVo;
import com.instagram.clone.model.vo.MemberVo;

@Repository
public class ChannelDaoImpl implements ChannelDao {

   @Autowired
   private SqlSessionTemplate sqlSession;
   
   @Override
   public int createPChannel(MemberVo vo) {
      return sqlSession.insert(NAMESPACE + "createChannel", vo);
   }

}
package com.instagram.clone.model.dao.channel;

import com.instagram.clone.model.vo.MemberVo;

public interface ChannelDao {

   String NAMESPACE = "member.";
   
   public int createPChannel(MemberVo vo);
   
}
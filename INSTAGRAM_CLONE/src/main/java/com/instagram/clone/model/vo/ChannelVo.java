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
public class ChannelVo {
   
   @NonNull
   private int channel_code;
   @NonNull
   private int member_code;
   
   private String channel_type;
   private String channel_name;
   private String channel_img_original_name;
   private String channel_img_server_name;
   private String channel_img_path;
   private String channel_website;
   private String channel_pay;
   private String channel_introduce;
   
}
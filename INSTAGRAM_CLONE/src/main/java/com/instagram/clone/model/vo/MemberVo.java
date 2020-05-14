package com.instagram.clone.model.vo;

import com.instagram.clone.ssohandler.domain.entity.Member;

public class MemberVo {

	private int member_code;

	private String member_email;
	private String member_phone;
	private String member_name;
	private String member_id;
	private String member_password;

	private String sns_type;
	private String sns_id;

	public MemberVo() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MemberVo(int member_code, String member_email, String member_phone, String member_name, String member_id,
			String member_password, String sns_type, String sns_id) {
		super();
		this.member_code = member_code;
		this.member_email = member_email;
		this.member_phone = member_phone;
		this.member_name = member_name;
		this.member_id = member_id;
		this.member_password = member_password;
		this.sns_type = sns_type;
		this.sns_id = sns_id;
	}

	public MemberVo(int member_code) {
		super();
		this.member_code = member_code;
	}

	public MemberVo(String member_email, String sns_type, String sns_id) {
		this.member_email = member_email;
		this.sns_type = sns_type;
		this.sns_id = sns_id;
	}

	public MemberVo(Member member) {
		this.member_code = member.getMembercode();
		this.member_email = member.getMemberemail();
		this.member_phone = member.getMemberphone();
		this.member_name = member.getMembername();
		this.member_id = member.getMemberid();
		this.member_password = member.getMemberpassword();
		this.sns_type = member.getSnstype();
		this.sns_id = member.getSnsid();
	}

	public int getMember_code() {
		return member_code;
	}

	public void setMember_code(int member_code) {
		this.member_code = member_code;
	}

	public String getMember_email() {
		return member_email;
	}

	public void setMember_email(String member_email) {
		this.member_email = member_email;
	}

	public String getMember_phone() {
		return member_phone;
	}

	public void setMember_phone(String member_phone) {
		this.member_phone = member_phone;
	}

	public String getMember_name() {
		return member_name;
	}

	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getMember_password() {
		return member_password;
	}

	public void setMember_password(String member_password) {
		this.member_password = member_password;
	}

	public String getSns_type() {
		return sns_type;
	}

	public void setSns_type(String sns_type) {
		this.sns_type = sns_type;
	}

	public String getSns_id() {
		return sns_id;
	}

	public void setSns_id(String sns_id) {
		this.sns_id = sns_id;
	}

	@Override
	public String toString() {
		return "MemberVo [member_code=" + member_code + ", member_email=" + member_email + ", member_phone="
				+ member_phone + ", member_name=" + member_name + ", member_id=" + member_id + ", member_password="
				+ member_password + ", sns_type=" + sns_type + ", sns_id=" + sns_id + "]";
	}

}
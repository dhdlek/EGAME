package com.game.web.model;

import java.io.Serializable;

public class Friend implements Serializable{

	private static final long serialVersionUID = 1L;

	private String userId;			//유저(본인)아이디
	private String frUserId;		//유저(친구)아이디
	private String frStatus;		//친구 스테이터스(1:신청, 2:수락대기, 3:거절, 4:친구)
	
	private String userNickname;	//유저 닉네임
	private String userEmail;		//유저 이메일
	private String userImg;			//유저 썸네일 이미지(형식: 유저아이디.jpg)
	
	private long startRow;			//시작 rownum
	private long endRow;			//끝 rownum
	
	public Friend() {
		userId = "";
		frUserId = "";
		frStatus = "";
		
		userNickname = "";
		userEmail = "";
		userImg = "";
				
		startRow = 0;
		endRow = 0;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFrUserId() {
		return frUserId;
	}

	public void setFrUserId(String frUserId) {
		this.frUserId = frUserId;
	}

	public String getFrStatus() {
		return frStatus;
	}

	public void setFrStatus(String frStatus) {
		this.frStatus = frStatus;
	}

	//오버로딩
	public void setFrStatus(Friend friend) {
		this.frStatus = friend.frStatus;
	}

	public String getUserNickname() {
		return userNickname;
	}

	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserImg() {
		return userImg;
	}

	public void setUserImg(String userImg) {
		this.userImg = userImg;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
}

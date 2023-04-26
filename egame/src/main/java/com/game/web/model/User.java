package com.game.web.model;

import java.io.Serializable;

public class User implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private String userId;			//유저 아이디
	private String userPwd;			//유저 비밀번호
	private String userName;		//유저 이름
	private String userNickname;	//유저 닉네임
	private String userEmail;		//유저 이메일
	private String userBirth;		//유저 생년월일
	private String businessNum;		//유저 사업자 번호
	private String userRegDate;		//유저 가입 일자
	private String userImg;			//유저 썸네일 이미지(형식: 유저아이디.jpg)
	private long pointPos;			//유저 보유 포인트
	private char userStatus;    	//유저 스테이터스(정상, 정지, 휴면)
	private char userClass;			//유저 계층(유저, 판매자, 관리자)

	private long amount;			//상품 매출액
	private long totalAmount;		//상품 총 매출액
	
	private String searchType;			//검색타입
	private String searchValue;			//검색 값
	private long startRow;				//상품페이징 시작번호
	private long endRow;				//상품 페이징 끝 번호
	
	public User()
	{
		userId = "";
		userPwd = "";
		userName = "";
		userNickname = "";
		userEmail = "";
		userBirth = "";
		businessNum = "";
		userRegDate = "";
		userImg = "";
		pointPos = 0;				
		userStatus = ' ';
		userClass = ' ';
		
		amount = 0;
		totalAmount = 0;
		
		searchType = "";
		searchValue = "";
		startRow = 0;
		endRow = 0;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

	public String getUserBirth() {
		return userBirth;
	}

	public void setUserBirth(String userBirth) {
		this.userBirth = userBirth;
	}

	public String getBusinessNum() {
		return businessNum;
	}

	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}

	public String getUserRegDate() {
		return userRegDate;
	}

	public void setUserRegDate(String userRegDate) {
		this.userRegDate = userRegDate;
	}

	public String getUserImg() {
		return userImg;
	}

	public void setUserImg(String userImg) {
		this.userImg = userImg;
	}

	public long getPointPos() {
		return pointPos;
	}

	public void setPointPos(long pointPos) {
		this.pointPos = pointPos;
	}

	public char getUserStatus() {
		return userStatus;
	}

	public void setUserStatus(char userStatus) {
		this.userStatus = userStatus;
	}

	public char getUserClass() {
		return userClass;
	}

	public void setUserClass(char userClass) {
		this.userClass = userClass;
	}
	
	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

	public long getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(long totalPrice) {
		this.totalAmount = totalPrice;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
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

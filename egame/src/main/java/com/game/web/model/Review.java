package com.game.web.model;

import java.io.Serializable;

public class Review implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private long reviewSeq;
	private long productSeq;
	private String userId;
	private String reviewContent;
	private String reviewRegDate;
	private long reviewGood;
	private long productGrade;
	private String userImg;
	private String userNickName;
	
	private long startRow;				//상품페이징 시작번호
	private long endRow;				//상품 페이징 끝 번호
	
	public Review()
	{
		reviewSeq = 0;
		productSeq = 0;
		userId="";
		reviewContent = "";
		reviewRegDate = "";
		reviewGood = 0;
		productGrade = 0;
		userImg = "";
		userNickName = "";
		
		startRow = 0;
		endRow = 0;
	}
	
	
	public String getUserNickName() {
		return userNickName;
	}


	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
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

	public String getUserImg() {
		return userImg;
	}
	public void setUserImg(String userImg) {
		this.userImg = userImg;
	}
	public long getReviewSeq() {
		return reviewSeq;
	}
	public void setReviewSeq(long reviewSeq) {
		this.reviewSeq = reviewSeq;
	}
	public long getProductSeq() {
		return productSeq;
	}
	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getReviewContent() {
		return reviewContent;
	}
	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}
	public String getReviewRegDate() {
		return reviewRegDate;
	}
	public void setReviewRegDate(String reviewRegDate) {
		this.reviewRegDate = reviewRegDate;
	}
	public long getReviewGood() {
		return reviewGood;
	}
	public void setReviewGood(long reviewGood) {
		this.reviewGood = reviewGood;
	}
	public long getProductGrade() {
		return productGrade;
	}
	public void setProductGrade(long productGrade) {
		this.productGrade = productGrade;
	}
	
	
	
}

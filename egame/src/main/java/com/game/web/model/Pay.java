package com.game.web.model;

import java.io.Serializable;

public class Pay implements Serializable
{
	private static final long serialVersionUID = 1L;

	private long paySeq;			//결제 번호
	private long productSeq;		//상품 번호
	private String userId;			//유저 아이디
	private long payPrice;			//결제 가격
	private String payDate;			//결제 날짜
	private String payStatus;		//결제 상태(1: 구매, 0: 환불)
	private String payMethod;		//결제 구분(c: 현금, p: 포인트)
	
	private String userSellerId;	//판매 아이디
	private String productName;		//상품 이름
	private char productStatus;		//상품 스테이터스
	
	private String pointStatus;		//포인트 스테이터스 (더하기,빼기)
	private String pointDate;		//포인트내역 날짜
	
	private long startRow;			//시작 rownum
	private long endRow;			//끝 rownum
	
	public Pay()
	{
		paySeq = 0;
		productSeq = 0;
		userId = "";
		payPrice = 0;
		payDate = "";
		payStatus = "";
		payMethod = "";
		
		userSellerId = "";
		productName = "";
		productStatus = ' ';
		
		pointStatus = "";
		pointDate = "";
		
		startRow = 0;
		endRow = 0;
	}

	public long getPaySeq() {
		return paySeq;
	}

	public void setPaySeq(long paySeq) {
		this.paySeq = paySeq;
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

	public long getPayPrice() {
		return payPrice;
	}

	public void setPayPrice(long payPrice) {
		this.payPrice = payPrice;
	}

	public String getPayDate() {
		return payDate;
	}

	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}

	public String getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}
	
	public String getUserSellerId() {
		return userSellerId;
	}

	public void setUserSellerId(String userSellerId) {
		this.userSellerId = userSellerId;
	}
	
	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	public char getProductStatus() {
		return productStatus;
	}

	public void setProductStatus(char productStatus) {
		this.productStatus = productStatus;
	}

	public String getPointStatus() {
		return pointStatus;
	}

	public void setPointStatus(String pointStatus) {
		this.pointStatus = pointStatus;
	}

	public String getPointDate() {
		return pointDate;
	}

	public void setPointDate(String pointDate) {
		this.pointDate = pointDate;
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
